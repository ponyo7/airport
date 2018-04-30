function revenue = revenue_comfortable_economic(simulation_row)
% @brief revenue from tnc
% @param[input]  1*8, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode, 7: parking time 8: distance 9: revenue
% @param[output] revenue

COMFORTABLE_GROUND_TRANSPORTATION = 0; %FIXME: fill in real cost
ECONOMIC_GROUND_TRANSPORTATION = 0; %FIXME: fill in real cost

assert(simulation_row(4)==4 || simulation_row(4)==5); %travel mode has to be tnc

revenue = 0;
if simulation_row(2) == 4
    revenue = COMFORTABLE_GROUND_TRANSPORTATION;
end

if simulation_row(2) == 5
    revenue = ECONOMIC_GROUND_TRANSPORTATION;
end
