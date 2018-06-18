function [c,ceq] = ceqf(y)
x_exit=[5,0];
x_f0=[1,2];
x_l0=[2,2];
% x_l0=[4,4];
ts=0.1;
[~,N]=size(y);
N=N/3; %size of each vector
u=y(1:N);
x_l=[x_l0,y(N+1:2*N)];
x_f=[x_f0,y(2*N+1:3*N)];

for i=1:N
    ceq_l(1,i)=x_l(i+2)-x_l(i)-ts*u(i);
end

for i=1:N/2;
    oldpos_l=x_l(1,2*i-1:2*i);
    oldpos_f=x_f(1,2*i-1:2*i);
    ceq_f(1,2*i-1:2*i)=x_f(1,2*i+1:2*i+2)-oldpos_f-ts*g(oldpos_l,oldpos_f);
end
leader_f=[x_l(1,end-1)-x_exit(1),x_l(1,end)-x_exit(2)];
follower_f=[x_f(1,end-1)-x_exit(1),x_f(1,end)-x_exit(2)];
c = [];
ceq=[ceq_l,ceq_f,follower_f];
% ceq=[ceq_l,ceq_f];
end


