function [ flag, H, Hk ] = isstable_hulwitz( poly_vec )
%ISSTABLE_ROUTH ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

a = poly_vec;
Na = length(a);

%�t���r�b�c�s�� H
if isa(poly_vec, 'sym')
    H(1:Na-1, 1:Na-1) = sym(0);
else
    H = zeros([Na-1, Na-1]);
end

%�t���r�b�c�s��ւ̌W���̑��
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

%������s�񎮂̌v�Z
if isa(poly_vec, 'sym')
    Hk(1:Na-1, 1) = sym(0);
else
    Hk = nan([Na-1,1]);
end
for k = 1:Na-1
    Hk(k) = det(H(1:k,1:k));
end

%���蔻��
if ~isempty(find(Hk < 0, 1))
    flag = false;   %unstable
else
    flag = true;    %stable
end
end

