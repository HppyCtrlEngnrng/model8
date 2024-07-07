classdef AnomalyDodgingButton < BaseModel
    properties(Access=private)
        dodge_count
    end

    properties(Constant)
        DODGE_INTERVAL = 10;
        DODGE_START_WAIT = 50;
        DODGE_MAX_DISTANCE = 500;
    end

    methods(Access=public)
        function obj = AnomalyDodgingButton(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            obj.dodge_count = AnomalyDodgingButton.DODGE_START_WAIT;
            obj.RunModel();
        end

        function Update(obj)
            if obj.dodge_count > 0
                obj.dodge_count = obj.dodge_count - 1;
            else
                obj.dodge_count = AnomalyDodgingButton.DODGE_INTERVAL;
                button_position = get_param(obj.h_report_anomaly_button, "Position");
                button_position = button_position + repmat( ...
                    randi([-AnomalyDodgingButton.DODGE_MAX_DISTANCE, AnomalyDodgingButton.DODGE_MAX_DISTANCE], 1, 2) ...
                    , 1, 2);
                set_param(obj.h_report_anomaly_button, "Position", button_position);
            end
        end
    end
end