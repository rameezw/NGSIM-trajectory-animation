%clear all;
close all;
tic
load('trajectories_i80.mat');

trajectories = trajectories_i80;

% Lane can be chosen from 1 to 6 for i80, 2 to 5 for us101
lane_index = 4;

% Set a minimum number data points
minTrajectoryLength = 150;

% rss_parameters_long = {};
a_max_a = [];
a_max_b = [];
a_min_b = [];
rho = [];
counter = [];
badIndex = [];

% for i=1:lane_index
for i=2
        % Call trajectory pair function.
    dataTable = getTrajectoryPairs(trajectories, i, minTrajectoryLength);
    
    if  isempty(dataTable)
        continue            %for no pairs in a lane
    end
    
    %prune frames with negative dmin
    dataTable = dataTable(dataTable(:,9)>=0,:); 
    
    % Set pair index
    pair_index = max(dataTable(:,1));
        
%     for j = 1:pair_index
    for j = 2
        % Extract the trajectory for the pair
        plotTable = dataTable(find(dataTable(:,1)== j),:);
        nobservations = length(plotTable);
        
        if  nobservations < minTrajectoryLength
            continue            
        end
        
        % nobservations = 10;
        % solver index: 1='symbolic';2='pareto',3='gamultiobj'
        solver = 3;

        % RSS Longitudinal safety 
        [rss_parameters_long,counter(j,i),dminObs(j,i),badIndex(j,i)] = rss_long_single(plotTable, solver, nobservations);
        a_max_a(j,i) = rss_parameters_long(1);
        a_max_b(j,i) = rss_parameters_long(2);
        a_min_b(j,i) = rss_parameters_long(3);
        rho(j,i) = rss_parameters_long(4);
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

