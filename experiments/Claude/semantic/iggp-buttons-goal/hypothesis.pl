% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
goal(A, B, C) :- role(B), not_my_true(A, _), int_0(C).
goal(A, B, C) :- role(B), my_true(A, D), prop_p(D), my_true(A, E), prop_q(E), my_true(A, F), prop_r(F), int_100(C).
