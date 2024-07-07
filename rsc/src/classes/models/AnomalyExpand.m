classdef AnomalyExpand < BaseModel
    properties(Constant, Access=private)
        TARGET_SUBSYSTEM_PATH = [
            "model_x/root/bounce"
            "model_x/root/brownian noise"
            "model_x/root/constant"
            "model_x/root/control system"
            "model_x/root/oscillator"
        ];
        EXPANSION_WAIT_RANGE = [10, 70];
        EXPANSION_MAX_COUNT = 1000;
    end

    properties(Access=private)
        expansion_count
        expansion_wait
        h_targets
    end

    methods(Access=public)
        function obj = AnomalyExpand(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            obj.h_targets = find_system(AnomalyExpand.TARGET_SUBSYSTEM_PATH, "SearchDepth", 0);
            obj.expansion_count = 0;
            obj.expansion_wait = 0;
            obj.RunModel();
        end

        function Update(obj)
            if obj.expansion_count < AnomalyExpand.EXPANSION_MAX_COUNT
                obj.expansion_count = obj.expansion_count + 1;

                if obj.expansion_wait <= 0
                    obj.expansion_wait = randi(AnomalyExpand.EXPANSION_WAIT_RANGE);
                else
                    obj.expansion_wait = obj.expansion_wait - 1;
                    return;
                end
                
                for i_target = 1:length(obj.h_targets)
                    position = get_param(obj.h_targets{i_target}, "Position");
                    position(3:4) = position(3:4) + 1;
                    set_param(obj.h_targets{i_target}, "Position", position);
                end
            end
        end
    end
end