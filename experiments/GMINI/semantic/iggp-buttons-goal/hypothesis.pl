% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
goal(A, _, C) :- int_0(C), not_my_true(A, _).
goal(A, _, C) :- int_100(C), prop_p(P), my_true(A, P), prop_q(Q), my_true(A, Q), prop_r(R), my_true(A, R).
