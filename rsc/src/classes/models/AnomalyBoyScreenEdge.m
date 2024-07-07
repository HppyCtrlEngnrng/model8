classdef AnomalyBoyScreenEdge < BaseModel
    properties(Constant, Access=private)
        IMAGE_SCALE = 10;
        IMAGE_POSITION = [4000, 4000];
    end

    properties(Constant, Access=public)
        IMAGE_PATH = "./rsc/img/boy.png";
    end

    methods(Access=public)
        function obj = AnomalyBoyScreenEdge(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            obj.PutImage();
            obj.RunModel();
        end

        function Update(obj)
        end
    end

    methods(Access=private)
        function PutImage(obj)
            h_ann = Simulink.Annotation(obj.h_model, '');
            setImage(h_ann, AnomalyBoyScreenEdge.IMAGE_PATH);
            h_ann.Position = AnomalyBoyScreenEdge.IMAGE_SCALE * h_ann.Position;
            h_ann.Position(1:2) = h_ann.Position(1:2) + AnomalyBoyScreenEdge.IMAGE_POSITION;
        end
    end
end