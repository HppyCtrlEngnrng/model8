classdef NominalModel < BaseModel
    methods(Access=public)
        function obj = NominalModel(round_number, is_first_round)
            obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = false;
            obj.RunModel();
        end

        function Update(obj)
        end
    end
end