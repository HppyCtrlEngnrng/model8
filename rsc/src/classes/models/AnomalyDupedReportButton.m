classdef AnomalyDupedReportButton < BaseModel
    properties(Access=private)
        gameover_count
        is_root_opened
        trigger_sysname
        fake_button_names
        button_position
        button_size_origin
    end

    properties(Constant, Access=private)
        GAMEOVER_TIMELIMIT = 100;
        BUTTON_MARGIN = 1;
    end

    methods(Access=public)
        function obj = AnomalyDupedReportButton(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            obj.is_root_opened = false;
            load_system('fake_buttons');
            obj.fake_button_names = find_system('fake_buttons', 'SearchDepth', 1, 'Type', 'Block');
            close_system('fake_buttons', 0);
            [~, button_order] = sort(rand(1, length(obj.fake_button_names)+1));
            [button_r, button_c] = ind2sub(4, button_order);

            button_pos_origin = get_param(obj.h_report_anomaly_button, "Position");

            obj.button_position = button_pos_origin + repmat([
                (button_pos_origin(3)-button_pos_origin(1)+AnomalyDupedReportButton.BUTTON_MARGIN)*(button_r-1);
                (button_pos_origin(4)-button_pos_origin(2)+AnomalyDupedReportButton.BUTTON_MARGIN)*(button_c-1)
            ]', 1, 2);

            fake_button_dst = strrep(obj.fake_button_names, "fake_buttons", "model_x");
            for idx_button = 1:length(obj.fake_button_names)
                h_dst_blk = add_block(obj.fake_button_names{idx_button}, fake_button_dst{idx_button});
                set_param(h_dst_blk, "Position", obj.button_position(idx_button,:));
            end
            set_param(obj.h_report_anomaly_button, "Position", obj.button_position(end,:));

            obj.RunModel();
        end

        function Update(obj)
        end
    end
end