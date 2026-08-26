% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p0(A,B,C) :- p3(A,B,C), p1(A,_,X,Y), p6(B,X), p6(B,Y).
p0(A,B,C) :- p1(A,_,B,_), p7(C).
p0(A,B,C) :- p1(A,_,_,B), p9(C).
