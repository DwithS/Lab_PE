function res_table = myBonferroni(count_data, mean_rank)
% res_table : significance 결과, 4*4 table로 값은 0 또는 1을 가짐
% res_table의 (i,j)는 i 분류기가 j 분류기 보다 significant하게 좋으면 1 아니면 0
% count_data : data의 갯수
% mean_rank# : #번째 분류기의 평균 랭크

r = transpose(mean_rank);
r_length = length(r);
CD = 2.394 * sqrt(20/(6*count_data));
res_table = zeros(r_length);

for i = 1:r_length
    for j = 1:r_length
        if r(j,1) - r(i, 1) > CD
            res_table(i,j) = 1;
        end
    end
end

end