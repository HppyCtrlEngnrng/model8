classdef AnomalyConstantOne < BaseModel
    properties(Constant, Access=private)
        SRC_BLOCK_PATH = "constant_one/constant";
        DST_BLOCK_PATH = "model_x/root/constant";
    end

    methods(Access=public)
        function obj = AnomalyConstantOne(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            SwapBlock( ...
                AnomalyConstantOne.SRC_BLOCK_PATH, ...
                AnomalyConstantOne.DST_BLOCK_PATH);
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end