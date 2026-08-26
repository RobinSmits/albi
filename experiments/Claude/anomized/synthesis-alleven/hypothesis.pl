% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(A) :- p4(A).
p0(A) :- p2(A,B), p6(B), p1(A,C), p0(C).
