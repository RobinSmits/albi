% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(A,A) :- p4(A).
p0(A,B) :- p1(A,C), p2(A,D), p0(D,E), p3(E,C,B).
