clear
clc
%% read data
[~,testcase]=xlsread('Data-KTH_raw.xlsx','Sheet1','B2:B212');
[~,depend]=xlsread('Data-KTH_raw.xlsx','Sheet1','C2:C212');
[~,require]=xlsread('Data-KTH_raw.xlsx','Sheet1','D2:D212');
[~,time]=xlsread('Data-KTH_raw.xlsx','Sheet1','E2:E212');

%% post process
depend=strtrim(depend);
testcase=strtrim(testcase);
testcase(47)={'CCTV-S-038'};%data defect%
[require,num_req]=sortout(require,1);%number of requirement coverage of each case
[time,~]=sortout(time,0);
time=cellfun(@str2double,time);

%% sort out the dependency
dependsort={};
for i=1:211
    d=depend{i};
    if isempty(d) == 1
        depend{i}='NON';
    end
    n=0;
    for j=1:211
        a=strfind(d,testcase{j});
        if ~isempty(a)
            test=testcase{j};
            [~,m]=size(test);
            n=n+1;
            dependsort{i,n}=testcase{j};
        end
    end
end
[~,n]=size(dependsort);
for i=1:211
    for j=1:n
        for v=1:n
            if ~isempty(strfind(dependsort{i,j},dependsort{i,v})) && v ~= j
                dependsort{i,v}=[];
            end
        end
    end
end

%% data defects
dependsort(188)={ {} }; %dependence contradiction
time(17)=15; %assume the excution time for test case 17 is 15 min

%% tree search
for i=1:211
    [ numrow, deprow ] = searchrow( dependsort(i,:),testcase,dependsort );
    depnoemp=dependsort(i,:);
    depnoemp=depnoemp(~cellfun(@isempty,depnoemp));
    deptotal{i,:}=[depnoemp,deprow];
    sumdep(i)=numrow+sum(~cellfun(@isempty,dependsort(i,:)));
    while numrow ~=0
        [ numrow, deprow ] = searchrow( deprow,testcase,dependsort );
        deptotal{i,:}=[deptotal{i,:},deprow];
        sumdep(i)=sumdep(i)+numrow;
    end
end
sumdep=sumdep';
%%
for i=1:211
    ac=0;
    for j=1:211
        if sumdep(j) ~= 0
        ac=ac+sum(strcmp(deptotal{j,1},testcase{i}));            
        end
    end
    pc(i,1)=ac;    
end 
%% rank and post-process
exp_reqcov=num_req.*0.8.*0.8.^(sumdep);% expected requirement coverage

%different value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% value=exp_reqcov./time;% value for each test case
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:211
    if sumdep(i) ~= 0
        for j=1:sumdep(i)
            deppos(j)=findtestpos( deptotal{i}(j),testcase );
        end
        sum_exprc=sum(exp_reqcov(deppos));
        sum_time=sum(time(deppos));
        value(i)=sum_exprc/sum_time;
    else
        value(i)=exp_reqcov(i)/time(i);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

excmat=eye(211,211);
for i=1:211
    [ numrow, deprow ] = treesearch( char(testcase(i)),testcase,dependsort );
    if numrow >=1;
        for j=1:numrow
            pos=findtestpos( deprow(j),testcase );
            excmat(i,pos)=1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:211
    if time(i) >= 61
        color(i,1)=1;
        color(i,2)=round(255-255*(time(i)-61)/49)/255;
        color(i,3)=0;
    else
        color(i,1)=round(255*(time(i)-10)/50)/255;
        color(i,2)=1;
        color(i,3)=0;
    end
end

MakerSize=1+((num_req.^1.5)'.*5./3);
G = digraph(excmat,testcase,'OmitSelfLoops');
p=plot(G,'Layout','layered','MarkerSize',MakerSize,'NodeColor',color);
p.LineWidth=1;
p.Marker='s';
% p.NodeColor='r';
nl = testcase;
xd = get(p, 'XData');
yd = get(p, 'YData');
% h=set(text(xd, yd, nl, 'FontSize',7, 'HorizontalAlignment','left', 'VerticalAlignment','middle'),'rotation',-60);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% start ranking based on the value vector and excution matrix
for i=1:211
    checkexc=sum(excmat,2);
    excpos=find(checkexc==1);
    firstcasepos=excpos(value(excpos)==max(value(excpos)));
    [m,~]=size(firstcasepos);
    if m > 1
        posuncer=firstcasepos(pc(firstcasepos)==max(pc(firstcasepos)));
        [n,~]=size(posuncer);
        if n > 1
            pos=posuncer(1);
        else
            pos=posuncer;
        end
    else
        pos=firstcasepos;
    end
    sequence{i,1}=char(testcase(pos));%testcase
    sequence{i,2}=num_req(pos);%requirement coverage
    sequence{i,3}=time(pos);%excution time
    sequence{i,4}=sumdep(pos);%number of dependency
    valuerank(i,1)=value(pos);
    if i == 1
        sumcov(1,1)=num_req(pos);
        sumtime(1,1)=time(pos);
        sumexpcov(1,1)=exp_reqcov(pos);        
    else
        sumcov(i,1)=sumcov(i-1,1)+num_req(pos);
        sumtime(i,1)=sumtime(i-1,1)+time(pos);
        sumexpcov(i,1)=sumexpcov(i-1,1)+exp_reqcov(pos);
    end
    excmat(:,pos)=0;
end
% 
% % save('sequence.mat','sequence')
% % xlswrite('sequence.xlsx',sequence)
% % xlswrite('sequence_alternative.xlsx',sequence)
% 
% axis([0 7572 0 320])
% legend('approach 1','approach 2')
% xlabel('time')
% ylabel('requirement coverage')