% 메인 프로그램


waitbar_h = waitbar(0,'Process . . .');

data_path = 'data';
seq_path = 'seq';
LOAD_SEQ = true;
SAVE_SEQ = false;


lists = dir(data_path);
lists = lists(3:length(lists),1);
sizeofdataLists = length(lists);

testNum = 50;
portion = 0.2;


resultCell = cell(12,8);
%1에는 파일명
%2에는 평균
%3에는 표준편차
%4에는 시퀸스
%5knn
%6nb
%7dt



for k = 1:sizeofdataLists
    file_name = strcat(data_path,"\",lists(k).name);
    resultCell(k,1) = {file_name};
    data = load(file_name);
    
    seq_file = strcat(seq_path,"\",strrep(lists(k).name,'.mat',''),"_seq.mat");
    if (LOAD_SEQ==true && (exist(seq_file,'file')~=0))
        temp = load(seq_file);
        resultCell(k,4)= {temp.data};
        
    else
        temp = SeqGen(testNum,size(data.X,1),portion);
        resultCell(k,4)= {temp};
        if (SAVE_SEQ==true)
            save(seq_file,'temp');
        end        
    end
    
    
    
    
    result = knnClassifier(data.X,data.Y,resultCell{k,4});
    resultA = strcat(num2str(mean(result(:,1))), "±", num2str(std(result(:,1))));
    resultCell(k,5) = {resultA};

% 
    result = nbClassifier(data.X,data.Y,resultCell{k,4});
    resultA = strcat(num2str(mean(result(:,1))), "±", num2str(std(result(:,1))));
    resultCell(k,6) = {resultA};


    result = dtClassifier(data.X,data.Y,resultCell{k,4});
    resultA = strcat(num2str(mean(result(:,1))), "±", num2str(std(result(:,1))));
    resultCell(k,7) = {resultA};

    result = mSvmClassifier1(data.X,data.Y,resultCell{k,4});
    resultA = strcat(num2str(mean(result(:,1))), "±", num2str(std(result(:,1))));
    resultCell(k,8) = {resultA};
    
      waitbar(k/sizeofdataLists,waitbar_h)
end
save('RESULT.mat','resultCell');

close(waitbar_h); 
clear waitbar_h;
