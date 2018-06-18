clear
clc
ts=0.05;%time interval
tf=4;
N=tf/ts+1;%number of step
x_exit=[5,0];
x_f0=[1,2];
x_l0=[2,2];
% x_l0=[4,4];

H1=eye((N-1)*2);% sum of control signal
H2=zeros(2*(N-1));% x_l
H3=H2;% x_f
H=blkdiag(H1,H2,H3);
%% solver
% obj=@(y) y*H*(y.')*ts+(norm(y(1,end-1:end)-x_exit))^2;%objective function
obj=@(y) y*H*(y.')*ts;
% obj=@(y) (norm(y(1,end-1:end)-x_exit))^2;

A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];

% lb = -0.1*ones(1,6*(N-1));
% ub = 0.1*ones(1,6*(N-1));

nonlcon = @ceqf;
%%%%%%%%%%%%% choose initial point of y %%%%%%%%%%%%%%%%%%
% y0=rand(1,6*(N-1));
y0=zeros(1,6*(N-1));
% y0=ones(1,6*(N-1));

% stepx_l=(x_exit(1)-x_l0(1))/(N-1);
% stepy_l=(x_exit(2)-x_l0(2))/(N-1);
% stepx_f=(x_exit(1)-x_f0(1))/(N-1);
% stepy_f=(x_exit(2)-x_f0(2))/(N-1);
% p=0;
% for i=1:2:2*(N-1)
%     p=p+1;
%     y0(2*(N-1)+i)=x_l0(1)+p*stepx_l; %x direction leader
%     y0(2*(N-1)+i+1)=x_l0(2)+p*stepy_l; %y direction leader
% end
% p=0;
% for i=1:2:2*(N-1)
%     p=p+1;
%     y0(4*(N-1)+i)=x_f0(1)+p*stepx_f; %x direction follower
%     y0(4*(N-1)+i+1)=x_f0(2)+p*stepy_f; %y direction follower
% end
% y0(1:2*(N-1))=zeros(1,2*(N-1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
% options = optimoptions('fmincon','Display','iter','Algorithm','interior-point','MaxFunctionEvaluations',100000);
y = fmincon(obj,y0,A,b,Aeq,beq,lb,ub,nonlcon,options);
%% plot result
N=(N-1)*2;
x_l=y(N+1:2*N);
xl_x=[x_l0(1),x_l(1:2:end-1)];
xl_y=[x_l0(2),x_l(2:2:end)];
figure,plot(xl_x,xl_y,'*')
% axis([0 5 0 5]);
hold on
x_f=y(2*N+1:3*N);
xf_x=[x_f0(1),x_f(1:2:end-1)];
xf_y=[x_f0(2),x_f(2:2:end)];
plot(xf_x,xf_y,'o')
legend('leader','follower')
[~,ceq] = ceqf(y);

opt_result=y*H*(y.')*ts+(norm(y(1,end-1:end)-x_exit))^2