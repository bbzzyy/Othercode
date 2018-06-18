function dfdt = trajectory(t,f,l_x,l_y)

l_x=matlabFunction(l_x);
l_y=matlabFunction(l_y);

dfdt=zeros(2,1);
dist=norm([f(1)-l_x(t),f(2)-l_y(t)]);

if dist<=1;
    dfdt(1)=l_x(t)-f(1);
    dfdt(2)=l_y(t)-f(2);
elseif dist>1 && dist<=2
    coe=(3*dist^3-14*dist^2+20*dist-8)/dist;
    dfdt(1)=coe*(l_x(t)-f(1));
    dfdt(2)=coe*(l_y(t)-f(2));
else
    dfdt(1)=0;
    dfdt(2)=0;
end

