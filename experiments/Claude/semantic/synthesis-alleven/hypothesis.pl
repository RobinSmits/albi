% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A) :- empty(A).
f(A) :- head(A,B), even(B), tail(A,C), f(C).
