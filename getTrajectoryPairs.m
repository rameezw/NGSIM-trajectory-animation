function table = getTrajectoryPairs(data, lane, minTrajectoryLength)

    % Filter the data based on the lane and make sure follower - leader
    % fields are not 0
    lane_data = data((data(:,14)==lane & data(:,15)~=0 & data(:,16)~=0),:);
    unique_vehicles = unique(lane_data(:,1));

    pairArr = [];
    leaderPos = [];
    followerPos = [];
    timeArr = [];
    leaderAcc = [];
    followerAcc = [];
    leaderVel = [];
    followerVel = [];
    spaceHeadway = [];
    leaderLength = [];
    leaderAccChanges = [];
    followerAccChanges = [];
    
    leaderID = [];
    followerID = [];
    badDriver = [];
    count = 0;
    for i=1:(length(unique_vehicles)-1)
        % Filter data based on follower and leader fields
        leader_data = lane_data((lane_data(:,1)==unique_vehicles(i) & ...
            lane_data(:,15)==unique_vehicles(i+1)),:);
        follower_data = lane_data((lane_data(:,1)==unique_vehicles(i+1) & ...
            lane_data(:,16)==unique_vehicles(i)),:);

        % Find the common start - end times of the trajectory
        maxStartTime = max(min(leader_data(:,2)), min(follower_data(:,2)));
        minEndTime = min(max(leader_data(:,2)), max(follower_data(:,2)));

        if (maxStartTime < minEndTime)
            % Filter leader and follower data based on the start-end time 
            leader_data = leader_data(find(leader_data(:,2)>=maxStartTime & ...
            leader_data(:,2)<=minEndTime),:);
            follower_data = follower_data(find(follower_data(:,2)>=maxStartTime & ...
                follower_data(:,2)<=minEndTime),:);

            time = 1:length(leader_data);

            % Check minimum trajectory length and data Length 
            if(length(leader_data)>minTrajectoryLength && ...
                    length(leader_data)==length(follower_data))

                count = count + 1;
                % Accumulate results in respective arrays
                leaderPos = [leaderPos; leader_data(:,6)];
                followerPos = [followerPos; follower_data(:,6)];
                timeArr = [timeArr; time'];
                pairArr = [pairArr; repmat(count, length(leader_data), 1)];
                leaderID = [leaderID; leader_data(:,1)];
                followerID = [followerID; follower_data(:,1)];
                leaderAcc = [leaderAcc; leader_data(:,13)];
                followerAcc = [followerAcc; follower_data(:,13)];
                leaderVel = [leaderVel; leader_data(:,12)];
                followerVel = [followerVel; follower_data(:,12)];
                spaceHeadway = [spaceHeadway; leader_data(:,17)];
                leaderLength = [leaderLength; leader_data(:,9)];
                leaderAccChanges = findchangepts(leader_data(:,13),'MinThreshold',4);
                followerAccChanges = findchangepts(follower_data(:,13),'MinThreshold',4);
                
                if length(followerAccChanges) > length(leaderAccChanges)
                    badDriver = [badDriver; ones(length(leader_data(:,17)),1)];
                else
                    badDriver = [badDriver;zeros(length(leader_data(:,17)),1)];
                end

            end   
        end
    end

    spaceHeadway = (spaceHeadway-leaderLength);  


    % Save the data as a matrix. 
    % Matrix format: |Pair_no|Leader_position|Follower_position|time| 
    table = [pairArr, leaderPos, followerPos, timeArr, leaderAcc, followerAcc, leaderVel, followerVel, spaceHeadway, badDriver,leaderID,followerID] ;