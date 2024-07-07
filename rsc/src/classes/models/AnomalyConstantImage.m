classdef AnomalyConstantImage < BaseModel
    properties(Constant, Access=private)
        SRC_BLOCK_PATH = "constant_image/constant";
        DST_BLOCK_PATH = "model_x/root/constant";
        IMAGE_PATH = "./rsc/img/constant_image.png";
    end

    methods(Static, Access=private)
        function SetImage()
            h_ann = find_system(AnomalyConstantImage.DST_BLOCK_PATH, "FindAll", "on", "type", "annotation");
            setImage(get_param(h_ann, "Object"), AnomalyConstantImage.IMAGE_PATH);
        end
    end

    methods(Access=public)
        function obj = AnomalyConstantImage(round_number, is_first_round)
            obj = obj@BaseModel(round_number, is_first_round);
            obj.is_abnormal = true;
            SwapBlock( ...
                AnomalyConstantImage.SRC_BLOCK_PATH, ...
                AnomalyConstantImage.DST_BLOCK_PATH);
            AnomalyConstantImage.SetImage();
            obj.RunModel();
        end

        function Update(obj)
            
        end
    end
end