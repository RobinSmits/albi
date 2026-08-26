% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A, B) :- tail(A, C), empty(C), empty(B).
f(A, B) :- head(A, C), tail(A, D), f(D, E), append_(C, E, B).
