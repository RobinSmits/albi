% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
zendo(A):-piece(A,B),piece(A,C),contact(B,C),blue(B),size(B,D),large(D).
zendo(A):-piece(A,B),piece(A,C),blue(B),red(C),coord1(B,D),coord1(C,D).
zendo(A):-piece(A,B),piece(A,C),contact(B,C),rhs(B),size(B,D),large(D).
zendo(A):-piece(A,B),piece(A,C),contact(B,C),red(B),blue(C),size(B,D),large(D).
