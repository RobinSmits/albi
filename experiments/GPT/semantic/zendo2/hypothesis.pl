% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
zendo(A) :- piece(A,B), lhs(B), coord1(B,X), piece(A,C), green(C), coord1(C,X).
zendo(A) :- piece(A,B), blue(B), piece(A,C), red(C), piece(A,D), green(D).
