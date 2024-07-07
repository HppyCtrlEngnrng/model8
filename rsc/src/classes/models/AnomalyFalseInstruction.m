classdef AnomalyFalseInstruction < BaseModel
    methods(Access=public)
        function obj = AnomalyFalseInstruction(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            
            h_ann = find_system("model_x", "FindAll", "on", "type", "annotation");
            rule_text = get_param(h_ann, "Text");
            rule_text=strrep(rule_text, "REPORT ANOMALY", "***SWAP***");
            rule_text=strrep(rule_text, "NO ANOMALIES", "REPORT ANOMALY");
            rule_text=strrep(rule_text, "***SWAP***", "NO ANOMALIES");
            rule_text=strrep(rule_text, ...
                "</ol></body></html>", ...
                newline+"<li style="" font-size:20px;"" align=""left"" style="" margin-top:0px; margin-bottom:0px; margin-left:27px; margin-right:0px; -qt-block-indent:0; text-indent:0px;""><span style="" font-size:20px;"">HEY, HERE IS AN ANOMALY!</span></li></ol></body></html>");
            set_param(h_ann, "Text", rule_text);

            button_swap = obj.h_no_report_button;
            obj.h_no_report_button = obj.h_report_anomaly_button;
            obj.h_report_anomaly_button = button_swap;

            obj.RunModel();
        end

        function Update(obj)
        end
    end
end