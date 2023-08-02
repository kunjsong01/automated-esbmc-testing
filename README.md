# automated-esbmc-testing
Use a modified version of testing_tool.py to run a set of benchmarks comparing v2.1 and v7.3

  - esbmc-cpp: C++ benchmarks from esbmc v7.3
  - testing_tool_old.py: a modified script based on the old testing_tool.py that can take -I ~/libraries for the old ESBMC
  - esbmc_binary.zip: contains the binaries for v2.1 and v7.3 (or any other pairs to experiment with). Need to unzip before use

  ESBMC binaries are too large for Git. Tried git lfs but tricky to use it in Actions.

