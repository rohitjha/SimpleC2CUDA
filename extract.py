#!/usr/bin/python

import sys

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

	kernelhu = "#include \"cuda.h\"\n\n__global__ void kernel0();"
	kernelcu = "#include \"" + fkernelcu + "\"\n\n__global__ void kernel0(){}"

	# get array variable names and sizes
	# update code for _kernel.hu and store in kernelhu
	# update code for _kernel.cu and store in kernelhu
	
	# create code for _host.cu and store in hostcu
	host_cu = extractNotFromPragmaScop(fname)
	host_cu = "#include \"" + fkernelhu + "\"\n" + host_cu
	print(host_cu)
	
	kernel_cu = extractFromPragmaScop(fname)
	print("\nscop extracted:")
	print(kernel_cu)

if __name__ == '__main__':
	main()