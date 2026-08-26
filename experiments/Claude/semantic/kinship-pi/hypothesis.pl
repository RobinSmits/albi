% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
inv1(A,B) :- mother(A,B).
inv1(A,B) :- father(A,B).
grandparent(A,B) :- inv1(A,C), inv1(C,B).
