function [res, rf] = myFriedman(count_data, mean_rank1, mean_rank2, mean_rank3, mean_rank4)
% res : friedman test 통과 여부, 0 - 통과 못함, 1 - 통과함
% count_data : 테스트에 사용된 데이터 갯수
% mean_rank# : #번째 분류기의 평균 랭크

r = [mean_rank1;mean_rank2;mean_rank3;mean_rank4];
c = count_data;

chi_square = 12*c / 20 * (sum(r .* r) - 25);
f = (c - 1)*chi_square / (c*3 - chi_square);

f_null = finv(0.95, 3, 3*(c-1));

if f>f_null
    res = 1;
    rf = f;
else
    res = 0;
end
end