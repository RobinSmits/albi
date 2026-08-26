% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
zendo(A) :- piece(A,B), green(B), piece(A,C), red(C), piece(A,D), blue(D).
zendo(A) :- piece(A,B), green(B), lhs(B).
zendo(A) :- piece(A,B), green(B), strange(B), size(B,S), large(S), piece(A,C), lhs(C), size(C,T), \+ large(T).
zendo(A) :- piece(A,B), green(B), size(B,S), large(S), coord2(B,Y), small(Y), piece(A,C), lhs(C), size(C,T), \+ large(T).
zendo(A) :- piece(A,B), green(B), rhs(B), piece(A,C), blue(C), lhs(C), size(C,T), small(T).
