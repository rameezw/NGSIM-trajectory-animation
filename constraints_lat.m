function [c, ceq] = constraints_lat(x,d_min_lat_obs,mu,data,nobservations)

for i=1:nobservations

    v_self = data(i,5);
    v_pair = data(i,6);

% Nonlinear inequality constraints
    c(i) = (mu + ((0.5.*(v_self + (v_self + x(3).*x(1))).*x(3)) +  ((v_self + x(3).*x(1)).^2)./(2.*x(2)) - ((0.5.*(v_pair + (v_pair + x(3).*x(1))).*x(3)) - ((v_pair + x(3).*x(1)).^2)./(2.*x(2))))) - d_min_lat_obs;
end
% Nonlinear equality constraints
ceq = [];