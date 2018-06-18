clear
clc
ts=0.05;%time interval
tf=4;
N=tf/ts+1;%number of step
x_exit=[5,0];
x_f0=[1,2];
% x_l0=[2,2];
x_l0=[4,4];

H1=eye((N-1)*2);% sum of control signal
H2=zeros(2*(N-1));% x_l
H3=H2;% x_f
H=blkdiag(H1,H2,H3);
%% solver
obj=@(y) y*H*(y.')*ts+(norm(y(1,end-1:end)-x_exit))^2;

problem = createOptimProblem('fmincon',...
    'objective',@(y)y*H*(y.')*ts+(norm(y(1,end-1:end)-x_exit))^2,...
    'x0',rand(1,6*(N-1)),'options',...
    optimoptions(@fmincon,'Algorithm','interior-point','Display','off'));
[y,fval] = fmincon(problem);
% ms = MultiStart;
% % rng(1) % uncomment to obtain the same result
% [y,fval,eflag,output,manymins] = run(ms,problem,50)