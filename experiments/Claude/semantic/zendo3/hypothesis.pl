% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
zendo(S) :- piece(S, P), piece(S, Q), contact(P, Q), blue(P), size(P, V), large(V).
zendo(S) :- piece(S, P), piece(S, Q), coord1(P, X), coord1(Q, X), blue(P), red(Q).
zendo(S) :- piece(S, P), piece(S, Q), contact(P, Q), red(P), red(Q).
zendo(S) :- piece(S, P), piece(S, Q), contact(P, Q), green(P), green(Q), coord2(P, Y), large(Y).
zendo(S) :- piece(S, P), piece(S, Q), contact(P, Q), size(P, V), large(V), rhs(Q).
