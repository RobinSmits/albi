% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
f([]).
f([A|B]) :- even(A), f(B).
