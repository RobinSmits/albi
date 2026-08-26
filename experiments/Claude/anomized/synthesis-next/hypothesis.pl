% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(A,B) :- p1(A,C), p3(C), p2(A,D), p1(D,B).
p0(A,B) :- p2(A,C), p0(C,B).
