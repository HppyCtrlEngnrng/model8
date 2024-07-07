classdef AnomalyBounceConverge < BaseModel
    properties(Constant, Access=private)
        SRC_BLOCK_PATH = "bounce_converge/bounce";
        DST_BLOCK_PATH = "model_x/root/bounce";
    end

    methods(Access=public)
        function obj = AnomalyBounceConverge(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            SwapBlock( ...
                AnomalyBounceConverge.SRC_BLOCK_PATH, ...
                AnomalyBounceConverge.DST_BLOCK_PATH);
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end