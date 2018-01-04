function res = classifer(data, answer ,sim_seq, classiferNum)

    if classiferNum == 1
        res = knnClassifier(data, answer ,sim_seq);
    end
    
    if classiferNum ==2
            res = nbClassifier(data, answer ,sim_seq);
    end
    
    if classiferNum ==3
            res = dtClassifier(data, answer ,sim_seq);
    end
    
    if classiferNum ==4
            res = mSvmClassifier(data, answer ,sim_seq);
    end
end


function res = knnClassifier(X, Y, sim_seq)

sim_num = size(sim_seq, 2);
res = zeros(sim_num, 1);


parfor i = 1:sim_num
    idx = sim_seq(:,i);
    
    tr_data = X(idx,:);
    tr_ans = Y(idx,:);
    ts_data = X(~idx,:);
    ts_ans = Y(~idx,:);
    
    mdl = fitcknn(tr_data ,tr_ans, 'NumNeighbors', 5);
    pre = mdl.predict(ts_data);
    
    res(i,1) = sum(pre == ts_ans) / size(ts_ans, 1);
    
end

end


function res = nbClassifier(data, answer ,sim_seq)
sim_num = size(sim_seq, 2);
res = zeros(sim_num, 1);
parfor i = 1:sim_num
    tr_data = data(sim_seq(:,i), :);
    tr_ans = answer(sim_seq(:,i), :);
    ts_data = data(~sim_seq(:,i),:);
    ts_ans = answer(~sim_seq(:,i),:);
    
    mdl = fitcnb(tr_data, tr_ans, 'DistributionName', 'mvmn');
    pre = mdl.predict(ts_data);
    
    acc = sum(pre == ts_ans) / size(ts_ans, 1);
    res(i,1) = acc;
end

end


function res = dtClassifier(data, answer ,sim_seq)
% nb = Decision Tree
% multiclass classification 을 위해서 매트랩의 fitcree를 사용하였다.


sim_num = size(sim_seq, 2);
res = zeros(sim_num, 1);

parfor i = 1:sim_num
    tr_data = data(sim_seq(:,i), :);
    tr_ans = answer(sim_seq(:,i), :);
    ts_data = data(~sim_seq(:,i),:);
    ts_ans = answer(~sim_seq(:,i),:);
    
    mdl = fitctree(tr_data,tr_ans);
    pre = mdl.predict(ts_data);
    
    acc = sum(pre == ts_ans) / size(ts_ans, 1);
    res(i,1) = acc;
end

end



%Multiclass svm classifier
function res = mSvmClassifier(data, answer ,sim_seq)

sim_num = size(sim_seq, 2);
res = zeros(sim_num, 1);
parfor i = 1:sim_num
    tr_data = data(sim_seq(:,i), :);
    tr_ans = answer(sim_seq(:,i), :);
    
    ts_data = data(~sim_seq(:,i),:);
    ts_ans = answer(~sim_seq(:,i),:);
    
    
    mdl = fitcecoc(tr_data, tr_ans);
    pre = mdl.predict(ts_data);

    acc = sum(pre == ts_ans) / size(ts_ans, 1);
    res(i,1) = acc;
end

end