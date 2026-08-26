% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(A, B) :- p1(A), p1(B).
p0(A, B) :- p4(A, C), p2(C), p5(A, D), p0(D, B).
p0(A, B) :- p4(A, C), p3(C), p5(A, D), p0(D, E), p4(B, C), p5(B, E).
