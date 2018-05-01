function revenue = revenue_tnc(simulation_row)
% @brief revenue from tnc
% @param[input]  1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode 7: parking time 8: distance 9: AV 10: revenue
% @param[output] revenue

CURBSIDE_PER_TRIP_CHARGE_RESIDENT = 0; %FIXME: fill in real cost
CURBSIDE_PER_TRIP_CHARGE_ROURIST = 0; %FIXME: fill in real cost

assert(simulation_row(4)==2); %travel mode has to be tnc

revenue = 0;
if simulation_row(2) == 1
    revenue = CURBSIDE_PER_TRIP_CHARGE_RESIDENT;
end

if simulation_row(2) == 2
    revenue = CURBSIDE_PER_TRIP_CHARGE_ROURIST;
end