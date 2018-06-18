function cost_instant = inttime( t,mu )
[~,n]=size(mu);
mu_x=mu(1,:);
mu_y=mu(2,:);
u_x=1/2*mu_x(1);
u_y=1/2*mu_y(1);
for i=2:n
    if mod(i,2)==1;%odd
        u_xe=(1/sqrt(2))*cos(((i-1)/2)*pi*t/2)*mu_x(i);
        u_ye=(1/sqrt(2))*cos(((i-1)/2)*pi*t/2)*mu_y(i);
    else           %even
        u_xe=(1/sqrt(2))*sin((i/2)*pi*t/2)*mu_x(i);
        u_ye=(1/sqrt(2))*sin((i/2)*pi*t/2)*mu_y(i);
    end
    u_x=u_x+u_xe; % control at x
    u_y=u_y+u_ye; % control at y
end
% cost_control=double(int((u_x^2+u_y^2),0,4))
cost_instant=u_x.^2+u_y.^2;
end

