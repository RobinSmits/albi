% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
next(Ex, N2) :- my_true(Ex, N1), my_succ(N1, N2).
next(Ex, R) :- c_r(R), my_true(Ex, R), does(Ex, _, Act), \+ c_c(Act).
next(Ex, P) :- c_p(P), not_my_true(Ex, P), does(Ex, _, Act), c_a(Act).
next(Ex, Q) :- c_q(Q), my_true(Ex, Q), does(Ex, _, Act), c_a(Act).
next(Ex, P) :- c_p(P), my_true(Ex, P), does(Ex, _, Act), c_c(Act).
next(Ex, Q) :- c_q(Q), does(Ex, _, Act), c_b(Act), my_true(Ex, P), c_p(P).
next(Ex, R) :- c_r(R), does(Ex, _, Act), c_c(Act), my_true(Ex, Q), c_q(Q).
next(Ex, Q) :- c_q(Q), does(Ex, _, Act), c_c(Act), my_true(Ex, R), c_r(R).
next(Ex, P) :- c_p(P), does(Ex, _, Act), c_b(Act), my_true(Ex, Q), c_q(Q).
