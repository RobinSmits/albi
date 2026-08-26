% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
next_score(Ex, P, S) :- does(Ex, P, A), does(Ex, Q, A), different(P, Q), my_true_score(Ex, P, S).
next_score(Ex, P, S2) :- does(Ex, P, A), does(Ex, Q, B), different(P, Q), beats(A, B), my_true_score(Ex, P, S1), my_succ(S1, S2).
next_score(Ex, P, S) :- does(Ex, P, A), does(Ex, Q, B), different(P, Q), beats(B, A), my_true_score(Ex, P, S).
