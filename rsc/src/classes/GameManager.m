classdef GameManager < handle
    properties(Access=private)
        round_number uint8
        model_manager ModelManager
        round_result_log EnumRoundResult
        start_time datetime
    end

    properties(Constant, Access=private)
        END_ROUND = uint8(8);
        GAME_LOOP_WAIT = 0.1;
    end

    methods(Access=public)
        function obj = GameManager()
            obj.round_number = 0;
            obj.model_manager = ModelManager();
            obj.round_result_log = EnumRoundResult.empty;
        end

        function GameMain(obj)
            obj.InitResources();

            while true
                is_round_successed = obj.RoundMain();

                if obj.CheckGameEnd(is_round_successed)
                    break;
                end

                if is_round_successed
                    obj.round_number = obj.round_number + 1;
                else
                    obj.round_number = 0;
                end
            end

            obj.OnGameEnd();
        end

        function is_end = CheckGameEnd(obj, is_round_successed)
            is_end = is_round_successed && (obj.round_number == GameManager.END_ROUND);
        end
    end

    methods(Access=private)
        function OnGameEnd(obj)
            end_time = datetime();

            num_rounds = length(obj.round_result_log);
            num_success = sum(EnumRoundResult.IsSuccess(obj.round_result_log));
            num_tp = sum(obj.round_result_log == EnumRoundResult.END_TP);
            num_tn = sum(obj.round_result_log == EnumRoundResult.END_TN);
            num_fp = sum(obj.round_result_log == EnumRoundResult.END_FP);
            num_fn = sum(obj.round_result_log == EnumRoundResult.END_FN);
            num_failed = num_rounds - num_success;
            num_aborted = sum(obj.round_result_log==EnumRoundResult.END_ABORT);

            precision = num_tp / (num_tp + num_fp);
            recall = num_tp / (num_tp + num_fn);

            anomalies_encountered = sum(obj.model_manager.anomaly_found_flag);

            fprintf("*** CONGRATULATIONS! ***\n");
            fprintf("                        \n");
            fprintf("  play time: %s\n", string(end_time-obj.start_time));
            fprintf("  anomalies encountered: %d\n", anomalies_encountered);
            fprintf("                        \n");
            fprintf("  rounds played: %d\n", num_rounds);
            fprintf("    successed: %d (%3.2f %%)\n", num_success, num_success/num_rounds*100);
            fprintf("      true positive: %d (%3.2f %%)\n", num_tp, num_tp/num_success*100);
            fprintf("      true negative: %d (%3.2f %%)\n", num_tn, num_tn/num_success*100);
            fprintf("    failed: %d (%3.2f %%)\n", num_failed, num_failed/num_rounds*100);
            fprintf("      aborted: %d (%3.2f %%)\n", num_aborted, num_aborted/num_failed*100);
            fprintf("      false positive: %d (%3.2f %%)\n", num_fp, num_fp/num_failed*100);
            fprintf("      false negative: %d (%3.2f %%)\n", num_fn, num_fn/num_failed*100);
            fprintf("                        \n");
            fprintf("  performance metrics\n");
            fprintf("    precision: %1.3f\n", precision);
            fprintf("    recall: %1.3f\n", recall);
            fprintf("    accuracy: %1.3f\n", (num_tp + num_tn) / (num_tp + num_tn + num_fp + num_fn));
            fprintf("    f1: %1.3f\n", 2 * precision * recall / (precision + recall));

        end

        function is_round_successed = RoundMain(obj)
            obj.model_manager.InitModel(obj.round_number);

            while true
                obj.model_manager.Update();
                pause(GameManager.GAME_LOOP_WAIT);

                round_result = obj.model_manager.CheckRoundEnd();
                if round_result ~= EnumRoundResult.IN_ROUND
                    obj.round_result_log(end+1) = round_result;
                    break;
                end
            end

            obj.model_manager.CloseModel();
            is_round_successed = EnumRoundResult.IsSuccess(round_result);
        end

        function InitResources(obj)
            disp("initializing resources...");
            h_f = figure("Visible", "off");
            h_a = axes(h_f, "Visible", "off");
            h_i = image(h_a);
            I = h_i.CData;

            len_x = size(I, 1);
            len_y = size(I, 2);
            
            [X, Y] = meshgrid(1:len_x, 1:len_y);
            [Xq, Yq] = meshgrid(1:0.1:len_x, 1:0.1:len_y);
            
            Iq = interp2(X, Y, I, Xq, Yq);
            Iq = rescale(Iq);
            
            [Xv, Yv] = meshgrid(abs(linspace(-1, 1, size(Xq, 1))));
            Iq = Iq + max(Xv, Yv);
            Iq = min(1, (Iq+0.25) .^ (1/8));
            imwrite(Iq, AnomalyBoyBackground.IMAGE_PATH);
            imwrite(rescale(I), AnomalyBoyScreenEdge.IMAGE_PATH);

            obj.start_time = datetime();
        end
    end
end