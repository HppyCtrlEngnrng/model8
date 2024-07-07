classdef AnomalyAdditionalRuleLine < BaseModel
    properties(Constant, Access=private)
        ROOT_BLOCK_NAME = "model_x/root";
    end

    properties(Access=private)
        entered_root
    end

    methods(Access=public)
        function obj = AnomalyAdditionalRuleLine(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            obj.entered_root = false;
            obj.RunModel();
        end

        function Update(obj)
            if ~obj.entered_root && gcs==AnomalyAdditionalRuleLine.ROOT_BLOCK_NAME
                obj.entered_root = true;
                AnomalyAdditionalRuleLine.AddRuleLine();
            end
        end
    end

    methods(Static, Access=private)
        function AddRuleLine()
            h_ann = find_system("model_x", "FindAll", "on", "type", "annotation");
            rule_text = get_param(h_ann, "Text");
            rule_text=strrep(rule_text, ...
                "</ol></body></html>", ...
                newline+"<li style="" font-size:20px;"" align=""left"" style="" margin-top:0px; margin-bottom:0px; margin-left:27px; margin-right:0px; -qt-block-indent:0; text-indent:0px;""><span style="" font-size:20px;"">A robot may not injure a human being or, through inaction, allow a human being to come to harm.</span></li></ol></body></html>");
            set_param(h_ann, "Text", rule_text);
        end
    end
end