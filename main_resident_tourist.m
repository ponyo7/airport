% main
% 1. simulate a table, each row is a person, each col represents an
% attribute
% 2. compute revenue for reach person (each row)

clear;
av_adoption_rates = [0:0.05:1; 0:0.05:1; 0:0.05:1; 0:0.05:1; 0:0.05:1]';%20*5: each row represent 5 adoption rate respectively for: private car, tnc, rental car, comfortable, economic
num_adoption = size(av_adoption_rates, 1);

for i=1:num_adoption
%----------------------step1 generate simulation table---------------------
%1*10, 1: IDs,2: trip purpose 3: zip codes 4: travel modes 5: activity 6: parking mode, 7: parking time 8: distance 9: AV 10: revenue
    simulation_all = generate_simulation_table(av_adoption_rates(i, :));
    num_rows = size(simulation_all);

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



