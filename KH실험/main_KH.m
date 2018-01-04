% 과제3 메인 프로그램



clear ; clc;

CONFIG = config;
NUM_OF_ALGO=CONFIG.NUM_OF_ALGO;
NUM_OF_BIRD = CONFIG.NUM_OF_BIRD;
PSO_Threshold=CONFIG.PSO_THRESHOLD;

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    p = parpool(feature('numcores')); 
    
else
    delete(p);
    p = parpool(feature('numcores')); 
end



dataFileLists = getDataLists('data');
sizeofdataLists = 1;
sizeofdataLists = lcsave(char('result_'+string(year(starttime)) +string(month(starttime))+string(day(starttime))),'result');ength(dataFileLists);

% Load 나 Gen 밖에 안된다. 딴거 쓰면 에러남
% sequence = Sequence('Load',dataFileLists);
sequence = Sequence('Gen',dataFileLists);



h = waitbar(0, 'Please wait...');
steps = sizeofdataLists * NUM_OF_ALGO;

calculate_Result = cell(steps,4);
starttime = datetime;

tic
for eachDataSet=1:sizeofdataLists
    disp(eachDataSet +"번째 데이터 셋");
    data = load(strcat(dataFileLists(eachDataSet).folder,"\",dataFileLists(eachDataSet).name));
    temporal = size(data.X);
    numOfFeature = temporal(2);
    for eachAlgo=1:NUM_OF_ALGO
%         disp(eachAlgo +"번째 알고리즘");
%         features = data.X;
        
        max_index=0;
        MAX=0;
        
        
        
        littlebird(NUM_OF_BIRD,1) = Bird;
        
        selector = transpose(makeRdmSelector(numOfFeature, NUM_OF_BIRD,0.3));
        
        
        for i = 1:NUM_OF_BIRD
%             Bird 초기값 세팅
            littlebird(i) = setData(littlebird(i),data,eachAlgo,sequence{eachDataSet,1});
            littlebird(i).selector = selector(i,:);
            littlebird(i).newSelector = littlebird(i).selector;
            littlebird(i).velocity = zeros(1,numOfFeature);
            littlebird(i).newVelocity = littlebird(i).velocity;
        end
        Counter=1;
        
        
        
        TTEESSTT = true;
        while TTEESSTT
            temporal_result = zeros(1,NUM_OF_BIRD);
            
            for i = 1:NUM_OF_BIRD
                littlebird(i) = refresh(littlebird(i));
            end 
            
            
            for i = 1:NUM_OF_BIRD
                temporal_result(i) = getResult(littlebird(i));
            end 
            
            
            [M,I] = max(temporal_result);
            MAX = M;
            max_index = I;
            
            
            %Shake
            
            for shake_i=1:(NUM_OF_BIRD-1)
                littlebird(shake_i) = modi_velocity(littlebird(shake_i), littlebird(max_index), littlebird(shake_i+1));
            end
            littlebird(NUM_OF_BIRD) = modi_velocity(littlebird(NUM_OF_BIRD), littlebird(max_index), littlebird(1));
            
            for shake_i=1:(NUM_OF_BIRD-1)
                littlebird(shake_i) = modi_selector(littlebird(shake_i));
            end
            
            
            %Shake_END
            
            
            
            Counter=Counter+1;
            if Counter>PSO_Threshold
               TTEESSTT = false;  
            end
        end
        
        tempNum = (eachAlgo + (eachDataSet-1)*NUM_OF_ALGO);
        calculate_Result(tempNum,1) = {dataFileLists(eachDataSet).name};              %데이터 이름
        calculate_Result(tempNum,2) = {eachAlgo};                                     %알고리즘 번호?
        calculate_Result(tempNum,3) = {logical(littlebird(max_index).selector)};      %최선의 조합
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