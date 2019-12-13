This is the README for the Subsystem_3: Sustainability (Neel Le Penru)
=======
Main scripts
-------
Please ensure all files, except for images, are kept in the same directory when the code is run, as it refers to the various MATLAB functions and csv / xlsx files (note that the code creates the 'allData.csv' and 'safeData.csv' files, so they are overwritten if already present in the directory).

The following MATLAB scripts should be run this order:
1. SustBasicAlgebraicModel.m - this provides the graph for the analytical, graphical approach from the interim review
2. SustDiscSolverAll.m - this implements the first, discrete optimisation approach, which simply evaluates the objective function for every foam in our material database.
3. SustGaAll.m - This performs GA to propose a hypothetical material made from any of the foams in our material database.
4. SustGaSafe.m - This performs GA to propose a hypothetical material made from only those foams in our material database that meet a safety requirement (in the form of a minimum thickness constraint). 

The above scripts will produce all graphs in the Sustainability Subsystem section of the report. Images of those graphs, incuding some additional angles of the 3D plots, are also uploaded. Note that the remaining '.m' files are all functions employed by the above scripts. 

Execution time
-------
The execution times should be around 2.5s for 'SustDiscSolver.m' and 11s for the GA scripts.

Dependencies
-------
The script requires only MATLAB_R2019B with the Global Optimisation toolbox installed. Again, ensure all files (other than images) are in the same directory before running any of the code files.

Thank you!
