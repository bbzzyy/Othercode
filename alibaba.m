% for i = 1:N
%     for j = 1:N+1-i
%         direction = [i,j];
%         
%     end
% end
% map = [0 4 1;4 0 2;1 2 0];
map = [0 3 1 6;
       3 0 4 5;
       1 4 0 3;
       6 5 3 0];
d = distali(1,4,3,4,map)