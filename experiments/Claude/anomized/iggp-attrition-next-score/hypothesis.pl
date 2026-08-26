% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(A,B,C) :- p3(A,B), p6(A,B,D), p4(C,D), p7(B,E), p6(A,E,C), p6(G,B,C), p3(G,B).
p0(A,B,C) :- p6(A,B,C), p7(B,E), p6(A,E,D), p4(C,D), p6(G,E,C), p3(G,E).
p0(A,B,C) :- p3(A,B), p7(B,E), p6(A,B,D), p6(A,E,D), p4(C,D), p6(G,B,C), p3(G,B), p1(A,B,F), p1(G,B,F), p6(H,E,C), p3(H,E).
p0(A,B,C) :- p6(A,B,C), p7(B,E), p6(G,E,C), p3(G,E), p1(A,B,F), p1(G,E,F), p1(A,E,F2), p1(G,B,F2), p6(G,B,D), p4(D,C), \+ (p5(K), p6(K,B,C)).
p0(A,B,C) :- p6(A,B,C), p7(B,E), p6(A,E,D), p4(D,C), p5(K), p6(K,E,D), p5(J), p6(J,B,C).
p0(A,B,C) :- p6(A,B,C), p7(B,E), p6(J,B,D), p4(C,D), p6(J,E,C), p1(A,E,F), p1(J,B,F), p5(H), p6(H,B,C).
