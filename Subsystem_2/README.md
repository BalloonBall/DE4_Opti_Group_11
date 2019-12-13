Subsystem_2: Safety
=======

*Minimising peak linear acceleration in helmet impact testing*


Main script 
-------
The subsystem_2.m MATLAB script should be run.

Please make sure the datafiles:material_liner.csv and material_shell.csv are in the same directory with the main script.

Execution Environment
-------
Processor: AMD Ryzen PRO 3300U 2.10GHz

System: Windows 10 Home

Execution time
-------

The execution time is approximately 35 seconds.

- 5 seconds for data import and processing.
- 29.80 seconds for interior-point method.
- 1.032 seconds for SQP method.
- 0.6824 seconds for active-set method.

Script for graphics
-------
The variable_link.m MATLAB script provides plots that indicate the correlation of different material properties, which helped in generating surrogate models.

The visualize_pla.m MATLAB script provides a surface plot showing the effect of liner thickness and liner density to the peak linear acceleration, without considering the shell.

To excute, please make sure the datafiles:material_liner.csv and material_shell.csv are in the same directory with the scripts.

Dependencies
-------
The script requires:
- MATLAB_R2019b
- MATLAB Global Optimization Toolbox
