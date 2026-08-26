% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
goal(A, B, C) :- true_success(A, D), int_15(E), less_than(D, E), score_0(C), role(B).
goal(A, B, C) :- true_success(A, D), int_15(D), score_25(C), role(B).
goal(A, B, C) :- true_success(A, D), int_20(D), score_50(C), role(B).
goal(A, B, C) :- true_success(A, D), int_26(D), score_75(C), role(B).
goal(A, B, C) :- true_success(A, D), int_30(D), score_100(C), role(B).
