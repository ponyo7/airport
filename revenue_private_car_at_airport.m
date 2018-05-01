function revenue = revenue_private_car_at_airport(simulation_row)
% @brief revenue from private car parking
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue

assert(simulation_row(2)==1 && simulation_row(4)==1 && simulation_row(5)==1); % must be resident and private car

%calculating parking cost
time = simulation_row(6);
days = floor(time/24);
hours = mod(time, 24);
parking_fee = 0;
if (simulation_all(6)==1||simulation_all(6)==2) && time>1 %short term
    fee_days = days*max_per_day_short;
    num_20mins = ceil(hours*3);
    fee_hours = num_20mins*fee_per_20min_short;
    if  fee_hours > max_per_day_short
        fee_hours = max_per_day_short;
    end
    parking_fee = fee_days+fee_hours;
end   

if simulation_all(6)==3 && time > 1 % long term
    fee_days = days*max_per_day_long;
    num_20mins = ceil(hours*3);
    fee_hours = num_20mins*fee_per_20min_long;
    if  fee_hours > max_per_day_long
        fee_hours = max_per_day_long;
    end
    parking_fee = fee_days+fee_hours;
end

if simulation_all(6)==4                      % economic parking
    fee_days = days*max_per_day_econ;
    num_20mins = ceil(hours*3);
    fee_hours = num_20mins*fee_per_20min_econ;
    if  fee_hours > max_per_day_econ
        fee_hours = max_per_day_econ;
    end
    parking_fee = fee_days+fee_hours;
end

revenue = parking_fee;

