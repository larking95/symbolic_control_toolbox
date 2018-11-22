function [ flag, H, Hk ] = isstable_hulwitz( poly_vec )
%ISSTABLE_ROUTH この関数の概要をここに記述
%   詳細説明をここに記述

a = poly_vec;
Na = length(a);

%フルビッツ行列 H
if isa(poly_vec, 'sym')
    H(1:Na-1, 1:Na-1) = sym(0);
else
    H = zeros([Na-1, Na-1]);
end

%フルビッツ行列への係数の代入
a_ = fliplr(a);
for i = 1:Na-1
    for j = 1:Na-1
        k = Na - 2*j + i;
        if k > Na || k <= 0
            H(i,j) = 0;
        else
            H(i,j) = a_(k);
        end
    end
end

%主座小行列式の計算
if isa(poly_vec, 'sym')
    Hk(1:Na-1, 1) = sym(0);
else
    Hk = nan([Na-1,1]);
end
for k = 1:Na-1
    Hk(k) = det(H(1:k,1:k));
end

%安定判別
if ~isempty(find(Hk < 0, 1))
    flag = false;   %unstable
else
    flag = true;    %stable
end
end

