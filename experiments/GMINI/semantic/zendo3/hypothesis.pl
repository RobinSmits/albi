% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
zendo(A) :- piece(A,B), piece(A,C), B \= C, coord1(B,X), coord1(C,X), blue(B), \+ green(C).
zendo(A) :- piece(A,B), contact(B,C), (rhs(B), size(C,S) ; blue(B), size(B,S), upright(C)), large(S).
