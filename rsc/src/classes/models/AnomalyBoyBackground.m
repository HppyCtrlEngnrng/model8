classdef AnomalyBoyBackground < BaseModel
    properties(Constant, Access=private)
        TARGET_SUBSYSTEM_PATH = [
            "model_x/root"
            "model_x/root/bounce"
            "model_x/root/brownian noise"
            "model_x/root/constant"
            "model_x/root/control system"
            "model_x/root/oscillator"
        ];
        IMAGE_SCALE = 2;
    end

    properties(Constant, Access=public)
        IMAGE_PATH = "./rsc/img/boy_bg.png";
    end

    methods(Access=public)
        function obj = AnomalyBoyBackground(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            AnomalyBoyBackground.PutImage();
            obj.RunModel();
        end

        function Update(obj)
        end
    end

    methods(Static, Access=private)
        function PutImage()
            target_subsys_id = randi(length(AnomalyBoyBackground.TARGET_SUBSYSTEM_PATH));

            h_target = find_system(AnomalyBoyBackground.TARGET_SUBSYSTEM_PATH(target_subsys_id), "SearchDepth", 0);

            h_ann = Simulink.Annotation(h_target{1}, '');
            setImage(h_ann, AnomalyBoyBackground.IMAGE_PATH);
            h_ann.Position = AnomalyBoyBackground.IMAGE_SCALE * h_ann.Position;
        end
    end
end