% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(A) :- p1(A, B), p1(A, C), p3(B, V), p3(C, V), p8(C), p6(B).
p0(A) :- p1(A, B), p1(A, C), p2(B, C), \+ p7(B), \+ p7(C).
p0(A) :- p1(A, B), p1(A, C), p2(B, C), p6(B), p5(B, V), p11(V).
p0(A) :- p1(A, B), p1(A, C), p2(B, C), p3(B, 9), p5(B, 10).
