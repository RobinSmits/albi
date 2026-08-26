% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
ancestor(X,Y) :- father(X,Y).
ancestor(X,Y) :- mother(X,Y).
ancestor(X,Y) :- father(X,Z), ancestor(Z,Y).
ancestor(X,Y) :- mother(X,Z), ancestor(Z,Y).
