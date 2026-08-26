% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p1(E, P, V) :- p2(E, P, _), p3(P, P1), p2(E, P1, V).
p1(E, P, V) :- p2(E, P, _), p3(P, P1), p6(E, P1), p6(E, Q1), p3(Q1, Q), p2(E, Q, V).
