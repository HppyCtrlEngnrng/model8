classdef AnomalyExitNow < BaseModel
    properties(Access=private)
        gameover_count
        is_target_opened
        trigger_sysname
    end

    properties(Constant, Access=private)
        TARGET_SUBSYSTEM_PATH = [
            "model_x/root/bounce"
            "model_x/root/brownian noise"
            "model_x/root/constant"
            "model_x/root/control system"
            "model_x/root/oscillator"
        ];
        GAMEOVER_TIMELIMIT = 100;
    end

    methods(Access=public)
        function obj = AnomalyExitNow(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            target_subsys_id = randi(length(AnomalyExitNow.TARGET_SUBSYSTEM_PATH));
            obj.trigger_sysname = AnomalyExitNow.TARGET_SUBSYSTEM_PATH(target_subsys_id);
            h_ann = Simulink.Annotation(obj.trigger_sysname, 'すぐにけせ');
            h_ann.FontSize = 72;
            obj.gameover_count = AnomalyExitNow.GAMEOVER_TIMELIMIT;
            obj.is_target_opened = false;
            obj.RunModel();
        end

        function Update(obj)
            if gcs == obj.trigger_sysname
                obj.is_target_opened = true;
            end

            if ~obj.is_target_opened
                return;
            end

            if obj.gameover_count > 0
                obj.gameover_count = obj.gameover_count - 1;
                color_ratio = obj.gameover_count/AnomalyExitNow.GAMEOVER_TIMELIMIT;
                set_param(gcs, "ScreenColor", sprintf("[1, %f, %f]", color_ratio, color_ratio));
            else
                obj.aborted = true;
            end
        end
    end
end