classdef AnomalyLowerModelName < BaseModel
    properties(Constant, Access=private)
        TARGET_BLOCK_NAME = "model_x/root";
    end

    methods(Access=public)
        function obj = AnomalyLowerModelName(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            mask_text = get_param(AnomalyLowerModelName.TARGET_BLOCK_NAME, "MaskDisplay");
            set_param(AnomalyLowerModelName.TARGET_BLOCK_NAME, "MaskDisplay", lower(mask_text));
            obj.RunModel();
        end

        function Update(obj)
        end
    end
end