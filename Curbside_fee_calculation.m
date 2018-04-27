function [count_AV, count_parking, parking_fee_lost, parking_revenue] = parking_cost_calculation(simulation_all, num_all_IDs)

%param[in] simulation_all 1: IDs, 2: Zip codes, 3: travel modes 4. parking modes 5. parking time 6.distance 7. private car that has AV or not
%param[in] num_all_IDs:      Number of all IDs
%
%calculate parking cost using data in simulation_all
