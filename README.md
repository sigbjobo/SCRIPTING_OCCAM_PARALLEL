# Interface for running the parallel version of occam easily

Because of efficiency reasons, the parallel version of OCCAM divides input- and outputfiles into CPU-specific files. Preparing and finalizing the results can be cumbersome and challenging. Here I provide a set of bash and python scripts that can be used to run the parallel version on supercomputers without ever having to look at the cpu-specific input files.

## set_paths.sh
Before using any of the scripts, I recommend settings paths for the the job-scripts. This can be done automatically by entering:
    - bash set_paths.sh

