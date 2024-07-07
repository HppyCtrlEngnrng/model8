function model8()
    clc;
    addpath("./rsc/src");
    addpath("./rsc/slx");
    addpath("./rsc/src/classes");
    addpath("./rsc/src/classes/models");
    game_manager = GameManager();
    game_manager.GameMain();
end