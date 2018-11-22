function [ flag, R ] = isstable_routh( poly_vec )
%ISSTABLE_ROUTH この関数の概要をここに記述
%   詳細説明をここに記述

a = poly_vec;
Na = length(a);

%ラウス表 R
if isa(poly_vec, 'sym')
    R(1:Na, 1:idivide(Na, int8(2), 'ceil')) = sym(0);
else
    R = zeros([Na, idivide(Na, int8(2), 'ceil')]);
end

%ラウス表への係数の代入
if  rem(Na, 2) == 0
    A = reshape(a, [2, size(R, 2)]);
else
    A = reshape([a, 0], [2, size(R, 2)]);
end
R(1:2,:) = A;
clearvars A

%ラウス表の計算
for i = 3:Na
    for j = 1:size(R, 2)-1
        R(i,j) = (R(i-1, 1)*R(i-2, j+1) - R(i-2, 1)*R(i-1, j+1))/R(i-1, 1);
    end
end

%安定判別
if ~isempty(find(R(:,1) < 0, 1))
    flag = false;   %unstable
else
    flag = true;    %stable
end
end

