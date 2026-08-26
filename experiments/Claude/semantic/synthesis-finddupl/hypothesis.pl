% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A, B) :- head(A, B), tail(A, T), element(T, B).
f(A, B) :- tail(A, T), f(T, B).
