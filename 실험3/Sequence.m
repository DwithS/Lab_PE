function result = Sequence(choice, dataLists)
% sequences are saved and loaded from 'seq' folder
% make or load data Sequence
% choice should be 'Load' or 'Gen'

seq_path = 'seq';
testNum = 50;
portion = 0.2;


sizeofdataLists = length(dataLists);
result = cell(sizeofdataLists,1);





for k = 1:sizeofdataLists
    
    
    if strcmp(choice ,'Load')
        seq_file = strcat(seq_path,"\",strrep(dataLists(k).name,'.mat',''),"_seq.mat");
        temp = load(seq_file);
        result(k,1)= {temp.data};
    end
    if strcmp(choice ,'Gen')
        file_name = strcat(dataLists(k).folder,"\",dataLists(k).name);
        data = load(file_name);
        
        temp = SeqGen(testNum,size(data.X,1),portion);
        result(k,1)= {temp};
        save(seq_file,'data');
    end
    
end


end



function sim_seq = SeqGen(sim_num, sample_num, portion)
% sim_num = 실행할 시뮬레이션 숫자
% sample_num = 샘플 숫자
% portion = 비율
sim_seq=zeros(sample_num, sim_num);
for i = 1:sim_num
    sim_seq(:,i) = crossvalind('HoldOut',sample_num, portion);
end
sim_seq = logical(sim_seq);
end
