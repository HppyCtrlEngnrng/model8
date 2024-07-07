classdef AnomalyTimeLimit < BaseModel
    properties(Constant, Access=private)
        TIME_LIMIT = 60;
    end

    methods(Access=public)
        function obj = AnomalyTimeLimit(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            set_param(obj.h_model, 'StopTime', sprintf("%d", AnomalyTimeLimit.TIME_LIMIT));
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end