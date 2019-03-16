function table = getTrajectoryPairsLateral(data, lane, minTrajectoryLength)

   
    % Filter the data based on the lane 
    
    lane_data_self = data((data(:,14)==lane),:);

    pair_data_left = {};
%     pair_data_right= {};
%     lane_data_self_veh = {};
%     data_Pair_left = {};
    data_Pair = {};
    unique_vehicles = unique(lane_data_self(:,1));
    
    pairArr = [];
    selfLatPos = [];
    pairLatPos = [];
    timeArr = [];
    selfLatVel = [];
    pairLatVel = [];
    space_lat = [];
    self_width = [];
    pair_width = [];
    count = 0;
    
    %% Extract neighboring vehicles for each vehicle in lane
    for j = unique_vehicles'
        lane_data_self_veh{j} = lane_data_self(lane_data_self(:,1) ==j,:);
        unique_frames = unique(lane_data_self_veh{j}(:,2));
        
        lane_data_left = [];
        lane_data_right= [];
    
        for k = unique_frames'
            frame_table = data(data(:,2) == k,:);
            frame_data_self = lane_data_self_veh{j}(lane_data_self_veh{j}(:,2) ==k,:);
            
            zone_start = min(frame_data_self(frame_data_self(:,1)==j,6));
            zone_end = zone_start - min(frame_data_self(frame_data_self(:,1)==j,9));
            
            lane_data_left1 = frame_table((frame_table(:,14)==(lane - 1) & frame_table(:,6) < zone_start & frame_table(:,6) > zone_end),:);
            lane_data_left2 = frame_table((frame_table(:,14)==(lane - 1) & (frame_table(:,6)-frame_table(:,9)) < zone_start & (frame_table(:,6)-frame_table(:,9)) > zone_end),:);
            lane_data_left = [lane_data_left; lane_data_left1 ; lane_data_left2];

            lane_data_right1 = frame_table(frame_table(:,14)==(lane + 1) & frame_table(:,6) < zone_start & frame_table(:,6) > zone_end,:);
            lane_data_right2 = frame_table(frame_table(:,14)==(lane + 1) & (frame_table(:,6)-frame_table(:,9)) < zone_start & (frame_table(:,6)-frame_table(:,9)) > zone_end,:);
            lane_data_right = [lane_data_right; lane_data_right1; lane_data_right2];
            
        end
        
        pair_data_left{j}= sortrows(lane_data_left);
        pair_data_right{j}= sortrows(lane_data_right);
        unique_vehicle_left = unique(pair_data_left{j}(:,1));
        unique_vehicle_right = unique(pair_data_right{j}(:,1));
        
        for m = unique_vehicle_left'
%             data_Pair_mixL = cell2mat(pair_data_left{j});
%             trajectoryLengthL = length(data_Pair_mixL(:,1)==m);
            trajectoryLengthL = length(find(pair_data_left{j}(:,1)==m));
            if trajectoryLengthL < minTrajectoryLength
                pair_data_left{j}(pair_data_left{j}(:,1)==m,:)= [];
            end
%             pair_data_left{j}= data_Pair_mixL;
            
        end
                
        for n = unique_vehicle_right'
%             data_Pair_mixR = cell2mat(pair_data_right{j});
%             trajectoryLengthR = length(data_Pair_mixR(:,1)==m);
            trajectoryLengthR = length(find(pair_data_right{j}(:,1)==n));
            if trajectoryLengthR < minTrajectoryLength
                pair_data_right{j}(pair_data_right{j}(:,1)==n,:)= [];
            end
%             pair_data_right{j}= data_Pair_mixR;
            
        end
 % after data separated for all pairs  
 
        % Concatenate all pairs
        if isempty(data_pair_left) && isempty(data_pair_right)
            continue
        elseif isempty(data_pair_left) 
            data_Pair = data_pair_right;
        elseif isempty(data_pair_right)
            data_Pair = data_pair_left;
        else
            data_Pair = vertcat(data_pair_right,data_pari_left);
        end

        % Extract pair variables
        self_data = lane_data_self_veh{j};
        data_Pair = data_Pair{j};
        -
        selfLatPos = [selfLatPos; self_data(:,5)];
        pairLatPos = [pairLatPos; data_Pair(:,5)];
        timeArr = [timeArr; time'];
        pairArr = [pairArr; repmat(count, length(self_data), 1)];
        selfLatVel = [selfLatVel; 0; 10.*diff(self_data(:,5))];
        pairLatVel = [pairLatVel; 0; 10.*diff(data_Pair(:,5))];
        self_width = [self_width; self_data(:,10)];
        pair_width = [pair_width; data_Pair(:,10)];
    end
 %%   Extract unique pairs for unique vehicles
%     data_Pair = [lane_data_left; lane_data_right];   
    



%     
%     for m=1:(length(unique_vehicles)-1)
%         % Filter data based on follower and leader fields
%         self_data = lane_data_self((lane_data_self(:,1)==unique_vehicles(m)),:);
%         data_Pair = lane_data_self((lane_data_self(:,1)==unique_vehicles(m+1)),:);
% 
%         % Find the common start - end times of the trajectory - pair pair
%         maxStartTime = max(min(self_data(:,2)), min(data_Pair(:,2)));
%         minEndTime = min(max(self_data(:,2)), max(data_Pair(:,2)));
% 
%         if (maxStartTime < minEndTime)
%             % Filter leader and follower data based on the start-end time 
%             self_data = self_data(find(self_data(:,2)>=maxStartTime & self_data(:,2)<=minEndTime),:);
%             data_Pair = data_Pair(find(data_Pair(:,2)>=maxStartTime & data_Pair(:,2)<=minEndTime),:);
% 
%             time = 1:length(self_data);
% 
%             % Check minimum trajectory length and data Length 
%             if(length(self_data)>minTrajectoryLength && length(self_data)==length(data_Pair))
% 
%                 count = count + 1;
%                 % Accumulate results in respective arrays
%                 selfLatPos = [selfLatPos; self_data(:,5)];
%                 pairLatPos = [pairLatPos; data_Pair(:,5)];
%                 timeArr = [timeArr; time'];
%                 pairArr = [pairArr; repmat(count, length(self_data), 1)];
%                 selfLatVel = [selfLatVel; 0; 10.*diff(self_data(:,5))];
%                 pairLatVel = [pairLatVel; 0; 10.*diff(data_Pair(:,5))];
%                 self_width = [self_width; self_data(:,10)];
%                 pair_width = [pair_width; data_Pair(:,10)];
%             end   
%         end
%     end
    space_lat = [abs(selfLatPos - 0.5.*self_width - 0.5.*pair_width- pairLatPos)];


    % Save the data as a matrix. 
    % Matrix format: |Pair_no|Leader_position|Follower_position|time| 
    table = [pairArr, selfLatPos, pairLatPos, timeArr, selfLatVel, pairLatVel, space_lat] ;