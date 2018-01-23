function result = getDataLists(datapath)
% using datapath
% return dataFileLists

if ~exist('datapath','var')
    datapath = 'data';
end

data_path = datapath;

lists = dir(data_path);
result = lists(3:length(lists),1);

end