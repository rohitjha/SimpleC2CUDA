#!/usr/bin/python

import sys
import re

def findArrayVarName(fileName):
	source = open(fileName, "r")
	inputLineByLine = source.readlines()
	source.close()

	arrayVarPattern = re.compile('int(\s)+((\w)+)((\[(\d)*\]))+(.)*;')

	names = []
	dims = []
	sizes = []

	for line in inputLineByLine:
		list1 = re.split(arrayVarPattern, line)
		if len(list1) >= 3:
			list1 = list1[2:]
			#print list1
			names.append(list1[0]) # got name

			size = list1[2]
			if len(size) > 2:
				size = int( size[1 : (len(size) - 1)] )
			else:
				if len(sizes) > 0:
					size = max(sizes)
				else:
					size = 0
			sizes.append(size)

	# now find size of array/matrix
	for line in inputLineByLine:
		list1 = re.split(arrayVarPattern, line)
		if len(list1) >= 3:
			countOpen = line.count("[")
			countClosed = line.count("]")

			if countOpen == countClosed:
				dims.append(countOpen)
			# count num of [ and ]

	#print (names, dims)
	return (names, dims, sizes)

def extractNotFromPragmaScop(fileName):
	source = open(fileName, "r")
	inputLineByLine = source.readlines()
	source.close()

	finalCode = []

	copy = True

	for line in inputLineByLine:
		if '#pragma scop' in line:
			finalCode.append(line)	#keep #pragma scop
			copy = False
		elif '#pragma endscop' in line:
			copy = True
		else:
			if copy: finalCode.append(line)

	#for code in finalCode:
	#	print code[:-1]

	loc = [code for code in finalCode]
	loc = ''.join(loc)
	return loc

def extractFromPragmaScop(fileName):
	# read input C program
	source = open(fileName, "r")
	inputLineByLine = source.readlines()
	source.close()

	scopLines = []
	startCopying = False
	scopCopied = False
	endscopCopied = False

	# extract everything that is in #pragma scop
	for line in inputLineByLine:
		if '#pragma scop' in line:
			#start copying next line to scopLines
			startCopying = True
			if not scopCopied:
				scopLines.append(line)
				scopCopied = True

		elif '#pragma endscop' in line:
			#stop copying
			startCopying = False
			if not endscopCopied:
				scopLines.append(line)
				#endscopCopied = True

		# a line between scop and endscop
		if startCopying and '#pragma scop' not in line:
			scopLines.append(line)


	# remove interstitial #pragma scop and #pragma endscop

	for i in range(0, len(scopLines) - 1):
		if ('#pragma endscop' in scopLines[i]) and ('#pragma scop' not in scopLines[i+1]):
			scopLines[i] = "\n"


	loc = [line for line in scopLines]
	return ''.join(loc)


def main():
	fname = sys.argv[1]
	name = fname.split('/')[1][:-2]

	fhostcu = name + "_host.cu"
	fkernelcu = name + "_host.cu"
	fkernelhu = name + "_host.hu"

	kernelhu = "#include \"cuda.h\"\n\n__global__ void kernel0("
	kernelcu = "#include \"" + fkernelhu + "\"\n\n__global__ void kernel0("

	

	# get array variable names and dimensions
	print findArrayVarName(fname)
	(varlist, dimList, sizeList) = findArrayVarName(fname)

	for var in varlist:
		varptr = 'int *' + str(var) + ', '
		kernelhu += varptr
		kernelcu += varptr

	

	# CODE FOR _kernel.hu
	kernelhu = kernelhu[:-2] + ');\n'
	#print(kernelhu)
	
	fkhu = open(fkernelhu, "w")
	fkhu.write(kernelhu)
	fkhu.close()
	

	# CODE FOR _kernel.cu
	kernelcu = kernelcu[:-2] + ')\n{\n\t'
	
	maxDim = max(dimList)
	blockIdx = ""
	threadIdx = ""

	for i in range(maxDim):
		blockIdx += "int b" + str(i) + " = blockIdx." + chr(ord('x') + maxDim - i - 1) + ";\n\t"
		threadIdx += "int t" + str(i) + " = threadIdx." + chr(ord('x') + maxDim - i - 1) + ";\n\t"

	kernelcu += blockIdx + threadIdx

	kernelcu += "{\n\t"
	#add code

	kernel_cu = extractFromPragmaScop(fname)

	codelines = ""
	skipFor = 0
	dimString = ""

	if maxDim == 1:
		dimString = "[t0]"
	elif maxDim == 2:
		dimString = "[t0*" 

	for line in kernel_cu.split('\n'):
		if '#pragma' not in line:# and skipFor < 2:
			if 'for' in line:
				skipFor += 1
			if skipFor > 2 or 'for' not in line:
				codelines += line + "\n"
			#do something on codelines to convert to CUDA

	
	#print(kernel_cu)
	kernelcu += codelines#kernel_cu
	kernelcu += "\n\t}\n}"
	print(kernelcu)
	

	# create code for _host.cu and store in hostcu
	host_cu = extractNotFromPragmaScop(fname)
	host_cu = "#include \"" + fkernelhu + "\"\n" + host_cu
	#print(host_cu)

if __name__ == '__main__':
	main()