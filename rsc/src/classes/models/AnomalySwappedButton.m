classdef AnomalySwappedButton < BaseModel
    methods(Access=public)
        function obj = AnomalySwappedButton(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            obj.SwapButtons();
            obj.RunModel();
        end

        function Update(obj)
        end
    end

    methods(Access=private)
        function SwapButtons(obj)
            pos_swap = get_param(obj.h_no_report_button, "Position");
            set_param( ...
                obj.h_no_report_button, ...
                "Position", get_param(obj.h_report_anomaly_button, "Position"));
            set_param(obj.h_report_anomaly_button, "Position", pos_swap);
        end
    end
end