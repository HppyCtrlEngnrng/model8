classdef AnomalySwappedButtonColor < BaseModel
    methods(Access=public)
        function obj = AnomalySwappedButtonColor(round_number, is_first_round)
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
            color_swap = get_param(obj.h_no_report_button, "BackgroundColor");
            set_param( ...
                obj.h_no_report_button, ...
                "BackgroundColor", get_param(obj.h_report_anomaly_button, "BackgroundColor"));
            set_param(obj.h_report_anomaly_button, "BackgroundColor", color_swap);
        end
    end
end