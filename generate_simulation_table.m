function simulation_all = generate_simulation_table(av_adoption_rates)
%zipcodes_enplanement_resident,zipcodes_enplanement_tourist,zipcode_distance,
%percent_travel_mode_resident,percent_travel_mode_tourist,percent_activity_private_car,percent_activity_rentalcar,percent_parking_mode,
%st_hourly_mu,st_hourly_sigma,st_daily_mu,st_daily_sigma,lt_daily_mu,lt_daily_sigma,eco_parking_mu,eco_parking_sigma)
%This function create a n*9 simulation table. Each row represents a person.

% Please refer to the comments for what each col represent
%
%TODO: pull all constants and input here

%--------------------input prepare-----------------------------------------
%input enplamenets zipcode file by resident and tourist, keep the files have same zipcode list
zipcodes_enplanement_resident = dlmread('zipcode_enplanement_resident.txt');%nx2 zipcode, enplanements
zipcodes_enplanement_tourist = dlmread('zipcode_enplanement_tourist.txt');%nx2 zipcode, enplanements
zipcodes_resident = zipcodes_enplanement_resident(:,1);
zipcodes_tourist = zipcodes_enplanement_tourist(:,2);
enplanements_resident = zipcodes_enplanement_resident(:,2); %numbers must be positive or 0
enplanements_tourist = zipcodes_enplanement_tourist(:,2); %enplanemnts must have same # of rows
assert(size(enplanements_resident, 1)==size(enplanements_tourist,1))
idx0 = enplanements_resident < 0 ;
idx1 = enplanements_tourist < 0 ;
if sum(idx0)>=1 || sum(idx1)>=1
    error('Error! Negtive enplanement number detected! Please check the excel file\n');
end
enplanements_all = enplanements_resident + enplanements_tourist;%two zipcode enplanement files have the same zipcode list
%input distance file by zipcode
num_zipcode = size(enplanements_all,1); 
%zipcode_distance = dlmread('Distance.txt'); %1. zipcode, 2. google-map
%distance---------------------------------------------------------------------FIXME prepare distance.txt and remove the next line---------------------------------------------------------------------
zipcode_distance = zeros(num_zipcode, 2) + 10000;
assert(num_zipcode == size(zipcode_distance,1)); % each row of enplanement and distance should corresponde to the same zipcode

num_all_IDs = sum(enplanements_all, 1);
num_residents = sum(enplanements_resident, 1);
num_tourist = sum(enplanements_tourist, 1);

%All fake numbers for now, FIXME: get real numbers
%!!!!!!!!DONT change the order of travel mode!!! have to be consistent with
%slides!!!!!!!!!!!!!!!!!!!
percent_travel_mode_resident = [0.25, 0.25, 0, 0.25, 0.25]; %FIXME: fill them in real numbers. 1. private car, 2. tnc and taxis, 3. rental car 4. comfortable public transit, 5. economic public transit 
percent_travel_mode_tourist = [0, 0.25, 0.25, 0.25, 0.25]; %FIXME: fill them in real numbers. 1. private car, 2. tnc and taxis, 3. rental car 4. comfortable public transit, 5. economic public transit
percent_activity_private_car = [1/3, 1/3, 1/3, 0, 0]; %park_at_airport, park_off_airport, curbside, 
percent_activity_rental_car = [0, 0, 0,0.5 0.5]; % rentalcar_on_airport, rentalcar_off_airport
percent_parking_mode = [0.5 0.2 0.3 0]; %short term hourly, short term daily, long term, economic parking 
st_hourly_mu = 54/60;
st_hourly_sigma = 5; %FIXME
st_daily_mu = 54/60;
st_daily_sigma = 5; %FIXME
lt_daily_mu = 54/60;
lt_daily_sigma = 5; %FIXME
eco_parking_mu = 54/60;
eco_parking_sigma = 5; %FIXME
%av_adoption_rate = 0.1; %FIXME

%------------------create simulation_all table-----------------------------

%contains all information for each ID
simulation_all = zeros(num_all_IDs, 10);
% 1: IDs, 
% 2: trip purpose (resident or tourist) 
% 3: zip codes (for resident only) 
% 4: travel modes: 1. private car, 2. tnc and taxis, 3. rental car 4. comfortable public transit, 5. economic public transit 
% 5: activity: park_at_airport, park_off_airport, curbside, rentalcar_on_airport, rentalcar_off_airport
% 6: parking mode: short term hourly, short term daily, long term, economic
% parking
% 7: parking time: only for park_at_airport or tnc_park_temporary
% 8: distance: only for resident
% 9: AV: whether the vehicle is AV or not, 1 AV, 0 not AV
% 10: revenue: revenue from this person

%------------------col1 generating IDs-------------------------------------
simulation_all(:,1) = 1:num_all_IDs;

%------------------col2 generate trip purpose: residents or tourists-------
simulation_all(1:num_residents,2) = 1; %make first part of table row resident
simulation_all(1+num_residents:end,2) = 2; %make the second part of table rows tourist

num_travel_resident = sum(simulation_all(:,2)==1);
num_travel_tourist = sum(simulation_all(:,2)==2);

%------------------col3 generating origination zip codes-------------------
zipcode_by_id_resident = generate_zip_codes(zipcodes_resident, enplanements_resident);
assert(sum(enplanements_resident)==num_residents);% number of residents should equal to the sum in enplanements_resident
simulation_all(1:num_residents,3) = zipcode_by_id_resident;

zipcode_by_id_tourist = generate_zip_codes(zipcodes_tourist, enplanements_tourist);
assert(sum(enplanements_tourist)==num_tourist);
simulation_all(1+num_residents:end,3) = zipcode_by_id_tourist;
    
%------------------col4 travel modes---------------------------------------
assert(max(simulation_all(:,2))<=2 && min(simulation_all(:,2))>=1)
%4.1)resident
distribution_travel_mode_resident = modes_distribution_by_percentile(num_travel_resident, percent_travel_mode_resident);
j=1;
for i=1:num_all_IDs
    if simulation_all(i,2)==1
        simulation_all(i,4) = distribution_travel_mode_resident(j); %generate the distribution and assigns a private car
        j = j+1;
    end
end
assert(j-1==length(distribution_travel_mode_resident))

%4.2)tourist
distribution_travel_mode_tourist = modes_distribution_by_percentile(num_travel_tourist, percent_travel_mode_tourist);
j=1;
for i=1:num_all_IDs
    if simulation_all(i,2)==2
        simulation_all(i,4) = distribution_travel_mode_tourist(j); %assign the travel mode
        j = j+1;
    end
end
assert(j-1==length(distribution_travel_mode_tourist))

%------------------col5 travel activity------------------------------------
%5.1)activity for private car
num_private_car = sum(simulation_all(:,4)==1);
distribution_activity_private_car = modes_distribution_by_percentile(num_private_car, percent_activity_private_car);
j=1;
for i=1:num_all_IDs
    if simulation_all(i,4)==1
        simulation_all(i,5) = distribution_activity_private_car(j);
        j = j+1;
    end
end
assert(j-1==length(distribution_activity_private_car))

%5.2) tnc activity: curbside only
for i=1:num_all_IDs
    if simulation_all(i,4)==2 %TNC
        simulation_all(i,5) = 3;
        j = j+1;
    end
end

%5.3 rental car
num_rental_car = sum(simulation_all(:,4)==3);
distribution_activity_rental_car = modes_distribution_by_percentile(num_rental_car, percent_activity_rental_car);
j=1;
for i=1:num_all_IDs
    if simulation_all(i,4)==3 %rental car
        simulation_all(i,5) = distribution_activity_rental_car(j);
        j = j+1;
    end
end
assert(j-1==length(distribution_activity_rental_car))

%------------------col6 parking mode---------------------------------------
%for activity = park_at_ariport only (private car of course )
%FIXME: make it a function, so you can just call it to simply things
num_park_at_airport = sum(simulation_all(:,5)==1); % park at airport
distribution_parking_mode = modes_distribution_by_percentile(num_park_at_airport, percent_parking_mode);
j=1;
for i=1:num_all_IDs
    if simulation_all(i,5)==1 %park at airport
        simulation_all(i, 6) = distribution_parking_mode(j);
        j = j+1;
    end
end
assert(j-1==length(distribution_parking_mode))

%------------------col7 parking time---------------------------------------
%for park_at_ariport only, which means only for private car 
%copy and modify it from main_method1_*
%make it a function, so you can just call it to simply things
%7.1). parking time--short term hourly
% X = 6;
% area = 0.87;
% Z = norminv(area);
num_parking_mode1 = sum(simulation_all(:,6) ==1);
num_parking_mode2 = sum(simulation_all(:,6) ==2);
num_parking_mode3 = sum(simulation_all(:,6) ==3);
num_parking_mode4 = sum(simulation_all(:,6) ==4);


histogram1 = zeros(num_parking_mode1,1);
k1 = 1;
for i=1:num_all_IDs
    if( simulation_all(i,6) ==1) %short term hourly
        while 1
            time = normrnd(st_hourly_mu, st_hourly_sigma);
            if(time>0)
                simulation_all(i,7) = time;
                histogram1(k1) = time;
                k1 = k1+1;
                break;
            end
        end
    end
end
figure(1);
hist(histogram1);

%7.2). parking time--short term daily
% X = 8;
% area = 0.01;
% Z = norminv(area);

histogram2 = zeros(num_parking_mode2,1);
k2 = 1;
for i=1:num_all_IDs
    if( simulation_all(i,6) ==2)
        while 1
            time = normrnd(st_daily_mu, st_daily_sigma);
            if(time>0)
                simulation_all(i,7) = time;
                histogram2(k2) = time;
                k2 = k2+1;
                break;
            end
        end
    end
end
figure(2);
hist(histogram2);

%7.3).parking time--long term 
histogram3 = zeros(num_parking_mode3,1);
k3 = 1;
for i=1:num_all_IDs
    if( simulation_all(i,6) ==3)
        while 1
            time = normrnd(lt_daily_mu, lt_daily_sigma);
            if(time>0)
                simulation_all(i,7) = time;
                histogram3(k3) = time;
                k3 = k3+1;
                break;
            end
        end
    end
end
figure(3);
hist(histogram3);

%7.4).parking time--economic parking 
histogram4 = zeros(num_parking_mode4,1);
k4 = 1;
for i=1:num_all_IDs
    if( simulation_all(i,6) ==4)
        while 1
            time = normrnd(eco_parking_mu, eco_parking_sigma);
            if(time>0)
                simulation_all(i,7) = time;
                histogram4(k4) = time;
                k4 = k4+1;
                break;
            end
        end
    end
end
figure(4);
hist(histogram4);


%------------------col8 distance-------------------------------------------
%copy and modify it from main_method1_*
%distance by zip code
for i=1:num_all_IDs
    zipcode = simulation_all(i,3);
    j=1; 
    while j<num_zipcode
        if zipcode == zipcode_distance(j,1)
            simulation_all(i, 8) = zipcode_distance(j,2);
            break;
        end
        j=j+1;
    end
    if j == num_zipcode && simulation_all(i, 8) ~= zipcode_distance(j,2) %distance is never assigned
        fprintf('Invalid zipcode: %d\n', zipcode);
        %error('The above zipcode does not have a value from "Distance.txt. Please check" ');
    end
end

%------------------col9 AV-------------------------------------------------
for k = 1:num_all_IDs
    if simulation_all(k,4)==1 %private car
        random_number = rand();
        if random_number <= av_adoption_rates(1)
            simulation_all(k,9) = 1; % this car is AV
        else
            simulation_all(k,9) = 0; % this car is not AV
        end
    end
    if simulation_all(k,4)==2 %tnc
        random_number = rand();
        if random_number <= av_adoption_rates(2)
            simulation_all(k,9) = 1; % this car is AV
        else
            simulation_all(k,9) = 0; % this car is not AV
        end
    end
    if simulation_all(k,4)==3 %rental car
        random_number = rand();
        if random_number <= av_adoption_rates(3)
            simulation_all(k,9) = 1; % this car is AV
        else
            simulation_all(k,9) = 0; % this car is not AV
        end
    end
    if simulation_all(k,4)==4 %comfortable
        random_number = rand();
        if random_number <= av_adoption_rates(4)
            simulation_all(k,9) = 1; % this car is AV
        else
            simulation_all(k,9) = 0; % this car is not AV
        end
    end
    if simulation_all(k,4)==5 %economic
        random_number = rand();
        if random_number <= av_adoption_rates(5)
            simulation_all(k,9) = 1; % this car is AV
        else
            simulation_all(k,9) = 0; % this car is not AV
        end
    end
end





