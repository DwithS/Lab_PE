function res_table = myBonferroni(count_data, mean_rank)
% res_table : significance ���, 4*4 table�� ���� 0 �Ǵ� 1�� ����
% res_table�� (i,j)�� i �з��Ⱑ j �з��� ���� significant�ϰ� ������ 1 �ƴϸ� 0
% count_data : data�� ����
% mean_rank# : #��° �з����� ��� ��ũ

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