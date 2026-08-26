% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A,B,A) :- zero(B).
f(A,B,C) :- decrement(B,D), tail(A,E), f(E,D,C).
