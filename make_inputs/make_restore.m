% Make SST and SSS restoring files for MOM-Gyre simulation.

base = '/scratch/e14/rmh561/mom/input/mom_ra/';
gname = [base 'grid_spec.nc'];

% Gyre spatial grid info:
xT = ncread(gname,'grid_x_T');xL = length(xT);
yT = ncread(gname,'grid_y_T');yL = length(yT);
zt = ncread(gname,'zt'); zL = length(zt);
dx = xT(2)-xT(1);
dy = yT(2)-yT(1);


%%% SST restoring file:
mname = [base 'salt_sfc_restore_MOM025.nc'];
tname = [base 'temp_sfc_restore.nc'];
delete(tname);


% salt_restore_tscale file structure from MOM025 Control:
S = ncinfo(mname);
% $$$ time = ncread(mname,'TIME');
% $$$ tL = length(time);
time = 0:1:364;
tL = length(time);

% alter properties:
S.Dimensions(1).Length = xL;
S.Dimensions(2).Length = yL;
S.Dimensions(3).Length = tL
S.Variables(3).Dimensions(1).Length = tL;
S.Variables(1).Size = xL;
S.Variables(1).Dimensions(1).Length = xL;
S.Variables(2).Size = yL;
S.Variables(2).Dimensions(1).Length = yL;
S.Variables(3) = [];
S.Variables(4) = [];
S.Variables(4).Size = [xL yL tL];
S.Variables(4).Dimensions(1).Length = xL;
S.Variables(4).Dimensions(2).Length = yL;
S.Variables(4).Dimensions(3).Length = tL;
S.Variables(4).Attributes(3) = [];
S.Variables(4).Attributes(3) = [];

S.Variables(4).Name = 'TEMP';
S.Variables(4).Attributes(1).Value = 'SST';
S.Variables(4).Attributes(2).Value = 'degC';
ncwriteschema(tname,S);

ncwrite(tname,'XT_OCEAN',xT);
ncwrite(tname,'YT_OCEAN',yT);
ncwrite(tname,'TIME',time);

% make SST and SSS fields:
SST = 15+5*(time/365)+2*sin(pi*time/10);

SSTout = repmat(permute(SST,[3 1 2]),[xL yL 1]);
ncwrite(tname,'TEMP',SSTout);

% Make initial condition:
iname = [base 'ocean_temp_salt_res_momgyre.nc'];
iname_out = [base 'ocean_temp_salt.res.nc'];
delete(iname_out)

S = ncinfo(iname);

% alter properties:
S.Dimensions(1).Length = xL;
S.Dimensions(2).Length = yL;
S.Dimensions(3).Length = zL;
S.Variables(1).Size = xL;
S.Variables(1).Dimensions(1).Length = xL;
S.Variables(2).Size = yL;
S.Variables(2).Dimensions(1).Length = yL;
S.Variables(3).Size = zL;
S.Variables(3).Dimensions(1).Length = zL;
S.Variables(4).Size = [xL yL];
S.Variables(4).Dimensions(1).Length = xL;
S.Variables(4).Dimensions(2).Length = yL;
S.Variables(5).Size = [xL yL];
S.Variables(5).Dimensions(1).Length = xL;
S.Variables(5).Dimensions(2).Length = yL;
S.Variables(7).Size = [xL yL zL 1];
S.Variables(7).Dimensions(1).Length = xL;
S.Variables(7).Dimensions(2).Length = yL;
S.Variables(7).Dimensions(3).Length = zL;
S.Variables(8).Size = [xL yL zL 1];
S.Variables(8).Dimensions(1).Length = xL;
S.Variables(8).Dimensions(2).Length = yL;
S.Variables(8).Dimensions(3).Length = zL;

ncwriteschema(iname_out,S);

ncwrite(iname_out,'temp',15*ones(xL,yL,zL));
ncwrite(iname_out,'salt',32*ones(xL,yL,zL));

% $$$ 
% $$$ salt = ncread(iname,'salt');
% $$$ [xL,yL,zL] = size(salt);
% $$$ 
% $$$ salt_int = (SSS_N+SSS_S)/2;
% $$$ 
% $$$ spl = 10;
% $$$ vfunc = flipud(cat(1,zeros(spl,1),[0:1:(zL-spl-1)]'/(zL-spl-1)));
% $$$ salt = salt_int*ones(xL,yL,zL) + ...
% $$$        permute(vfunc,[2 3 1]).*repmat(SSS-salt_int,[1 1 zL]);
% $$$ 
% $$$ ncwrite(iname_out,'salt',salt);
