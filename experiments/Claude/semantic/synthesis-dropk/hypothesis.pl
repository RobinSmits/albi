% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A, B, A) :- zero(B).
f(A, B, C) :- tail(A, D), decrement(B, E), f(D, E, C).
