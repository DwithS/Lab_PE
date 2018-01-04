function result = Sequence(choice, dataLists)
% sequences are saved and loaded from 'seq' folder
% make or load data Sequence
% choice should be 'Load' or 'Gen'
CONFIG = config;

SEQ_PATH = 'seq';
DATA_PATH ='data';
TESTNUM = CONFIG.TESTNUM;
PORTION = CONFIG.TESTPORTION;


sizeofdataLists = length(dataLists);
result = cell(sizeofdataLists,1);





for k = 1:sizeofdataLists
    
    seq_file = strcat(SEQ_PATH,"\",strrep(dataLists(k).name,'.mat',''),"_seq.mat");
    if strcmp(choice ,'Load')
        
        try
            temp = load(seq_file);
        catch
            disp("Cannot load such file : "+seq_file);
        end
        result(k,1)= {temp.DATA};
    elseif strcmp(choice ,'Gen')    
%         file_name = strcat(data_path,"\",dataLists(k).name);
        data = load(strcat(DATA_PATH,"\",dataLists(k).name));
    
    
        DATA = SeqGen(TESTNUM,size(data.X,1),PORTION);
        result(k,1)= {DATA};
        save(seq_file,'DATA');
    else
        disp("wrong input, input should be long Load or Gen");
        error();
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