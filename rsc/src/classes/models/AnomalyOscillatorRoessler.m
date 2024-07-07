classdef AnomalyOscillatorRoessler < BaseModel
    properties(Constant, Access=private)
        SRC_BLOCK_PATH = "oscillator_roessler/oscillator";
        DST_BLOCK_PATH = "model_x/root/oscillator";
    end

    methods(Access=public)
        function obj = AnomalyOscillatorRoessler(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            SwapBlock( ...
                AnomalyOscillatorRoessler.SRC_BLOCK_PATH, ...
                AnomalyOscillatorRoessler.DST_BLOCK_PATH);
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end