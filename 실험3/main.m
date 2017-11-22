% ����3 ���� ���α׷�



clear ; clc;

CONFIG = config;
NUM_OF_ALGO=4;
NUM_OF_BIRD = 10;
PSO_Threshold=CONFIG.PSO_THRESHOLD;

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    p = parpool(feature('numcores')); 
    
else
    delete(p);
    p = parpool(feature('numcores')); 
end



dataFileLists = getDataLists('data');
sizeofdataLists = length(dataFileLists);

% Load �� Gen �ۿ� �ȵȴ�. ���� ���� ������
sequence = Sequence('Load',dataFileLists);



h = waitbar(0, 'Please wait...');
steps = sizeofdataLists * NUM_OF_ALGO;

Result = Cell(sizeofdataLists*NUM_OF_ALGO,4);


tic
for eachDataSet=1:sizeofdataLists
    disp(eachDataSet +"��° ������ ��");
    data = load(strcat(dataFileLists(eachDataSet).folder,"\",dataFileLists(eachDataSet).name));
    for eachAlgo=1:NUM_OF_ALGO
%         disp(eachAlgo +"��° �˰���");
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
        Result(tempNum,1) = dataFileLists(eachDataSet).name;    %������ �̸�
        Result(tempNum,2) = eachDataSet;                        %������ ��ȣ?
        Result(tempNum,3) = ;                                   %�ּ��� ����
        Result(tempNum,4) = ;                                   %Ȯ��
        
        text = dataFileLists(eachDataSet).name +"("+eachDataSet+") "+ eachAlgo+"��° �˰��� ("+tempNum +"/"+steps+") " + toc;
        waitbar(tempNum/steps,h,sprintf(text));
%         disp("max = " + MAX);
        disp(dataFileLists(eachDataSet).name+"__"+ eachAlgo+"__"+MAX);
    end
%     disp("to NeXt Dataset " + (eachDataSet+1));
end

% close(h);



delete(p);