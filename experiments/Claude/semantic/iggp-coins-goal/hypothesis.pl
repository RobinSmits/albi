% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
goal(Ex, A, S) :- score_0(S), role(A), my_true_cell(Ex, _, V), c_onecoin(V).
goal(Ex, A, S) :- score_100(S), role(A), my_true_step(Ex, P), pos_5(P).
