%
% This function create a n*8 simulation table. Each row represents a person.
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
percent_travel_mode = [0.2, 0.2, 0.2, 0.2, 0.2]; %FIXME: fill them in real numbers. 1. private car, 2. tnc and taxis, 3. comfortable public transit, 4. economic public transit, 5. rental car 
percent_activity_private_car = [0.25, 0.25, 0.25]; %park_at_airport, park_off_airport, curbside
percent_activity_tnc = [0.5, 0.5]; %curbside, park_temporary

%contains all information for each ID
simulation_all = zeros(num_all_IDs, 8);
% 1: IDs, 
% 2: trip purpose (resident or tourist) 
% 3: zip codes (for resident only) 
% 4: travel modes: 1. private car, 2. tnc and taxis, 3. comfortable public transit, 4. economic public transit, 5. rental car
% 5: activity: park_at_airport, park_off_airport, curbside, park_temporary
% 6: parking time: only for park_at_airport
% 7: distance: only for resident
% 8: revenue: revenue from this person

%------------------col1 generating IDs-------------------------------------
simulation_all(:,1) = 1:num_all_IDs;

%------------------col2 generate trip purpose: residents or tourists-------
distribution = modes_distribution_by_percentile(num_all_IDs, percent_trip_purpose);
simulation_all(:,2) = distribution;

%------------------col3 generating origination zip codes-------------------
if simulation_all(:,2)==1 %resident
    zipcodes = dlmread('ZipCodes_resident.txt'); %zipcodes are ordered from the smallest to largest
    zipcode_by_id = generate_zip_codes(zipcodes, enplanements);
    simulation_all(:,3) = zipcode_by_id;
end
    
%------------------col4 travel modes---------------------------------------
assert(max(simulation_all(:,2))<=2 && min(simulation_all(:,2))>=1)
%4.1)resident
for i=1:num_all_IDs
    if simulation_all(:,2)==1
        %generate the distribution and assigns a private car
        %simulation_all(i, 5)
    end
end

%4.2)tourist
for i=1:num_all_IDs
    if simulation_all(:,2)==2
        %generate the distribution and assigns a private car
        %simulation_all(i,5)
    end
end

%------------------col5 travel activity------------------------------------
%5.1)activity for private car
for i=1:num_all_IDs
    if simulation_all(:,4)==1
        %generate the distribution and assigns a private car
        %simulation_all(i, 5)
    end
end

%5.2)activity for tnc
for i=1:num_all_IDs
    if simulation_all(:,4)==2
        %generate the distribution and assigns a private car
        %simulation_all(i,5)
    end
end
%------------------col6 parking time---------------------------------------
%for park_at_ariport only, which means only for private car 
%copy and modify it from main_method1_*
%make it a function, so you can just call it to simply things



%------------------col7 distance-------------------------------------------
%copy and modify it from main_method1_*









