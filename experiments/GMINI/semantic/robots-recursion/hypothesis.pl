% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A, A) :- at_top(A).
f(A, B) :- move_up(A, C), f(C, B).
