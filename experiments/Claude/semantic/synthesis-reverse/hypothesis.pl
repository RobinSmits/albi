% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A,B) :- empty(A), empty(B).
f(A,B) :- head(A,C), tail(A,D), f(D,E), my_append(E,C,B).
