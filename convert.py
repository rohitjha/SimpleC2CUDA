#!/usr/bin/python

import sys
import re
from math import ceil

def findArrayVarName(fileName):
	source = open(fileName, "r")
	inputLineByLine = source.readlines()
	source.close()

	#int array
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



def removeExtraParen(code):
	diff = code.count('}') - code.count('{')
	correctCode = code

	if diff > 0:
		revCode = code[::-1]
		revCode = revCode.replace('}', '', diff)
		correctCode = revCode[::-1]
		
	return correctCode



def main():
	# Get original file name
	if len(sys.argv) != 2:
		print "Error: Please specify an input C file to transform as argument."
		sys.exit()

	fname = sys.argv[1]
	name = fname.split('/')[1][:-2]

	# create names of target files
	fhostcu = name + "_host.cu"
	fkernelcu = name + "_kernel.cu"
	fkernelhu = name + "_kernel.hu"


	# Code for _kernel.hu and _kernel.cu
	kernelhu = "#include \"cuda.h\"\n\n__global__ void kernel0("
	kernelcu = "#include \"" + fkernelhu + "\"\n\n__global__ void kernel0("
	
	# get array variable names and dimensions
	#print findArrayVarName(fname)
	(varlist, dimList, sizeList) = findArrayVarName(fname)

	for var in varlist:
		varptr = 'int *' + str(var) + ', '
		kernelhu += varptr
		kernelcu += varptr

	
	# Code for _kernel.hu
	kernelhu = kernelhu[:-2] + ');\n'
	#print(kernelhu)

	# Write _kernel.hu to file
	fkhu = open(fkernelhu, "w")
	fkhu.write(kernelhu)
	fkhu.close()
	print("Created file " + fkernelhu)
	

	

	# Code for _kernel.cu
	kernelcu = kernelcu[:-2] + ')\n{\n\t'
	
	maxDim = max(dimList)
	maxSize = max(sizeList)
	blockIdx = ""
	threadIdx = ""

	for i in range(maxDim):
		blockIdx += "int b" + str(i) + " = blockIdx." + chr(ord('x') + maxDim - i - 1) + ";\n\t"
		threadIdx += "int t" + str(i) + " = threadIdx." + chr(ord('x') + maxDim - i - 1) + ";\n\t"

	kernelcu += blockIdx + threadIdx
	kernelcu += "{\n"

	kernel_cu = extractFromPragmaScop(fname)
	codelines = ""
	skipFor = 0
	dimString = ""

	

	if maxDim == 1:
		dimString = "[t0]"
	elif maxDim == 2:
		dimString = "[t0*" + str(maxSize) + "+t1]"
	

	
	for line in kernel_cu.split('\n'):
		if '#pragma' not in line:
			if 'for' in line:
				skipFor += 1
			if skipFor > 2 or 'for' not in line:
				codelines += line + "\n"

	
	
	updatedCodeLines = []
	

	# replace [i] with [t0]
	if maxDim == 1:
		for line in codelines.split('\n'):
			if '[' in line:
				indexOpen = line.index('[')
				indexClose = line.index(']')
				var = line[indexOpen:indexClose+1]
				
				if not var[1:-1].isdigit():
					updatedCodeLines.append(line.replace(var, dimString))
				else:
					updatedCodeLines.append(line)
			else:
				updatedCodeLines.append(line)

	

	# replace [i][j] with [t0*dim+t1]
	# doesnt work for mul.c
	elif maxDim == 2:
		for line in codelines.split('\n'):
			if '[' in line:
				indexOpen = line.index('[')
				indexClose = line.index(']') # need to find second occurrence of ]
				indexClose = line.index(']', indexClose+1)
				var = line[indexOpen:indexClose+1]
				updatedCodeLines.append(line.replace(var, dimString))
			else:
				updatedCodeLines.append(line)

	

	updatedCodeLines = '\n'.join(updatedCodeLines)
	
	

	kernelcu += updatedCodeLines
	kernelcu += "\n\t}\n}\n"
	kernelcu = removeExtraParen(kernelcu)
	#print(kernelcu)
	

	# Write _kernel.cu to file
	fkcu = open(fkernelcu, "w")
	fkcu.write(kernelcu)
	fkcu.close()
	print("Created file " + fkernelcu)
	

	
	# create code for _host.cu and store in hostcu
	host_cu = extractNotFromPragmaScop(fname)
	host_cu = "#include \"" + fkernelhu + "\"\n" + host_cu
	#print(host_cu)
	
	#add new code to the line where "#pragma scop" is
	insertPosition = host_cu.find('#pragma scop')

	if 'for' in host_cu[insertPosition:]:
		# add int * vars
		dev_varptr = []
		dev_vars = []
		for var in varlist:
			dev_varptr.append("int *dev_" + str(var) + ";\n")
			dev_vars.append("dev_" + str(var))
		
		dev_varptr = ''.join(dev_varptr)

		

		# do cuda malloc for all vars
		line = ""
		for var in dev_vars:
			line += "cudaMalloc((void **) &" + str(var) + ", "
			for dim in range(maxDim):
				line += "(" + str(maxSize) + ") *"
			line += " sizeof(int);\n"

		#add line
		host_cu = host_cu[:insertPosition] + "\n" + dev_varptr + "\n" + line + "\n" + host_cu[insertPosition:]



		# find input var/vars and output var
		inputvars = []
		outputvars = []

		for line in extractFromPragmaScop(fname).split('\n'):
			if '=' in line:
				pos = line.index('=')
				valid = True
				for var in varlist:
					if var in line[:pos]:
						outputvars.append(var)
					elif var in line[pos:]:
						inputvars.append(var)

		#print inputvars
		#print outputvars
		

		# do cudamemcpy from host to device for input vars
		imemcpy = ""
		for ivar in inputvars:
			imemcpy += "cudaMemcpy(dev_" + ivar + ", " + ivar + ", (" + str(maxSize) + ") * sizeof(int), cudaMemcpyHostToDevice);\n"

		insertPosition = host_cu.find('#pragma scop')
		host_cu = host_cu[:insertPosition] + imemcpy + "\n" + host_cu[insertPosition:]

		

		# dimblock
		numThreads = maxSize
		numBlocks = []
		for i in range(maxDim):
			if numThreads >= 32:
				numBlocks.append(32)
			else:
				numBlocks.append(numThreads)

		blockline = "{\n\tdim3 k0_dimBlock("
		for i in numBlocks:
			blockline += str(i) + ", "
		
		blockline = blockline[:-2]
		
		blockline += ");\n"

		insertPosition = host_cu.find('#pragma scop')
		host_cu = host_cu[:insertPosition] + blockline + host_cu[insertPosition:]

		

		# dimgrid
		numGrids = []
		for i in numBlocks:
			numGrids.append(int(ceil(numThreads/float(i))))

		gridline = "\tdim3 k0_dimGrid("
		for i in numGrids:
			gridline += str(i) + ", "
		
		gridline = gridline[:-2]
		
		gridline += ");\n"

		insertPosition = host_cu.find('#pragma scop')
		host_cu = host_cu[:insertPosition] + gridline + host_cu[insertPosition:]
		
		
		
		# call kernel0
		call = "kernel0 <<<k0_dimGrid, k0_dimBlock>>> ("
		for i in dev_vars:
			call += i + ", "

		if len(dev_vars) > 1:
			call = call[:-2]

		call += ");\n"

		insertPosition = host_cu.find('#pragma scop')
		host_cu = host_cu[:insertPosition] + "\t" + call + "}\n\n" + host_cu[insertPosition:]
		

		
		# cudamemcpy from device to host for output var
		omemcpy = ""
		for ovar in outputvars:
			omemcpy += "cudaMemcpy(" + ovar + ", dev_" + ovar + ", (" + str(maxSize) + ") * sizeof(int), cudaMemcpyDeviceToHost);\n"

		insertPosition = host_cu.find('#pragma scop')
		host_cu = host_cu[:insertPosition] + omemcpy + "\n" + host_cu[insertPosition:]


		
		# call cudafree on all vars
		freeline = ""
		for var in dev_vars:
			freeline += "cudaFree(" + str(var) + ");\n"

		insertPosition = host_cu.find('#pragma scop')
		host_cu = host_cu[:insertPosition] + freeline + host_cu[insertPosition:]

	
	else:
		# Since there are no loops, we dont need to add CUDA code. Copy the original code as it is.
		content = extractFromPragmaScop(fname)
		updatedContent = []
		for line in content.split('\n'):
			if '#pragma' not in line:
				updatedContent.append(line)
		updatedContent = '\n'.join(updatedContent)

		host_cu = host_cu[:insertPosition] + updatedContent + host_cu[insertPosition:]

	

	#Remove all "#pragma scop" (and "#pragma endscop", if any)
	host_cu = host_cu.replace('#pragma scop', '')
	host_cu = host_cu.replace('#pragma endscop', '')
	#print host_cu


	# Write _host.cu to file
	fhcu = open(fhostcu, "w")
	fhcu.write(host_cu)
	fhcu.close()
	print("Created file " + fhostcu)
	# DONE


if __name__ == '__main__':
	main()