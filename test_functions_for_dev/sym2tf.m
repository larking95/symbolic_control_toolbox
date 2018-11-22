function [tfModel] = sym2tf(symModel, Ts)
%sym2tf  Symbolic�ȓ`�B�֐���tf���f���ɕϊ�����
%   tfModel = sym2tf(symModel, __)
%
%       tfModel:    tf�`�B�֐����f��
%       symModel:   symbolic�֐��ŕ\�����`�B�֐�
%                   (Notice! 's' or 'z' should be only symbolic variable.)
%       Ts:         �T���v�����O����[s] (If using z)
%
%   see also tf, sym.

%% �����̊m�F
validateattributes(symModel, {'sym'}, {'2d'});

syms s z
if length(symvar(symModel)) >= 2
    error('This function can deal with s or z only.');
elseif ~all(all(has(symModel, s))) && ~all(all(has(symModel, z)))
    disp('Input model has a not expected variable.');
    disp(['This function replace the variable (',...
        char(symvar(symModel)), ') to s.']);
    symModel = subs(symModel, symvar(symModel), s);
end

if all(all(has(symModel, s)))
    Ts = 0;
elseif all(all(has(symModel, z))) && ~exist('Ts', 'var')
    error('Descrite time transfer function needs Ts.')
end

%% ���ۂ̏���
if isscalar(symModel)
    % SISO�̏���
    [Numerator, Denominator] = numden(symModel);
    tfModel = tf(sym2poly(Numerator), sym2poly(Denominator), Ts);
else
    % MIMO�̏����i�ċN�Ăяo���j
    tfModel = arrayfun(@(A,B) sym2tf(A, B), symModel, Ts*ones(size(symModel)), 'UniformOutput', false);
    if iscell(tfModel)
        tfModel = cell2tf(tfModel);
    end
end
end

%% ���������p�T�u���[�`��
function tf_ = cell2tf(cell_)
tf_ = tf();
for i = 1:size(cell_, 1)
    for j = 1:size(cell_, 2)
        tf_(i, j) = cell_{i, j};
    end
end
end