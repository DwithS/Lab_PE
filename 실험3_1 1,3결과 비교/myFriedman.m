function [res, rf] = myFriedman(count_data, mean_rank1, mean_rank2, mean_rank3, mean_rank4)
% res : friedman test ��� ����, 0 - ��� ����, 1 - �����
% count_data : �׽�Ʈ�� ���� ������ ����
% mean_rank# : #��° �з����� ��� ��ũ

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