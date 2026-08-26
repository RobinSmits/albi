% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
p0(A,B) :- p3(A,C), p4(C,B).
p0(A,B) :- p1(A,_,C), p9(C), p12(A,B), p6(B).
p0(A,B) :- p1(A,_,C), p9(C), p3(A,B), p7(B).
p0(A,B) :- p1(A,_,C), p9(C), p3(A,B), p8(B).
p0(A,B) :- p1(A,_,C), p11(C), p3(A,B), p6(B).
p0(A,B) :- p1(A,_,C), p10(C), p3(A,D), p6(D), p7(B).
p0(A,B) :- p1(A,_,C), p11(C), p3(A,D), p7(D), p8(B).
p0(A,B) :- p1(A,_,C), p11(C), p3(A,D), p8(D), p7(B).
p0(A,B) :- p1(A,_,C), p10(C), p3(A,D), p7(D), p6(B).
p0(A,B) :- p1(A,_,C), p10(C), p3(A,B), p8(B).
