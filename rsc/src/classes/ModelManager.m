classdef ModelManager < handle
    properties(Access=private)
        is_first_round logical
        anomaly_model_names string
        model_id
        model
    end

    properties(SetAccess=private)
        anomaly_found_flag logical
    end

    properties(Constant, Access=private)
        MODEL_CLASS_PATH = "./rsc/src/classes/models"
        ANOMALY_ROUND_RATIO = 0.6
        NORMAL_MODEL_ID = 0;
    end

    methods(Access=public)
        function obj = ModelManager()
            obj.is_first_round = true;
            
            anomaly_model_files = {dir(fullfile(ModelManager.MODEL_CLASS_PATH, "Anomaly*.m")).name};
            [~, obj.anomaly_model_names, ~] = fileparts(anomaly_model_files);
            obj.anomaly_found_flag = false(size(obj.anomaly_model_names));
        end

        function InitModel(obj, round_number)
            obj.model_id = obj.SelectModel();

            if obj.model_id == ModelManager.NORMAL_MODEL_ID
                obj.model = NominalModel(round_number, obj.is_first_round);
            else
                obj.model = feval(obj.anomaly_model_names(obj.model_id), round_number, obj.is_first_round);
            end

            obj.is_first_round = false;
        end

        function Update(obj)
            obj.model.Update();
        end

        function round_result = CheckRoundEnd(obj)
            round_result = obj.model.CheckRoundResult();

            if round_result == EnumRoundResult.END_TP
                obj.anomaly_found_flag(obj.model_id) = true;
            end
        end

        function CloseModel(obj)
            obj.model.CloseModel();
        end
    end

    methods(Access=private)
        function model_id = SelectModel(obj)
            if obj.is_first_round
                model_id = ModelManager.NORMAL_MODEL_ID;
                return;
            end

            if rand() > ModelManager.ANOMALY_ROUND_RATIO
                model_id = ModelManager.NORMAL_MODEL_ID;
                return;
            end

            if all(obj.anomaly_found_flag)
                model_id = randi(length(obj.anomaly_found_flag));
            else
                unfound_anomaly_id = find(~obj.anomaly_found_flag);
                model_id = unfound_anomaly_id(randi(length(unfound_anomaly_id)));
            end
        end
    end
end