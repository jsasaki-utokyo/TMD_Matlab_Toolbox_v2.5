%========================================================================
% my_tmd_tide.m
%
% This function runs tide prediction with specifying the location
% (lon, lat) and datetime range.
% This version is for TMD2.5
%
% Inputs:   Model name
%
% Sample call:  tmd_exerciser;
%
% Author: Jun Sasaki (UTokyo): jsasaki@k.u-tokyo.ac.jp
%         October 9, 2021, Updated October9, 2021
%========================================================================
clearvars; clc;
global ftbverbose
ftbverbose = 1; % =0 for silent; =1 for noisy global ftb

if ispc % Code to run on Windows
    base_dir = 'D:/Github/';
elseif isunix % Code to run on Linux
    base_dir = '~/Github/';
end
addpath('..');
addpath(genpath(fullfile(base_dir, 'TMD_Matlab_Toolbox_v2.5/TMD/')));
%% Speciry model, lon, lat, ini_time t_0 and range (0:(days*24))/24
% Note: Time in UTC, Dataum level needs to be adjusted
%       Not applicable to in a bay (low accuracy)
Model = 'Model_PO'
lon=139.50; lat=34.55; % Mera
%lon=139.37; lat=35.10; % Aburatsubo
% JMA https://www.data.jma.go.jp/gmd/kaiyou/db/tide/suisan/suisan.php?stn=MR
t_0=datenum(2020,1,1);   % initial date
time=t_0+(0:(31*24))/24; % unit in days

%% Access and plot model bathymetry (water column thickness under ice shelves)
[x,y,H]=tmd_get_bathy(Model);
loc=find(H==0); H(loc)=NaN;
figure(1);clf
pcolor(x,y,H);shading flat; colorbar
title(['Model for ' Model],'FontSize',10,...
    'Interpreter','none');
% ========================================================================

%% Report whether model is (lat,lon) or Polar Stereographic ===============
[ModName,GridName,Fxy_ll]=rdModFile(Model,1)
if(isempty(Fxy_ll))
    disp('Model is coded in (lat,lon)')
else
    disp(['Model is coded in Polar Stereo (x,y) using function ' Fxy_ll])
end  
% ========================================================================

%% Tidal prediction
%t_0=datenum(2020,1,1);
%time=t_0+(0:(31*24))/24;
[z,constit]=tmd_tide_pred(Model,time,lat,lon,'z');
%[u,constit]=tmd_tide_pred(Model,time,lat,lon,'u');
%[v,constit]=tmd_tide_pred(Model,time,lat,lon,'v');
figure(2); clf
subplot(1,1,1); 
plot(time-t_0,z,'r','LineWidth',1);
grid on
xlabel('Time, days since start 2020')
ylabel('height (m)')

%{
figure(2); clf
subplot(3,1,1); 
plot(time-t_0,z,'r','LineWidth',1);
grid on
xlabel('Time, days since start 2020')
ylabel('height (m)')
subplot(3,1,2); 
plot(time-t_0,u,'r','LineWidth',1);
grid on
xlabel('Time, days since start 2020')
ylabel('u (E/W) current (cm/s)')
subplot(3,1,3); 
plot(time-t_0,v,'b','LineWidth',1);
grid on
xlabel('Time, days since start 2020')
ylabel('v (N/S) current (cm/s)')
%}
% ========================================================================
