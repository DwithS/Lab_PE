% 과제3 메인 프로그램



clear ; clc;

NUM_OF_ALGO=4;
NUM_OF_BIRD = 10;
PSO_Threshold=1000;

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    p = parpool(feature('numcores')); 
    
else
    delete(p);
    p = parpool(feature('numcores')); 
end



dataFileLists = getDataLists('data');
sizeofdataLists = length(dataFileLists);

% Load 나 Gen 밖에 안된다. 딴거 쓰면 에러남
sequence = Sequence('Load',dataFileLists);



h = waitbar(0, 'Please wait...');
steps = sizeofdataLists * NUM_OF_ALGO;

Result = Cell(sizeofdataLists*NUM_OF_ALGO,4);


tic
for eachDataSet=1:sizeofdataLists
    disp(eachDataSet +"번째 데이터 셋");
    data = load(strcat(dataFileLists(eachDataSet).folder,"\",dataFileLists(eachDataSet).name));
    for eachAlgo=1:NUM_OF_ALGO
%         disp(eachAlgo +"번째 알고리즘");
%         features = data.X;
        
        TTEESSTT = true;

        
        MAX = 0;

        littlebird(NUM_OF_BIRD,1) = Bird;
            
        for i = 1:NUM_OF_BIRD
            littlebird(i) = setData(littlebird(i),data,eachAlgo,sequence{eachDataSet,1});
        end

        Counter=1;
        while TTEESSTT
            temporal_result = zeros(NUM_OF_BIRD);
            for i = 1:NUM_OF_BIRD
                temporal_result(i) = getResult(littlebird(i));
            end 
            
            
            result = classifer(features, data.Y , sequence{eachDataSet,1},eachAlgo);
            result_mean = mean(result(:,1));
            if MAX<result_mean
                MAX = result_mean;
            end
            
            Counter=Counter+1;
            if Counter>PSO_Threshold
               TTEESSTT = false;  
            end
        end
        
        tempNum = (eachAlgo + (eachDataSet-1)*NUM_OF_ALGO);
        Result(tempNum,1) = dataFileLists(eachDataSet).name;
        Result(tempNum,2) = eachDataSet;
        Result(tempNum,3) = ;
        Result(tempNum,4) = ;
        
        text = dataFileLists(eachDataSet).name +"("+eachDataSet+") "+ eachAlgo+"번째 알고리즘 ("+tempNum +"/"+steps+") " + toc;
        waitbar(tempNum/steps,h,sprintf(text));
%         disp("max = " + MAX);
        disp(dataFileLists(eachDataSet).name+"__"+ eachAlgo+"__"+MAX);
    end
%     disp("to NeXt Dataset " + (eachDataSet+1));
end

% close(h);



% answer = cell(11,1);
% for i = 1:sizeofdataLists
%    answer(i,1) = {["0" "0" "0" "0"]};
% end
% 
% 
% ppm = ParforProgMon('진행도... ', sizeofdataLists)
% 
% parfor k = 1:sizeofdataLists
%     data = load(strcat(dataFileLists(k).folder,"\",dataFileLists(k).name));
%     
%     temp = ["0" "0" "0" "0"];
%     for i = 1:4
%         
%         result = classifer(data.X, data.Y , sequence{k,1},i);
%         resultA = strcat(num2str(mean(result(:,1))), "±", num2str(std(result(:,1))));
%         temp(i) = resultA;
%         
%     end
%     answer(k) = {temp};
%     
%     ppm.increment();
% end

delete(p);



function res = getModifedFeature(features)

    temp = size(features);
    sim_seq = crossvalind('HoldOut',temp(2), 0.8);
    sim_seq = transpose(logical(sim_seq));
%     disp(size(sim_seq) +" ____ "+size(features));
    
    
    res = features(:,sim_seq);
    
end