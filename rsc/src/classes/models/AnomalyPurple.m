classdef AnomalyPurple < BaseModel
    properties(Constant, Access=private)
        SRC_BLOCK_PATH = "purple_noise/brownian noise";
        DST_BLOCK_PATH = "model_x/root/brownian noise";
    end

    methods(Access=public)
        function obj = AnomalyPurple(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            SwapBlock( ...
                AnomalyPurple.SRC_BLOCK_PATH, ...
                AnomalyPurple.DST_BLOCK_PATH);
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end