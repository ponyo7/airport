function duration_min=parking_duration_from_histogram(parking_mode)
%param[in] parking_mode 1 hourly, 2 daily, 3 long term, 4 economic
%param[out] return duration in minitue

assert(parking_mode<=4 && parking_mode>=1, 'only support: 1 hourly, 2 daily, 3 long term, 4 economic');

nbin = 100;
if parking_mode==1 %hourly
    short_term_hourly = dlmread('SFO_short_term_hourly.txt'); %n*1, each row is parking duration in minutes
    h = histogram(short_term_hourly,nbin);
    range = h.BinLimits;
    bin_width = h.BinWidth;
    id = distribution_from_histogram(h.BinCounts);
    duration_min = range(1)+id*bin_width;
end

if parking_mode==2 %daily
    short_term_hourly = dlmread('SFO_short_term_daily.txt'); %n*1, each row is parking duration in minutes
    h = histogram(short_term_hourly,nbin);
    range = h.BinLimits;
    bin_width = h.BinWidth;
    id = distribution_from_histogram(h.BinCounts);
    duration_min = range(1)+id*bin_width;
end

if parking_mode==3 %long term
    short_term_hourly = dlmread('SFO_long_term.txt'); %n*1, each row is parking duration in minutes
    h = histogram(short_term_hourly,nbin);
    range = h.BinLimits;
    bin_width = h.BinWidth;
    id = distribution_from_histogram(h.BinCounts);
    duration_min = range(1)+id*bin_width;
end

%short_term_daily = dlmread('SFO_short_term_daily.txt');
%long_term = dlmread('SFO_long_term.txt');
%economic_parking = dlmread('SFO_economic_parking.txt');

% nbin = 100;
% figure(7)
% hist(short_term_hourly,nbin);
% figure(8)
% hist(short_term_daily,nbin);
% figure(9)
% hist(long_term,nbin);
% f2 = hist(short_term_daily,nbin);
% f3 = hist(long_term,nbin);
end

%param[in] h: 1*n
function id = distribution_from_histogram(h)
    assert(size(h,2)>=1)
    rand_val = rand();
    num_bin = size(h, 2);
    intervals = zeros(1, num_bin);
    sum_hist = sum(h);
    intervals(1) = h(1)/sum_hist;
    for i=2:num_bin
        width = h(i)/sum_hist;
        intervals(i) = intervals(i-1) + width;
    end
    assert(abs(intervals(num_bin)-1)<0.001);
    id = -1;
    %FIXME: binary search
    for i=1:num_bin
        if rand_val<intervals(i)
            id=i;
            break;
        end
    end
end



