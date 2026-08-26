% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
out(A, B, C) :- in(A, B, _), my_succ(B, D), in(A, D, _), in(A, E, C), my_succ(E, F), empty(A, F).
out(A, B, C) :- in(A, B, _), my_succ(B, D), empty(A, D), in(A, F, C), my_succ(E, F), empty(A, E).
