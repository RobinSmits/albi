% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p3(A,B) :- p1(A,B).
p3(A,B) :- p2(A,B).
p0(A,C) :- p3(A,B), p3(B,C).
