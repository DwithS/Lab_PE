%  과제3 메인 프로그램



clear ; clc;

CONFIG = KH_config;
NUM_OF_ALGO=CONFIG.NUM_OF_ALGO;
NUM_OF_Krill = CONFIG.NUM_OF_particle;
max_iteration=CONFIG.iteration;

% p = gcp('nocreate'); % If no pool, do not create new one.
% if isempty(p)
%      p = parpool(feature('numcores')); 
%     
% else
%     delete(p);
%      p = parpool(feature('numcores')); 
% end







dataFileLists = getDataLists('data');
sizeofdataLists = 1;

% sizeofdataLists = lcsave(char('result_'+string(year(starttime)) +string(month(starttime))+string(day(starttime))),'result');ength(dataFileLists);


sequence = cell(sizeofdataLists);
% % Load 나 Gen 밖에 안된다. 딴거 쓰면 에러남
% % sequence = Sequence('Load',dataFileLists);
% sequence = Sequence('Gen',dataFileLists);



h = waitbar(0, 'Please wait...');
steps = sizeofdataLists * NUM_OF_ALGO;

calculate_Result = cell(steps,4);
starttime = datetime;

tic
for eachDataSet=1:sizeofdataLists
    disp(eachDataSet +"번째 데이터 셋");
    
    data = load(strcat(dataFileLists(eachDataSet).folder,"\",dataFileLists(eachDataSet).name));
    
    sim_seq = crossvalind('HoldOut',size(data.X,1), KH_config.TESTPORTION);
    
    ts_data = data.X(~sim_seq,:);
    ts_ans = data.Y(~sim_seq,:);
    
    
    data.X = data.X(sim_seq,:);
    data.Y = data.Y(sim_seq,:);
    sequence = Sequence_modi(sequence, eachDataSet,data,CONFIG.TESTPORTION);
    
    
    temporal = size(data.X);
    numOfFeature = temporal(2);
    for eachAlgo=1:NUM_OF_ALGO
%         disp(eachAlgo +"번째 알고리즘");
%         features = data.X;
        
        max_index=0;
        MAX=0;
        
        little_krill(NUM_OF_Krill,1) = Krill;
        
        selector = transpose(makeRdmSelector(numOfFeature, NUM_OF_Krill,0.3));
        
        
%         initialize
        for i = 1:NUM_OF_Krill
%             Bird 초기값 세팅
            little_krill(i) = setData(little_krill(i),data,eachAlgo,sequence{eachDataSet,1});
            little_krill(i).selector = selector(i,:);
            little_krill(i).newSelector = little_krill(i).selector;
            little_krill(i).velocity = zeros(1,numOfFeature);
            little_krill(i).newVelocity = little_krill(i).velocity;
            result = getResult(little_krill(i));
            little_krill(i).fitness = result;
        end
        
        toc
        Iteration_Counter=1;
        
        
        
        TTEESSTT = true;
        while TTEESSTT
            C_food = 2*(1-Iteration_Counter/max_Iteration);
            temporal_result = zeros(1,NUM_OF_Krill);
            
            for i = 1:NUM_OF_Krill
                little_krill(i) = refresh(little_krill(i));
            end 
            
            
            for i = 1:NUM_OF_Krill
                temporal_result(i) = getResult(little_krill(i));
            end 
            
            
            [M,I] = max(temporal_result);
            MAX = M;
            max_index = I;
            
            
            %Shake
            
            for shake_i=1:(NUM_OF_Krill-1)
                little_krill(shake_i) = modi_velocity(little_krill(shake_i), little_krill(max_index), little_krill(shake_i+1));
            end
            little_krill(NUM_OF_Krill) = modi_velocity(little_krill(NUM_OF_Krill), little_krill(max_index), little_krill(1));
            
            for shake_i=1:(NUM_OF_Krill-1)
                little_krill(shake_i) = modi_selector(little_krill(shake_i));
            end
            
            
            %Shake_END
            
            
            
            Iteration_Counter=Iteration_Counter+1;
            if Iteration_Counter>max_iteration
               TTEESSTT = false;  
            end
        end
        
        tempNum = (eachAlgo + (eachDataSet-1)*NUM_OF_ALGO);
        calculate_Result(tempNum,1) = {dataFileLists(eachDataSet).name};              %데이터 이름
        calculate_Result(tempNum,2) = {eachAlgo};                                     %알고리즘 번호?
        calculate_Result(tempNum,3) = {logical(little_krill(max_index).selector)};      %최선의 조합
        calculate_Result(tempNum,4) = {MAX};                                          %확률
        
        text = dataFileLists(eachDataSet).name +"("+eachDataSet+") "+ eachAlgo+"번째 알고리즘 ("+tempNum +"/"+steps+") " + toc;
        waitbar(tempNum/steps,h,sprintf(text));
%         disp("max = " + MAX);
        disp(dataFileLists(eachDataSet).name+"__"+ eachAlgo+"__"+MAX);
    end
%     disp("to NeXt Dataset " + (eachDataSet+1));
end
endtime = datetime;
result = struct('Start_Time',starttime,'End_Time',endtime,'Passed_Second',toc,'CONFIG',CONFIG);
result = setfield(result,'calresult',calculate_Result);
save(char('result_'+string(year(starttime)) +string(month(starttime))+string(day(starttime))),'result');




close(h);



delete(p);


function selector = makeRdmSelector(numOfFeature, numOfList, portion)
    
    selector=zeros(numOfFeature, numOfList);
    
    for i = 1:numOfList
        selector(:,i) = crossvalind('HoldOut',numOfFeature, portion);    
    end
%     selector = logical(selector);
end

function result = Sequence_modi(result, datasetNum, data, portion)
    CONFIG = KH_config;
    TESTNUM = CONFIG.TESTNUM;

    sim_seq=zeros(size(data.X,1), TESTNUM);
        for i = 1:TESTNUM

        sim_seq(:,i) = crossvalind('HoldOut',size(data.X,1), portion);
        end
    DATA = logical(sim_seq);
    result(datasetNum,1) = {DATA};
end