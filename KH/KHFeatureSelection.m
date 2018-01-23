function [Selection , SelectionValue] = KHFeatureSelection(Data, population,iterationMax, func)
% INPUTS
% Data=Data to be minimize selection
% population=number of population
% itrationMax=maximum itration
% fun=fitness function
% OUTPUTS
% Selection=Selected Positions
% SelectionValue=fitness value of selected
% Date 2018-01-16
global_worst_selection = 0;
global_best_selection = 0;
global_best_fitness = 0;
global_worst_fitness = 0;
Selection = 0;
SelectionValue = 0;
fitness = zeros(population,1);
selector=zeros(population, size(Data.X,2));
best_selector = zeros(population, size(Data.X,2));
best_fitness = zeros(population, 1);
inertia_weightN = 0.3;
inertia_weightF = 0.3;
foraging_Speed = 1;

%% Initialize



for i = 1:population
    selector(i,:) = transpose(crossvalind('HoldOut',size(Data.X,2), rand_bet(0.2,0.8)));
end

sim_seq = zeros(size(Data.X,1),config.NUMOFSEQ);
for i = 1:size(sim_seq,2)
    sim_seq(:,i) = crossvalind('HoldOut',size(Data.X,1), config.TEST_PORTION);
end
sim_seq = logical(sim_seq);


%% loop
for iteration = 1:iterationMax
    %% Fitness Evaluate
    % 셀렉터로 feature를 선택하고 fitness를 측정한다.
    for krill = 1:population
        tempData = Data.X(:,logical(selector(krill,:)));
        ALGONUM = 4;
        result = func(tempData, Data.Y , sim_seq, ALGONUM);
        fitness(krill) = mean(result(:,1));
        if(fitness(krill)>best_fitness(krill))
            best_fitness(krill)=fitness(krill);
            best_selector(krill,:) = selector(krill,:);
        end
    end
    [Minimum_in_iteration,incompetent_krill] = min(fitness);
    
    if global_worst_fitness > Minimum_in_iteration
        global_worst_fitness = Minimum_in_iteration;
        global_worst_selection = selector(incompetent_krill,:);
    end
    [Max_in_iteration,competent_krill] = max(fitness);
    if global_best_fitness < Max_in_iteration
        global_best_fitness = Max_in_iteration;
        global_best_selection = selector(competent_krill,:);
    end
    
    disp("wait");
    
    %% Motion calculation
    
    induced_MotioN = zeros(population,size(Data.X,2));
    induced_MotioN_max = zeros(population,size(Data.X,2));
    sensing_distance_krill = zeros(population);
    near_neighbor_idx = zeros(population,1);
    % sensing_distance 범위 내의 neighbor을 탐색
    for i=1:population
%       sensing_distance_krill(i,:) = sum(pdist([selector(i,:);selector(:,:)],'euclidean'))/(5*population);
        for j = 1:population
            sensing_distance_krill(i,j) = pdist([selector(i,:);selector(j,:)],'euclidean');
        end
        temp = lowest_p(sensing_distance_krill(i,:),0.4);
        temp(find(temp==i))=[];
        near_neighbor_idx(i,:) = temp;
    end
    
    
    % Motion Induced by other krill individuals
    c_best = 2*(rand()+iteration/iterationMax);
    a_local = zeros(population, size(Data.X,2));
    a_target = zeros(population, size(Data.X,2));
    attraction = zeros(population,size(Data.X,2));
    
    for i=1:population
       for j=1:size(near_neighbor_idx,2) 
           x_Aprox = (selector(near_neighbor_idx(i,j),:) - selector(i,:))./(abs(selector(near_neighbor_idx(i,j),:) - selector(i,:))+1);
           f_Aprox = (fitness(i)-fitness(near_neighbor_idx(i,j)))/(global_worst_fitness-global_best_fitness);
           a_local(i,:) = a_local(i,:) + x_Aprox*f_Aprox;
       end
       
       a_target(i,:) = c_best * best_selector(i,:)* best_fitness(i);
       attraction(i,:) = a_local(i,:) + a_target(i,:);
       induced_MotioN(i,:) = global_best_selection .* attraction(i,:) + inertia_weightN * induced_MotioN(i,:);
    end
    % Foraging activity
    
    
    
    % Random Diffusion
    
    %% Implement the genetic operators(OPTIONAL)
    
    %%
end



end

function res = lowest_p(arr, p)
    if (p>1||p<0)
        disp("wrong " + p + " input");
        res = NaN;
    else
        n = floor(length(arr)*p);
        
        [arrs, index] = sort(arr);
        
        res = index(1:n);
        
    end
end

function res = rand_bet(a,b)
    %a<b  
    res = (b-a)*rand()+a;
end