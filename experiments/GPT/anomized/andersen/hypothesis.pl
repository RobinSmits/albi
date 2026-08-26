% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p0(A,B):-p2(A,_),p1(_,B).
p0(A,B):-p1(A,B).
p0(A,B):-p4(A,_),p1(_,B).
p0(A,B):-p1(_,A),p1(_,B).
