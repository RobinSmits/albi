% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A,A) :- empty(A).
f(A,B) :- head(A,C), tail(A,D), f(D,E), my_append(E,C,B).
