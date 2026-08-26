% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A) :- my_length(A, B), geq(2, B).
f(A) :- comps(A, B, C), head(C, D), geq(D, B), f(C).
