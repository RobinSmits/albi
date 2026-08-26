% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
next_score(E,A,S) :- my_true_score(E,A,S), does(E,A,noop), does(E,_,lay_claim).
next_score(E,A,S) :- my_true_score(E,A,S), does(E,A,end_game).
next_score(E,A,S) :- my_true_score(E,A,S0), does(E,A,lay_claim), my_succ(S,S0).
