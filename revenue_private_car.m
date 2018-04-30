function revenue = revenue_private_car(simulation_row)
% @brief revenue from private car parking
% @param[input]  1*8, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking time 7: distance 8: revenue: revenue from this person
% @param[output] revenue
%
CURB_PER_TRIP_CHARGE = 0; % FIXME: fill in real number from airport

assert(simulation_row(2)==1 && simulation_row(4)==1); % must be resident and private car

revenue = 0;
%---------------------------park off airport-------------------------------
if(simulation_row(5)==2)
    revenue = 0;
end

%---------------------------curbside---------------------------------------
if(simulation_row(5)==3)
    revenue = CURB_PER_TRIP_CHARGE;
end


%---------------------------park at airport--------------------------------
if(simulation_row(5)==1)
    revenue = revenue_private_car_at_airport(simulation_row);
end


