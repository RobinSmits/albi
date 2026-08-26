% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p1(X, C, 0) :- p4(X, C), p2(X, A), p3(X, B), \+ p6(B, A).
p1(X, C, 0) :- p5(C), \+ p4(X, C), p2(X, A), p3(X, B), \+ p6(B, A), \+ p2(X, 0).
p1(X, C, 0) :- p4(X, C), p2(X, A), p3(X, B), p6(B, A), p2(Y, B), \+ p4(Y, C).
p1(X, C, 0) :- p5(C), \+ p4(X, C), p2(X, A), p3(X, B), p6(B, A), p2(Y, B), p4(Y, C), p3(Z, A), p4(Z, C).
p1(X, C, D) :- p4(X, C), p2(X, A), p3(X, D), p6(D, A), p2(Y, D), p4(Y, C).
p1(X, C, D) :- p5(C), \+ p4(X, C), p3(X, D), p4(Y, C), p2(Y, D), p3(Y, E), p6(E, D), p6(D, F), p2(Z, F), p4(Z, C).
p1(X, C, 0) :- p5(C), p4(X, E), p2(X, 0), p3(X, B), p4(Z, E), p2(Z, B), p6(B, F), p4(W, E), p2(W, F).
p1(X, C, D) :- p5(C), \+ p4(X, C), p2(X, D), p3(X, B), p6(B, D), p2(Y, D), p4(Y, C), p6(D, G), p2(V, G), \+ p4(V, C).
p1(X, C, 0) :- p3(X, 0), p2(X, A), p6(0, A), p6(A, B), p4(W, C), p2(W, B).
