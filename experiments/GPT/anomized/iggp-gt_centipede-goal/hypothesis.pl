% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p1(X,c37,0):-p4(X,c37).
p1(X,c37,Z):-p4(X,c36),p3(X,A),p6(A,Z),p2(X,Z).
p1(X,c36,Z):-p4(X,c36),p3(X,Z),p6(Z,A),p2(X,A).
p1(X,c36,Z):-p4(X,c37),p2(X,A),p6(A,B),p6(B,C),p6(C,Z),p3(X,Z).
p1(X,c36,0):-p4(X,_),\+ (p4(X,c37),p2(X,A),p6(A,B),p6(B,C),p6(C,D),p3(X,D)),\+ (p4(X,c36),p3(X,E),p6(E,F),p2(X,F),p6(_,E)).
p1(X,c37,0):-p4(X,c36),p3(X,A),p2(X,B),\+ p6(A,B).
