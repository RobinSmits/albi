% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p0(A) :- p1(A,B), p1(A,C), p2(B,C), p6(B), \+ (p7(C), p5(B,D), p9(D)), \+ (p7(C), p5(B,E), p10(E)).
p0(A) :- p1(A,B), p1(A,C), p6(B), p8(C), p3(B,D), p3(C,D).
p0(A) :- p1(A,B), p1(A,C), p2(B,C), p7(B), p8(C), p5(B,D), p11(D).
p0(A) :- p1(A,B), p1(A,C), p2(B,C), p8(B), p8(C).
p0(A) :- p1(A,B), p2(B,C), p14(B), p15(C), \+ p8(B), \+ p8(C).
