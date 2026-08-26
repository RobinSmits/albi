% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
next_score(E,P,S) :- my_true_score(E,P,S), different(P,Q), does(E,P,A), does(E,Q,A).
next_score(E,P,N) :- my_true_score(E,P,S), my_succ(S,N), different(P,Q), does(E,P,A), does(E,Q,B), beats(A,B).
next_score(E,P,S) :- my_true_score(E,P,S), different(P,Q), does(E,P,A), does(E,Q,B), beats(B,A).
