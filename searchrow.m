function [ numrow, deprow ] = searchrow( dep,testcase,dependsort )
%UNTITLED2 此处显示有关此函数的
%   此处显示详细说明
[~,n]=size(dep);
deprow={};
for i=1:n
    if isempty(dep{i})==0
        [ ~,dependcase ] = treesearch( dep{i},testcase,dependsort );
        %% check if there are identical cases
        if i==1
            deprow=dependcase;
        else
            [~,u]=size(dependcase);
            for j=1:u
                iden=strcmp(dependcase{j},deprow);
                if sum(iden) == 0
                    deprow=[deprow,dependcase{j}];
                else
                    idenpos=find(iden==1);
                    for w=1:sum(iden)
                        deprow{idenpos(w)}={};
                    end
                    deprow=[deprow,dependcase{j}];
                end
            end
        end
    end
end
deprow=deprow(~cellfun(@isempty,deprow));
numrow=sum(~cellfun('isempty',deprow));
end

