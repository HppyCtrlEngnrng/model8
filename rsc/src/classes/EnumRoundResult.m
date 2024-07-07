classdef EnumRoundResult
    enumeration
        IN_ROUND
        END_TP
        END_TN
        END_FP
        END_FN
        END_ABORT
    end

    methods(Static, Access=public)
        function is_success = IsSuccess(round_result)
            is_success = round_result == EnumRoundResult.END_TP ...
                | round_result == EnumRoundResult.END_TN;
        end
    end
end