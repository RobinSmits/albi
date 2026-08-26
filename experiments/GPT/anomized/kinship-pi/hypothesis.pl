% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p0(A,B) :- p1(A,C), p2(C,_), p2(_,B).
p0(A,B) :- p2(A,_), p2(_,B).
