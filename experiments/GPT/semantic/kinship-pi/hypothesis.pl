% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
grandparent(X,Z) :- mother(X,Y), father(Y,_), father(_,Z).
grandparent(X,Z) :- father(X,_), father(_,Z).
