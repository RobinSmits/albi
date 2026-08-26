% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
p0(A, B) :- p3(A, C), p4(C, B).
p0(A, B) :- p1(A, C, D), p2(C, D), p10(D), p3(A, E), p6(E), p7(B).
p0(A, B) :- p3(A, B), p6(B), p1(A, _, D), p11(D).
p0(A, B) :- p3(A, B), p7(B), p1(A, _, D), p9(D).
p0(A, B) :- p1(A, _, D), p11(D), p3(A, E), p7(E), p8(B).
p0(A, B) :- p1(A, _, C), p9(C), p12(A, B), p6(B).
p0(A, B) :- p1(A, _, D), p11(D), p7(B), p3(A, E), p8(E).
p0(A, B) :- p6(B), p3(A, C), p7(C), p1(A, _, D), p10(D).
p0(A, B) :- p3(A, B), p8(B), p1(A, _, C), p10(C).
p0(A, B) :- p3(A, B), p8(B), p1(A, _, C), p9(C).
