classdef AnomalyBrownian2 < BaseModel
    properties(Constant, Access=private)
        SRC_BLOCK_PATH = "brownian_noise_2/brownian noise";
        DST_BLOCK_PATH = "model_x/root/brownian noise";
    end

    methods(Access=public)
        function obj = AnomalyBrownian2(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            SwapBlock( ...
                AnomalyBrownian2.SRC_BLOCK_PATH, ...
                AnomalyBrownian2.DST_BLOCK_PATH);
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end