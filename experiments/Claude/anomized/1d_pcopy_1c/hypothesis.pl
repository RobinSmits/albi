% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p1(A,B,C) :- p2(A,B,C).
p1(A,B,C) :- p6(A,B), p3(B,D), p2(A,D,C), p3(D,E), p6(A,E).
p1(A,B,C) :- p6(A,B), p3(D,B), p2(A,D,C), p3(E,D), p6(A,E).
