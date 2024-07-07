classdef (Abstract) BaseModel < handle
    properties(Access=protected)
        h_model
        h_no_report_button
        h_report_anomaly_button
        is_abnormal
        aborted
    end

    properties(Constant, Access=protected)
        NOMINAL_SLX_PATH = "./rsc/slx/nominal_model.slx"
        TEMP_SLX_PATH = "./rsc/slx/model_x.slx"
    end

    methods(Access=public)
        function obj = BaseModel(round_number, is_first_round)
            BaseModel.StopTempSlx();
            copyfile(BaseModel.NOMINAL_SLX_PATH, BaseModel.TEMP_SLX_PATH);
            obj.h_model = load_system(BaseModel.TEMP_SLX_PATH);
            obj.aborted = false;
            obj.SetRoundInfo(round_number, is_first_round);
        end

        function CloseModel(obj)
            set_param(obj.h_model, "SimulationCommand", "Stop");
            close_system(obj.h_model, 0);
        end

        function round_result = CheckRoundResult(obj)
            if ~isempty(get_param(obj.h_no_report_button, "UserData"))
                if obj.is_abnormal
                    round_result = EnumRoundResult.END_FN;
                else
                    round_result = EnumRoundResult.END_TN;
                end
            elseif ~isempty(get_param(obj.h_report_anomaly_button, "UserData"))
                if obj.is_abnormal
                    round_result = EnumRoundResult.END_TP;
                else
                    round_result = EnumRoundResult.END_FP;
                end
            elseif get_param(obj.h_model, "SimulationStatus") ~= "running" || obj.aborted
                round_result = EnumRoundResult.END_ABORT;
            else
                round_result = EnumRoundResult.IN_ROUND;
            end
        end
    end

    methods(Access=protected)
        function RunModel(obj)
            set_param(obj.h_model, "SimulationCommand", "Start");
            open_system(obj.h_model);
        end
    end

    methods(Abstract, Access=public)
        Update(obj)
    end

    methods(Static)
        function StopTempSlx()
            if exist(BaseModel.TEMP_SLX_PATH, "file")
                h_model_tmp = load_system(BaseModel.TEMP_SLX_PATH);
                set_param(h_model_tmp, "SimulationCommand", "Stop");
                close_system(h_model_tmp, 0);
            end
        end
    end

    methods(Access=private)
        function SetRoundInfo(obj, round_number, is_first_round)
            h_root_block = find_system(obj.h_model, "Name", "root");
            obj.h_no_report_button = find_system(obj.h_model, "Name", "green_button");
            obj.h_report_anomaly_button = find_system(obj.h_model, "Name", "orange_button");
            h_root_mask = Simulink.Mask.get(h_root_block);
            h_root_mask.Display = sprintf("disp('Model %d');", round_number);

            if is_first_round
                set_param(obj.h_report_anomaly_button, "Commented", "on");
            end
        end
    end
end