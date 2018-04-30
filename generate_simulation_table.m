%
% This function create a n*9 simulation table. Each row represents a person.
% Please refer to the comments for what each col represent
%

clear;
enplanements = dlmread('Enplanements_2011.txt'); %numbers must be positive or 0
idx = enplanements < 0 ;
if sum(idx)>=1
    error('Error! Negtive enplanement number detected! Please check the excel file\n');
end

num_all_IDs = sum(enplanements);

%All fake numbers for now, FIXME: get real numbers
percent_trip_purpose = [0.5, 0.5]; %FIXME: get percentage of resident and tourist
percent_travel_mode_resident = [0.25, 0.25, 0.25, 0.25, 0]; %FIXME: fill them in real numbers. 1. private car, 2. tnc and taxis, 3. comfortable public transit, 4. economic public transit, 5. rental car 
percent_travel_mode_tourist = [0, 0.25, 0.25, 0.25, 0.25]; %FIXME: fill them in real numbers. 1. private car, 2. tnc and taxis, 3. comfortable public transit, 4. economic public transit, 5. rental car 
percent_activity_private_car = [1/3, 1/3, 1/3]; %park_at_airport, park_off_airport, curbside, 
%percent_activity_tnc = [0.5, 0.5]; %curbside, park_temporary
percent_activity_rentalcar = [0.5 0.5]; % rentalcar_on_airport, rentalcar_off_airport
percent_parking_mode = [0.5 0.2 0.3]; %short term hourly, short term daily, long term 
num_zipcode = 500; %FIXME

%contains all information for each ID
simulation_all = zeros(num_all_IDs, 9);
% 1: IDs, 
% 2: trip purpose (resident or tourist) 
% 3: zip codes (for resident only) 
% 4: travel modes: 1. private car, 2. tnc and taxis, 3. comfortable public transit, 4. economic public transit, 5. rental car
% 5: activity: park_at_airport, park_off_airport, curbside, rentalcar_on_airport, rentalcar_off_airport
% 6: parking mode: short term hourly, short term daily, long term 
% 7: parking time: only for park_at_airport or tnc_park_temporary
% 8: distance: only for resident
% 9: revenue: revenue from this person

idx_travel1 = (simulation_all(:,3)==1);
idx_travel2 = (simulation_all(:,3)==2);
num_travel1 = sum(idx_travel1);
num_travel2 = sum(idx_travel2);

%------------------col1 generating IDs-------------------------------------
simulation_all(:,1) = 1:num_all_IDs;

%------------------col2 generate trip purpose: residents or tourists-------
distribution = modes_distribution_by_percentile(num_all_IDs, percent_trip_purpose);
simulation_all(:,2) = distribution;

%------------------col3 generating origination zip codes-------------------
%the function generate_zip_codes 
zipcodes = dlmread('ZipCodes.txt');
zipcode_by_id = generate_zip_codes(zipcodes, enplanements);
simulation_all(:,3) = zipcode_by_id;
    
%------------------col4 travel modes---------------------------------------
assert(max(simulation_all(:,2))<=2 && min(simulation_all(:,2))>=1)
%4.1)resident
distribution_travel_mode_resident = modes_distribution_by_percentile(num_travel1, percent_travel_mode_resident);
distribution = zeros(num_all_IDs,1);
j=1;
for i=1:num_all_IDs
    if simulation_all(:,2)==1
        distribution(i) = distribution_travel_mode_resident(j); %generate the distribution and assigns a private car
        j = j+1;
    end
end
simulation_all(:,4) = distribution; %simulation_all(i, 4)

%4.2)tourist
distribution_travel_mode_tourist = modes_distribution_by_percentile(num_travel2, percent_travel_mode_tourist);
distribution = zeros(num_all_IDs,1);
j=1;
for i=1:num_all_IDs
    if simulation_all(:,2)==2
        distribution(i) = distribution_travel_mode_tourist(j); %generate the distribution and assigns a private car
        j = j+1;
    end
end
simulation_all(:,4) = distribution; %simulation_all(i, 4)

%------------------col5 travel activity------------------------------------
%5.1)activity for private car
distribution_activity_private_car = modes_distribution_by_percentile(num_travel1, percent_activity_private_car);
distribution = zeros(num_all_IDs,1);
j=1;
for i=1:num_all_IDs
    if simulation_all(:,4)==1
        distribution(i) = distribution_activity_private_car(j); %generate the distribution and assigns a private car
        j = j+1;
    end
end
simulation_all(:,5) = distribution; %simulation_all(i, 5)


%------------------col6 parking mode---------------------------------------
%for park_at_ariport only, which means only for private car 
%copy and modify it from main_method1_*
%make it a function, so you can just call it to simply things
%1. parking time--short term hourly

distribution_parking_mode = modes_distribution_by_percentile(num_travel1, percent_parking_mode);
distribution = zeros(num_all_IDs,1);
j=1;
for i=1:num_all_IDs
    if simulation_all(i,4)==1
        distribution(i) = distribution_parking_mode(j);
        j = j+1;
    end
end
%distribution(idx_travel1) = distribution_private_parking;
simulation_all(:,6) = distribution;

%------------------col7 parking time---------------------------------------
%for park_at_ariport only, which means only for private car 
%copy and modify it from main_method1_*
%make it a function, so you can just call it to simply things
%1. parking time--short term hourly


%------------------col8 distance-------------------------------------------
%copy and modify it from main_method1_*
%distance by zip code
distance = zeros(num_zipcode,2); %1. zipcode, 2. google-map distance
distance = dlmread('Distance.txt');
num_zipcode = size(distance,1);
for i=1:num_all_IDs
    zipcode = simulation_all(i,3);
    j=1; 
    while j<num_zipcode
        if zipcode == distance(j,1)
            simulation_all(i, 8) = distance (j,2);
            break;
        end
        j=j+1;
    end
    if j == num_zipcode && simulation_all(i, 8) ~= distance (j,2) %distance is never assigned
        fprintf('Invalid zipcode: %d\n', zipcode);
        error('The above zipcode does not have a value from "Distance.txt. Please check" ');
    end
end

%------------------col9 revenue-------------------------------------------
% parking_revenue 
% curbside_revenue
% rentalcar_revenue






