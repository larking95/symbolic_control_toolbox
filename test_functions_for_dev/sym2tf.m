function [tfModel] = sym2tf(symModel, Ts)
%sym2tf  Symbolicな伝達関数をtfモデルに変換する
%   tfModel = sym2tf(symModel, __)
%
%       tfModel:    tf伝達関数モデル
%       symModel:   symbolic関数で表した伝達関数
%                   (Notice! 's' or 'z' should be only symbolic variable.)
%       Ts:         サンプリング時間[s] (If using z)
%
%   see also tf, sym.

%% 引数の確認
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

%% 実際の処理
if isscalar(symModel)
    % SISOの処理
    [Numerator, Denominator] = numden(symModel);
    tfModel = tf(sym2poly(Numerator), sym2poly(Denominator), Ts);
else
    % MIMOの処理（再起呼び出し）
    tfModel = arrayfun(@(A,B) sym2tf(A, B), symModel, Ts*ones(size(symModel)), 'UniformOutput', false);
    if iscell(tfModel)
        tfModel = cell2tf(tfModel);
    end
end
end

%% 内部処理用サブルーチン
function tf_ = cell2tf(cell_)
tf_ = tf();
for i = 1:size(cell_, 1)
    for j = 1:size(cell_, 2)
        tf_(i, j) = cell_{i, j};
    end
end
end