function result = Sequence(choice, dataLists)
% sequences are saved and loaded from 'seq' folder
% make or load data Sequence
% choice should be 'Load' or 'Gen'

SEQ_PATH = 'seq';
TESTNUM = 50;
PORTION = 0.2;


sizeofdataLists = length(dataLists);
result = cell(sizeofdataLists,1);





for k = 1:sizeofdataLists
    
    
    if strcmp(choice ,'Load')
        seq_file = strcat(SEQ_PATH,"\",strrep(dataLists(k).name,'.mat',''),"_seq.mat");
        try
            temp = load(seq_file);
        catch
            disp("Canno load such file : "+seq_file);
        end
        result(k,1)= {temp.data};
    elseif strcmp(choice ,'Gen')
        file_name = strcat(dataLists(k).folder,"\",dataLists(k).name);
        data = load(file_name);
        
        temp = SeqGen(TESTNUM,size(data.X,1),PORTION);
        result(k,1)= {temp};
        save(seq_file,'data');
    else
        disp("wrong input, input should be long Load or Gen");
        error();
    end
    
end


end



function sim_seq = SeqGen(sim_num, sample_num, PORTION)
% sim_num = 실행할 시뮬레이션 숫자
% sample_num = 샘플 숫자
% PORTION = 비율
sim_seq=zeros(sample_num, sim_num);
for i = 1:sim_num
    sim_seq(:,i) = crossvalind('HoldOut',sample_num, PORTION);
end
sim_seq = logical(sim_seq);
end
