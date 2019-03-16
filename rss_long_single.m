function [rss_param,counter,d_min_obs,badIndex] = rss_long_single(data, solver, nobservations)

%Calculating RSS parameters for the pair
syms amax_a amax_b amin_b rho
syms c positive
% eqns = [];
constraints = cell(nobservations,1);
objective_functions = cell(nobservations,1);
functions = cell(nobservations,1);
% d_min_obs = max(min(data(:,9)),0);
d_min_obs = min(data(:,9));
x0 = rand(nobservations,4); %initialization
counter = 0;
badIndex =  max(data(:,10));
% for i=1:nobservations
% 
%     v_lead = data(i,7);
%     v_follow = data(i,8);
% 
%     %rational polynomial
%     %constraints{i} = @(x) (-d_min_obs*(2*x(2)*x(3)) + (2*x(2)*x(3)*v_follow*x(4) + x(2)*x(3)*x(1)*(x(4)^2)+ (x(2)*(v_follow + (x(4)*x(1)))^2) - x(3)*(v_lead^2))<0);
%     constraints{i} = @(x) (d_min_obs > (v_follow.*x(4) + 0.5*x(1)*(x(4).^2)+ ((v_follow + (x(4)*x(1))).^2)./(2*x(3)) - (v_lead.^2)./(2*x(2))));
%     objective_functions{i} = @(x) 0;
%     functions{i} = @(x) v_follow.*x(4) + 0.5*x(1)*(x(4).^2)+ ((v_follow + (x(4)*x(1))).^2)./(2*x(3)) - (v_lead.^2)./(2*x(2));
%     %eqns = [eqns eqn];
% end



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
    x = paretosearch(constraints,4,[],[],[],[],[10, -30, -15, 0],[30, -10, -1, 3],[],options);
%     x = paretosearch(constraints,4,[],[],[],[],[5, -30, -20, 0],[30, -5, -1, 5],[],options);

    rss_param = x;
        
elseif solver == 3

    rng default % For reproducibility
    options = optimoptions('fmincon','MaxFunctionEvaluations',300000, 'UseParallel','Always');
%     x = fmincon(objective_functions,4,[],[],[],[],[],[],constraints,options);
    x = fmincon(@(x) 0,x0,[],[],[],[],[10, -30, -15, 0],[30, -10, -1, 3],@(x) constraints_long(x,d_min_obs,data,nobservations),options);
    rss_param = x;

else
end

% for i = 1:nobservations
%     %y(i) = feval(functions{i},x);
%     c(i) = feval(constraints{i},x);
%     if c(i) == 0
%         counter = counter + 1;
% end
check = feval(@(x) constraints_long(x,d_min_obs,data,nobservations),x);
for i = 1:length(check)
    if check(i) > d_min_obs
        counter = counter + 1;
        fprintf('constraint number unsat %f .\n',double(i));
    end
end


end

