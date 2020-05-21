%
% To make the highresolution domain you need to:
%
% Run "tcsh ocean_grid_generator.csh" in
% /g/data/e14/rmh561/software/MOM5/src/preprocessing/generate_grids/ocean/
%
% This will generate the grid_spec.nc grid file.
%
% Run "tcsh regrid_2d" in
% /g/data/e14/rmh561/software/MOM5/src/preprocessing/regrid_2d/
%
% to regrid the tau fields.
% Run "tcsh regrid_3d" in
% /g/data/e14/rmh561/software/MOM5/src/preprocessing/regrid_2d/
%
% to regrid the temp and salt IC fields.
%
% Make sure you put the "tcsh" not "./" as it needs to be the right shell.
