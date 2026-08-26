% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(X,Y) :- p1(X,Y).
p0(X,Y) :- p2(X,Z), p0(Z,Y).
p0(X,Y) :- p3(X,Z), p0(Z,Y).
p0(X,Y) :- p4(X,Z), p0(Z,Y).
p0(X, Y) :- p1(_, X), p1(_, Y).
