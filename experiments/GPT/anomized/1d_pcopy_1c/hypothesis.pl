% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p1(A,B,C):-p2(A,B,C).
p1(A,B,C):-p2(A,D,C),p3(B,D),p3(D,E),p6(A,E).
p1(A,B,C):-p2(A,D,C),p3(D,B),p3(E,D),p6(A,E).
