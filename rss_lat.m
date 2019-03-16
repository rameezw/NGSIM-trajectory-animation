function [rss_param,counter] = rss_lat(data, solver, nobservations)

%Calculating RSS parameters for the pair
syms amax_a_lat amin_b_lat rho_lat
syms c positive
% eqns = [];
constraints = cell(nobservations,1);
objective_functions = cell(nobservations,1);
functions = cell(nobservations,1);
d_min_lat_obs = min(data(:,7));
x0 = rand(nobservations,3); %initialization
mu = 2;
counter = 0;

% for i=1:nobservations
% 
%     v_self = data(i,5);
%     v_pair = data(i,6);
% 
% %     constraints{i} = @(x) (d_min_lat_obs > (mu + ((0.5.*(v_self + (v_self + x(3).*x(1))).*x(3)) +  ((v_self + x(3).*x(1)).^2)./(2.*x(2)) - ((0.5.*(v_pair + (v_pair + x(3).*x(1))).*x(3)) - ((v_pair + x(3).*x(1)).^2)./(2.*x(2)))))) ;
%     
%     
%     
%     objective_functions{i} = @(x) 0;
%     functions{i} = @(x) mu + ((0.5.*(v_self + (v_self + x(3).*x(1))).*x(3)) +  ((v_self + x(3).*x(1)).^2)./(2.*x(2)) - ((0.5.*(v_pair + (v_pair + x(3).*x(1))).*x(3)) - ((v_pair + x(3).*x(1)).^2)./(2.*x(2))) );
%     %eqns = [eqns eqn];
% end

% constraints = constraints_lat(x,d_min_lat_obs,mu,data,nobservations);

if solver == 1
    %Solving the equation with mutiple variables
    pretty(eqn);
    range = [0 40; -30 30; -30 30; 0 5];
    [sola, solb, solc, sold, params, conditions] = solve(eqns, vars, 'Real',true,'IgnoreAnalyticConstraints',true,'ReturnConditions', true);
    fprintf('amax_a %f .\n',double(sola));
    fprintf('amax_b %f .\n',double(solb));
    fprintf('amin_b %f .\n',double(solc));
    fprintf('rho %f .\n',double(sold));
    rss_param = [double(sola), double(solb), double(solc), double(sold)];
    
elseif solver == 2

    rng default % For reproducibility
    options = optimoptions('paretosearch','ParetoSetSize',nobservations+1,'UseParallel','Always');
    x = paretosearch(constraints_lat(x,d_min_lat_obs,mu,data,nobservations),3,[],[],[],[],[],[],[],options);


    rss_param = x;
        
elseif solver == 3

    rng default % For reproducibility
    options = optimoptions('fmincon','MaxFunctionEvaluations',300000, 'UseParallel','Always');
%     x = fmincon(objective_functions,4,[],[],[],[],[],[],constraints,options);
    x = fmincon(@(x) 0,x0,[],[],[],[],[-20, -20, 0],[20, 20, 10],@(x) constraints_lat(x,d_min_lat_obs,mu,data,nobservations),options);
    rss_param = x;

else
end

% for i = 1:nobservations
%     %y(i) = feval(functions{i},x);
%     c(i) = feval(constraints{i},x);
%     if c(i) == 0
%         counter = counter + 1;
% end
check = feval(@(x) constraints_lat(x,d_min_lat_obs,mu,data,nobservations),x);
for i = 1:length(check)
    if check(i) > d_min_lat_obs
        counter = counter + 1;
    end
end
