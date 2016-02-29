SimpleC2CUDA
============

Generates host and device CUDA code from regular C programs.

To run, call:

$ python convert.py tests/file.c

It generates file_kernel.hu, file_kernel.cu, containing code for the CUDA
device. Need to generate file_host.cu as well.


You can try out a.c, add.c, dead.c and live_out.c from tests/.
