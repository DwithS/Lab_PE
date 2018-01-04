clear;

load('실험1 RESULT.mat')
load('실험3 Result.mat')
result1 = resultCell;
result2 = Result;

total = cell(11,13);
temp = size(total);

for i=1:temp(1)
   total(i,1) = {result2(1+4*(i-1),1)};     
   for j=1:4
      total(i,j+1)= {str2num(char(strtok(result1{i,4+j}, '±')))};
      total(i,j+5)= result2(4*(i-1)+j,4);
      total(i,j+9)={total{i,j+5}-total{i,j+1}};
   end
end



% str2num(char(strtok(resultCell{i,4+k}, '±')));