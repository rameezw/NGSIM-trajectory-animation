function test_rss = test_rss_long(pair,lane)

load('a1.mat');
load('b1.mat');
load('c1.mat');
load('d1.mat');
load('trajectories.mat');
dataTable = getTrajectoryPairs(trajectories, lane, 150);
plotTable = dataTable(find(dataTable(:,1)==pair),:);
d_min_obs = min(plotTable(:,9));
x = [a_max_a(pair,lane),a_max_b(pair,lane),a_min_b(pair,lane),rho(pair,lane)];
v_lead = plotTable(150,7);
v_follow = plotTable(150,8);
test_rss = d_min_obs - v_follow.*x(4) + 0.5*x(1)*(x(4).^2)+ ((v_follow + (x(4)*x(1))).^2)./(2*x(3)) - (v_lead.^2)./(2*x(2));


end