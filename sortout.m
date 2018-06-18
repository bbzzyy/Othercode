function [ depend,number ] = sortout( depend ,swt )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[s,~]=size(depend);
for x=1:s
    d=depend{x};
    if isempty(d) ~= 1
        space=isspace(d);
        [~,length]=size(space);
        n=0;
        pos=[];
        for i=1:length
            if space(i)==0;
                n=n+1;
                pos(n)=i;
            end
        end
        num=1;
        differ={};
        for y=1:n-1
            if pos(y+1)-pos(y) ~=1;
                num=num+1;
                differ{num-1}=[y,y+1];
            end
        end
        number(x)=num;
        if swt == 1
            if num == 1
                depend{x}=d(pos(1):pos(n));
            else
                for m=1:num
                    if m == 1
                        depend{x,1}=d(pos(1):pos(differ{1}(1)));
                    elseif m == num
                        depend{x,num}=d(pos(differ{num-1}(2)):pos(n));
                    else
                        depend{x,m}=d(pos(differ{m-1}(2)):pos(differ{m}(1)));
                    end
                end
            end
        elseif swt == 0
            depend{x}=d(pos(1):pos(differ{1}(1)));
        end
    else
        depend{x}='NON';
    end
end
number=number';

end

