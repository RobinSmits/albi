% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3.1-pro-preview
p0(A) :- p2(A,B), p2(B,C), p6(C).
p0(A) :- p1(A,C), p2(A,B), p1(B,D), p5(D,C), p0(B).
