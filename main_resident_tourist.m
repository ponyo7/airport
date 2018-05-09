% main
% 1. simulate a table, each row is a person, each col represents an
% attribute
% 2. compute revenue for reach person (each row)

clear;
av_adoption_rates = [0:0.05:1; 0:0.05:1; 0:0.05:1; 0:0.05:1; 0:0.05:1]';%20*5: each row represent 5 adoption rate respectively for: private car, tnc, rental car, comfortable, economic
num_adoption = size(av_adoption_rates, 1);

%fuel price
fuel_per_gallon = 2.8;
MPG = 20;
mile_in_meter = 1609.34;

%electic vehicle charges on-site, no charges as of 2018
SFO_charge_fee = 0;
cost_per_kwh = 0.59; %21 cents per kwh in SF area, but 0.49-0.69 by Blink company, level-2
kwh_per_mile = 0.2257; %range from 18.75kwh/100mile to 26.39kwh/100mile, thus average 22.57
full_charge_kwh = 30; %the average EV needs about 30 kWh of electricity to power the vehicle for 100 miles
time_per_charge = 120; % 2-3 hours http://www.blinknetwork.com/membership-faqs.html


for i=1:num_adoption
%----------------------step1 generate simulation table---------------------
%1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode, 7: parking time 8: distance 9: AV 10: revenue
    simulation_all = generate_simulation_table(av_adoption_rates(i, :));
    num_rows = size(simulation_all);
    
    cost_resident_fuel = zeros(num_rows,6);%1. ID,  2.cost, 3. round-trip fuel cost  4. choice (0 parking, 1 AV, 2 tnc, 3,comf gt, 4 ), 5. lost parking fee per day, 6 parking cost per day
    for k =1:num_rows
    %--------------------------------------------------------------------------%
    %calculating parking cost
    cost_resident_fuel(i,1) = simulation_all(i,1); %id
    cost_resident_fuel(i,2) = simulation_all(i,11); %cost
    distance_cal = simulation_all(i,8);
    gallon_per_meter = 1/MPG/mile_in_meter;
    cost_resident_fuel(i,3) = distance_cal*fuel_per_gallon*gallon_per_meter*2;
    end
%----------------------step2 compute revenue for each row------------------
    for j = 1:num_rows
        row = simulation_all(j, :);
        revenue = 0;
        if(row(2)==1&&row(4)==1) % resident private car
            revenue = revenue_private_car(row);
        end
        if(row(4)==2) % tnc
            revenue = revenue_tnc(row);
        end
        if(row(4)==3) % rental car
            revenue = revenue_rental_car(row);
        end
        if(row(4)==4 || row(4)==5) % comfortable or economic
            revenue = revenue_comfortable_economic(row);
        end
        simulation_all(j,10) = revenue;
    end
    
end

for i=1:num_adoption
%----------------------step1 generate simulation table---------------------
%1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode, 7: parking time 8: distance 9: AV 10: revenue
    simulation_all = generate_simulation_table(av_adoption_rates(i, :));
    num_rows = size(simulation_all);

%----------------------step3 compute cost for each row------------------
    for j = 1:num_rows
        row = simulation_all(j, :);
        cost = 0;
        if(row(2)==1&&row(4)==1&&row(5)==1) % resident private car
           cost = revenue_private_car_at_airport(row);
        end
        if(row(4)==2) % tnc
           cost = cost_tnc(row);
        end
%         if(row(4)==3) % rental car
%             revenue = revenue_rental_car(row);
%         end
        if row(4)==4 % comfortable 
           cost = 25;
        end
        if row(4)==5 %economic
            cost = 9.5;
        end
        simulation_all(j,11) = cost;
    end
    
end

count_AV_all(n) = count_AV;
    count_parking_all(n) = sum(count_parking);
    percent_AV_all(n) = count_AV/(count_AV+sum(count_parking));
    parking_fee_lost_all(n) = parking_fee_lost;
    parking_revenue_all(n) = parking_revenue;
    
count_AV = 0;
count_parking = [0;0;0;0];
for i=1:num_all_IDs
    if simulation_all(i,2)==1 %resident
        if simulation_all(i,5)==1 && simulation_all(i,9)==1 && (cost_resident_fuel(i,2)>=cost_resident_fuel(i,3))
            cost_resident_fuel(i,4) = 1;
            cost_resident_fuel(i,5) = cost_resident_fuel(i,6); % parking lost
            count_AV = count_AV + 1;
        else
            cost_resident_fuel(i,4) = 0;
            cost_resident_fuel(i,5) = 0; % no parking lost
            count_parking(simulation_all(i,5)) = count_parking(simulation_all(i,5)) + 1;
        end
    end
end





