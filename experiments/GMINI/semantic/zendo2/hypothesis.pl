% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3.1-pro-preview
zendo(A) :- piece(A, P1), red(P1), piece(A, P2), green(P2), piece(A, P3), blue(P3).
zendo(A) :- piece(A, P1), green(P1), piece(A, P2), P1 \= P2, coord1(P1, C), coord1(P2, C), lhs(P2).
