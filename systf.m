classdef systf < handle
    %systf    symbolic transfer function
    %   systf(num, den);
    
    properties (Access = protected)
        Numerator
        Denominator
    end
    
    methods
        function obj = systf(varargin)
            %systf    construct systf class
            %   systf(num, den)
            
            if nargin == 2
                obj.Numerator = varargin(1);
                obj.Denominator = varargin(2);
                
            else
                return
            end
        end
    end
end

