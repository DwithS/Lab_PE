function res_table = myBonferroni(count_data, mean_rank1, mean_rank2, mean_rank3, mean_rank4)
% res_table : significance ���, 4*4 table�� ���� 0 �Ǵ� 1�� ����
% res_table�� (i,j)�� i �з��Ⱑ j �з��� ���� significant�ϰ� ������ 1 �ƴϸ� 0
% count_data : data�� ����
% mean_rank# : #��° �з����� ��� ��ũ

r = [mean_rank1;mean_rank2;mean_rank3;mean_rank4];
CD = 2.394 * sqrt(20/(6*count_data));
res_table = zeros(4,4);

for i = 1:4
    for j = 1:4
        if r(j,1) - r(i, 1) > CD
            res_table(i,j) = 1;
    end
end

end