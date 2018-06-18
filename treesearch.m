function [ numdepend,dependcase ] = treesearch( test,testcase,dependsort )
%treesearch function
%input:
%test： the object test case need to be char

postest=strfind(testcase,test);
postest=~cellfun('isempty',postest);
pos=find(postest == 1);
[m,~]=size(pos);

for j=1:m
    if size(test) == size(testcase{pos(j)})
        position=pos(j);
    end
end
dep=dependsort(position,:);
depind=~cellfun('isempty',dep);
numdepend=sum(depind);
if numdepend == 0
    dependcase={};
else
    [~,n]=size(dep);
    u=1;
    for i=1:n
        if isempty(dep{i}) == 0
            dependcase{u}=dep{i};
            u=u+1;
        end
    end
end

end

