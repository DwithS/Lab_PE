% 각 데이터들의 feature, class, instance를 구하는 스크립트

clear

data_path = 'data';


lists = dir(data_path);
lists = lists(3:length(lists),1);
% sort(lists);
sizeofdataLists = length(lists);

dataTable= cell(sizeofdataLists,4);;

for k = 1:sizeofdataLists
    file_name = strcat(data_path,"\",lists(k).name);
%     resultCell(k,1) = {file_name};
    data = load(file_name);
    dataTable(k,1) = {lists(k).name};
    temp = size(data.X);
    dataTable(k,2) = {temp(1,2)};
    dataTable(k,3) = {temp(1,1)};
    dataTable(k,4) = {length(unique(data.Y))};
end

