% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A,A) :- at_top(A).
f(A,B) :- move_up(A,C), f(C,B).
