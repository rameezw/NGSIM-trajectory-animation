%clear all;
close all;

tic
load('trajectories_i80.mat');

trajectories = trajectories_i80;

% Lane can be chosen from 1 to 7
lane_index = 1;

% Set a minimum number data points
minTrajectoryLength = 100;

% rss_parameters_long = {};
a_max_a_lat = [];
a_min_b_lat = [];
rho_lat = [];
counter = [];

for i = 1:lane_index
   
        % Call trajectory pair function.
    dataTable = getTrajectoryPairsLateral(trajectories, i, minTrajectoryLength);
            
    if  isempty(dataTable)
        continue            %for no pairs in a lane
    end
        % Set pair index
    pair_index = max(dataTable(:,1));
        
    for j = 1:pair_index
        % Extract the trajectory for the pair
        plotTable = dataTable(find(dataTable(:,1)==j),:);

        nobservations = length(plotTable);
%         nobservations = 10;
        % solver index: 1='symbolic';2='pareto',3='fmincon'
        solver = 3;

        % RSS Longitudinal safety 
        [rss_parameters_lat,counter(j,i)] = rss_lat(plotTable, solver, nobservations);
        a_max_a_lat(j,i) = rss_parameters_lat(1);
        a_min_b_lat(j,i) = rss_parameters_lat(2);
        rho_lat(j,i) = rss_parameters_lat(3);
        fprintf('current lane %f .\n',double(i));
        fprintf('current pair %f .\n',double(j));
    end
end
% figure,
% % Plot leader vehicle trajectory 
% plot(plotTable(:,4), plotTable(:,2),'b');
% hold on
% %Plot following vehicle
% plot(plotTable(:,4), plotTable(:,3),'g');
% %plot(plotTable(:,4), plotTable(:,11),'r');
% legend('Leader vehicle','Follower vehicle','RSS safety')
% title(sprintf('NGSIM I-80 Trajectory for Pair # %d on Lane %d \n RSS parameters Amax_a %d Amax_b %d Amin_b %d', pair, lane,amax_ao,amax_bo,amin_bo));
% xlabel('Frame number')
% ylabel('Vertical position (ft)')

toc

