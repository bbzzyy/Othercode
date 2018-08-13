clear
clc

x_f0=[1,2];
% x_l0=[2,2];
x_l0=[4,4];

mu0=rand(2,10);
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
nonlcon = [];

tic
% options = optimoptions('fminunc','Algorithm','quasi-newton','OptimalityTolerance',0.01,'StepTolerance',0.01,'ObjectiveLimit',0.01);
options = optimoptions('fminunc','Algorithm','quasi-newton');
mu = fminunc(@objf,mu0,options);
toc
%%
syms t;
[~,n]=size(mu);
mu_x=mu(1,:);
mu_y=mu(2,:);
l_x=1/2*mu_x(1)*t;
l_y=1/2*mu_y(1)*t;
for i=2:n
    if mod(i,2)==1;%odd
        l_xe=(1/sqrt(2))*sin(((i-1)/2)*pi*t/2)*mu_x(i)/(((i-1)/2)*pi/2);
        l_ye=(1/sqrt(2))*sin(((i-1)/2)*pi*t/2)*mu_y(i)/(((i-1)/2)*pi/2);
    else           %even
        l_xe=-(1/sqrt(2))*cos((i/2)*pi*t/2)*mu_x(i)/((i/2)*pi/2);
        l_ye=-(1/sqrt(2))*cos((i/2)*pi*t/2)*mu_y(i)/((i/2)*pi/2);
    end
    l_x=l_x+l_xe; % control at x
    l_y=l_y+l_ye; % control at y
end
l_x=simplify(l_x);
l_y=simplify(l_y);
c_lx=x_l0(1)-subs(l_x,0); % constant
c_ly=x_l0(2)-subs(l_y,0); % constant
l_x=simplify(l_x+c_lx); % trajectory of leader x
l_y=simplify(l_y+c_ly); % trajectory of leader y
t=linspace(0,4);
plot(double(subs(l_x,t)),double(subs(l_y,t)));hold on

tspan=[0 4]; %s
f0=x_f0.';
[t,f]=ode23(@(t,f) trajectory(t,f,l_x,l_y), tspan, f0);
plot(f(:,1),f(:,2));

result=objf( mu )
