% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A) :- tail(A, B), tail(B, C), empty(C).
f(A) :- head(A, B), tail(A, C), head(C, D), geq(D, B), f(C).
