% Make SST and SSS restoring files for MOM-Gyre simulation.

base = '/scratch/e14/rmh561/mom/input/gyre1/';
gname = [base 'grid_spec.nc'];
% $$$ mname = 'salt_sfc_restore_MOM025.nc';
% $$$ sname = 'salt_sfc_restore.nc';
% $$$ tname = 'temp_sfc_restore.nc';
% $$$ delete(sname);
% $$$ delete(tname);
% $$$ 
% Gyre spatial grid info:
xT = ncread(gname,'grid_x_T');xL = length(xT);
yT = ncread(gname,'grid_y_T');yL = length(yT);
dx = xT(2)-xT(1);
dy = yT(2)-yT(1);
% $$$ 
% $$$ % salt_restore_tscale file structure from MOM025 Control:
% $$$ S = ncinfo(mname);
% $$$ time = ncread(mname,'TIME');
% $$$ tL = length(time);
% $$$ 
% $$$ % alter properties:
% $$$ S.Dimensions(1).Length = xL;
% $$$ S.Dimensions(2).Length = yL;
% $$$ S.Dimensions(3) = [];
% $$$ S.Variables(1).Size = xL;
% $$$ S.Variables(1).Dimensions(1).Length = xL;
% $$$ S.Variables(2).Size = yL;
% $$$ S.Variables(2).Dimensions(1).Length = yL;
% $$$ S.Variables(3) = [];
% $$$ S.Variables(4) = [];
% $$$ S.Variables(4).Size = [xL yL tL];
% $$$ S.Variables(4).Dimensions(1).Length = xL;
% $$$ S.Variables(4).Dimensions(2).Length = yL;
% $$$ S.Variables(4).Attributes(1).Value = 'SSS';
% $$$ S.Variables(4).Attributes(3) = [];
% $$$ S.Variables(4).Attributes(3) = [];
% $$$ 
% $$$ ncwriteschema('salt_sfc_restore.nc',S);
% $$$ S.Variables(4).Name = 'TEMP';
% $$$ S.Variables(4).Attributes(1).Value = 'SST';
% $$$ S.Variables(4).Attributes(2).Value = 'degC';
% $$$ ncwriteschema('temp_sfc_restore.nc',S);
% $$$ 
% $$$ ncwrite(sname,'XT_OCEAN',xT);
% $$$ ncwrite(tname,'XT_OCEAN',xT);
% $$$ ncwrite(sname,'YT_OCEAN',yT);
% $$$ ncwrite(tname,'YT_OCEAN',yT);
% $$$ ncwrite(sname,'TIME',time);
% $$$ ncwrite(tname,'TIME',time);
% $$$ 
% make SST and SSS fields:
SST_S = 22.0;
SST_N = 18.0;
SSS_S = 36.0;
SSS_N = 32.0;

[X,Y] = ndgrid(xT,yT);

SST = (SST_N-SST_S)*(Y-(yT(1)-dy/2))/(yT(end)-yT(1)+dy)+SST_S;
SSS = (SSS_N-SSS_S)*(Y-(yT(1)-dy/2))/(yT(end)-yT(1)+dy)+SSS_S;
% $$$ 
% $$$ ncwrite(sname,'SALT',repmat(SSS,[1 1 tL]));
% $$$ ncwrite(tname,'TEMP',repmat(SST,[1 1 tL]));

% Make Salinity IC:
iname = [base 'ocean_temp_salt.res.nc'];
iname_out = [base 'ocean_temp_salt_salthor.res.nc'];
salt = ncread(iname,'salt');
[xL,yL,zL] = size(salt);

salt_int = (SSS_N+SSS_S)/2;

spl = 10;
vfunc = flipud(cat(1,zeros(spl,1),[0:1:(zL-spl-1)]'/(zL-spl-1)));
salt = salt_int*ones(xL,yL,zL) + ...
       permute(vfunc,[2 3 1]).*repmat(SSS-salt_int,[1 1 zL]);

ncwrite(iname_out,'salt',salt);



