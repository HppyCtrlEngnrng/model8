classdef AnomalyControlUnstable < BaseModel
    properties(Constant, Access=private)
        SRC_BLOCK_PATH = "control_unstable/control system";
        DST_BLOCK_PATH = "model_x/root/control system";
    end

    methods(Access=public)
        function obj = AnomalyControlUnstable(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            SwapBlock( ...
                AnomalyControlUnstable.SRC_BLOCK_PATH, ...
                AnomalyControlUnstable.DST_BLOCK_PATH);
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end