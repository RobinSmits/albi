% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A,A) :- empty(A).
f(A,B) :- prepend(C,D,A), odd(C), f(D,B).
f(A,B) :- prepend(C,D,A), even(C), f(D,E), prepend(C,E,B).
