% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
p0(A,B) :- p1(A,C), p2(_,B), p2(C,_).
p0(A,B) :- p2(A,_), p2(_,B).
