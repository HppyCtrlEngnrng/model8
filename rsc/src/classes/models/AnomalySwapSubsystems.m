classdef AnomalySwapSubsystems < BaseModel
    properties(Constant, Access=private)
        TARGET_SUBSYSTEM_PATH = [
            "model_x/root/bounce"
            "model_x/root/brownian noise"
            "model_x/root/constant"
            "model_x/root/control system"
            "model_x/root/oscillator"
        ];
    end

    methods(Access=public)
        function obj = AnomalySwapSubsystems(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            obj.SwapSubsystems();
            obj.RunModel();
        end

        function Update(obj)
        end
    end

    methods(Static, Access=private)
        function SwapSubsystems()
            [~, idx_models] = sort(rand(1, length(AnomalySwapSubsystems.TARGET_SUBSYSTEM_PATH)));
            
            pos_1 = get_param(AnomalySwapSubsystems.TARGET_SUBSYSTEM_PATH(idx_models(1)), "Position");
            pos_2 = get_param(AnomalySwapSubsystems.TARGET_SUBSYSTEM_PATH(idx_models(2)), "Position");

            set_param(AnomalySwapSubsystems.TARGET_SUBSYSTEM_PATH(idx_models(1)), "Position", pos_2);
            set_param(AnomalySwapSubsystems.TARGET_SUBSYSTEM_PATH(idx_models(2)), "Position", pos_1);
        end
    end
end