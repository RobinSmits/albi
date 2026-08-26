% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
out(A, B, C) :- in(A, B, C).
out(A, B, C) :- in(A, D, C), my_succ(D, B), my_succ(E, D), empty(A, E).
out(A, B, C) :- in(A, D, C), my_succ(B, D), my_succ(D, E), empty(A, E).
