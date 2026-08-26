% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p1(A,B,C) :- p2(A,B,_), p3(B,D), p2(A,D,C).
p1(A,B,C) :- p2(A,D,C), \+((p3(E,D), p2(A,E,_))), p2(A,B,_), \+((p3(B,F), p2(A,F,_))).
