% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
pt(X,Y) :- addr(X,Y).
pt(X,Z) :- assgn(X,Y), pt(Y,Z).
pt(Z,W) :- store(X,Y), assgn(X,A), addr(A,Z), pt(Y,W).
pt(X,W) :- load(X,Y), pt(Y,Z), pt(Z,W).
