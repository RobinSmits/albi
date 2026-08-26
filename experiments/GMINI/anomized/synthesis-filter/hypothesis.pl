% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
p0(A, A) :- p1(A).
p0(A, B) :- p4(A, C), p2(C), p5(A, D), p0(D, B).
p0(A, B) :- p4(A, C), p3(C), p5(A, D), p0(D, E), p5(B, E), p4(B, C).
