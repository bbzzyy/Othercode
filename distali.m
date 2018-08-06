function d = distali(i,j,n,N,map)
%ตÝน้

if n == 1 && i ~= j
    d = map(i,j);
elseif n == 1 && i == j
    d = inf;
else
    for m = 1:N
        temp_d(m) = distali(m,j,n-1,N,map)+distali(i,m,1,N,map);
    end
    d = min(temp_d);
end

end

