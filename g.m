function s_xf = g(x_l, x_f)
dist=norm(x_l-x_f);

if dist<=1
    s_xf=x_l-x_f;
elseif dist>1 && dist<=2
    s_xf=(3*dist^3-14*dist^2+20*dist-8)*(x_l-x_f)/dist;
else
    s_xf=0;
end

end