% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(N, P) :- add(N, _, P), \+ (double(N, P), greater_than(N, 1)).
