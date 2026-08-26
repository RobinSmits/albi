% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
p0(A,B) :- p1(A,B), p2(A,C), p3(C,B).
p0(A,B) :- p2(A,C), p0(C,B).
