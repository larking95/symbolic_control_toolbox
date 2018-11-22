function [ flag, R ] = isstable_routh( poly_vec )
%ISSTABLE_ROUTH ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

a = poly_vec;
Na = length(a);

%���E�X�\ R
if isa(poly_vec, 'sym')
    R(1:Na, 1:idivide(Na, int8(2), 'ceil')) = sym(0);
else
    R = zeros([Na, idivide(Na, int8(2), 'ceil')]);
end

%���E�X�\�ւ̌W���̑��
if  rem(Na, 2) == 0
    A = reshape(a, [2, size(R, 2)]);
else
    A = reshape([a, 0], [2, size(R, 2)]);
end
R(1:2,:) = A;
clearvars A

%���E�X�\�̌v�Z
for i = 3:Na
    for j = 1:size(R, 2)-1
        R(i,j) = (R(i-1, 1)*R(i-2, j+1) - R(i-2, 1)*R(i-1, j+1))/R(i-1, 1);
    end
end

%���蔻��
if ~isempty(find(R(:,1) < 0, 1))
    flag = false;   %unstable
else
    flag = true;    %stable
end
end

