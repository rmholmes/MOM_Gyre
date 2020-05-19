% Make SST and SSS restoring files for MOM-Gyre simulation.

gname = 'grid_spec.nc';
mname = 'salt_sfc_restore_MOM025.nc';
sname = 'salt_sfc_restore.nc';
tname = 'temp_sfc_restore.nc';
delete(sname);
delete(tname);

% Gyre spatial grid info:
xT = ncread(gname,'grid_x_T');xL = length(xT);
yT = ncread(gname,'grid_y_T');yL = length(yT);
dx = xT(2)-xT(1);
dy = yT(2)-yT(1);

% salt_restore_tscale file structure from MOM025 Control:
S = ncinfo(mname);
time = ncread(mname,'TIME');

% alter properties:
S.Dimensions(1).Length = xL;
S.Dimensions(2).Length = yL;
S.Dimensions(3) = [];
S.Variables(1).Size = xL;
S.Variables(1).Dimensions(1).Length = xL;
S.Variables(2).Size = yL;
S.Variables(2).Dimensions(1).Length = yL;
S.Variables(3) = [];
S.Variables(4) = [];
S.Variables(4).Size = [xL yL 12];
S.Variables(4).Dimensions(1).Length = xL;
S.Variables(4).Dimensions(2).Length = yL;
S.Variables(4).Attributes(1).Value = 'SSS';
S.Variables(4).Attributes(3) = [];
S.Variables(4).Attributes(3) = [];

ncwriteschema('salt_sfc_restore.nc',S);
S.Variables(4).Name = 'TEMP';
S.Variables(4).Attributes(1).Value = 'SST';
S.Variables(4).Attributes(2).Value = 'degC';
ncwriteschema('temp_sfc_restore.nc',S);

ncwrite(sname,'XT_OCEAN',xT);
ncwrite(tname,'XT_OCEAN',xT);
ncwrite(sname,'YT_OCEAN',yT);
ncwrite(tname,'YT_OCEAN',yT);
ncwrite(sname,'TIME',time);
ncwrite(tname,'TIME',time);

% make SST and SSS fields:
SST_S = 22.0;
SST_N = 18.0;
SSS_S = 36.0;
SSS_N = 32.0;

[X,Y] = ndgrid(xT,yT);

SST = (SST_N-SST_S)*(Y-(yT(1)-dy/2))/(yT(end)-yT(1)+dy)+SST_S;
SSS = (SSS_N-SSS_S)*(Y-(yT(1)-dy/2))/(yT(end)-yT(1)+dy)+SSS_S;

ncwrite(sname,'SALT',SSS);
ncwrite(tname,'TEMP',SST);

