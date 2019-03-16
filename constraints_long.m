function [c, ceq] = constraints_long(x,d_min_obs,data,nobservations)

for i=1:nobservations

    v_lead = data(i,7);
    v_follow = data(i,8);

% Nonlinear inequality constraints
    c(i) = v_follow.*x(4) + 0.5*x(1)*(x(4).^2)+ ((v_follow + (x(4)*x(1))).^2)./(2*x(3)) - (v_lead.^2)./(2*x(2)) - d_min_obs;
end
% Nonlinear equality constraints
ceq = [];