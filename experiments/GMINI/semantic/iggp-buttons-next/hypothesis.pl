% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
next(A, B) :- my_true(A, C), my_succ(C, B).
next(A, B) :- role(R), c_a(Act), does(A, R, Act), c_p(B), not_my_true(A, B).
next(A, B) :- role(R), c_a(Act), does(A, R, Act), c_q(B), my_true(A, B).
next(A, B) :- role(R), c_a(Act), does(A, R, Act), c_r(B), my_true(A, B).
next(A, B) :- role(R), c_c(Act), does(A, R, Act), c_p(B), my_true(A, B).
next(A, B) :- role(R), c_b(Act), does(A, R, Act), c_q(B), c_p(P), my_true(A, P).
next(A, B) :- role(R), c_c(Act), does(A, R, Act), c_r(B), c_q(P), my_true(A, P).
next(A, B) :- role(R), c_c(Act), does(A, R, Act), c_q(B), c_r(P), my_true(A, P).
next(A, B) :- role(R), c_b(Act), does(A, R, Act), c_p(B), c_q(Q), my_true(A, Q).
next(A, B) :- role(R), c_b(Act), does(A, R, Act), c_r(B), my_true(A, B).
