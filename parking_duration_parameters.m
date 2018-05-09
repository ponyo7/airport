function[mu,sigma]=parking_duration_parameters(short_term_hourly,short_term_daily,long_term,economic_parking)

short_term_hourly = dlmread('SFO_short_term_hourly.txt');
short_term_daily = dlmread('SFO_short_term_daily.txt');
long_term = dlmread('SFO_long_term.txt');
%economic_parking = dlmread('SFO_economic_parking.txt');
nbin = 100;
hist(short_term_hourly,nbin);
hist(short_term_daily,nbin);
hist(long_term,nbin);
% f2 = hist(short_term_daily,nbin);
% f3 = hist(long_term,nbin);


% st_hourly_mu = 54/60;
% st_hourly_sigma = 5; %FIXME
% st_daily_mu = 54/60;
% st_daily_sigma = 5; %FIXME
% lt_daily_mu = 54/60;
% lt_daily_sigma = 5; %FIXME
% eco_parking_mu = 54/60;
% eco_parking_sigma = 5; %FIXME