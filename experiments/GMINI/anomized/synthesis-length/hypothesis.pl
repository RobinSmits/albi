% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
p0(A,B) :- p4(A), p5(B).
p0(A,B) :- p2(A,C), p0(C,D), p3(D,B).
