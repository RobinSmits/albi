% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
next_list(A, B) :- head(A, C), x(C), tail(A, D), head(D, B).
next_list(A, B) :- tail(A, C), next_list(C, B).
