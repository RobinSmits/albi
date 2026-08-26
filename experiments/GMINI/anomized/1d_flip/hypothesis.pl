% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
p1(A, B, C) :- p2(A, B, _), p3(B, D), p2(A, D, C).
p1(A, B, C) :- p2(A, B, _), p3(B, D), p6(A, D), p6(A, E), p3(E, F), p2(A, F, C).
