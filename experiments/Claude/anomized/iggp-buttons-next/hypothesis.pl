% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(X, Y) :- p3(X, V), p4(V, Y).
p0(X, Y) :- p1(X, _, C), p10(C), p3(X, V), p6(V), p7(Y).
p0(X, Y) :- p1(X, _, C), \+ p11(C), p3(X, Y), p8(Y).
p0(X, Y) :- p1(X, _, C), p10(C), p3(X, V), p7(V), p6(Y).
p0(X, Y) :- p1(X, _, C), p11(C), p3(X, Y), p6(Y).
p0(X, Y) :- p1(X, _, C), p11(C), p3(X, V), p7(V), p8(Y).
p0(X, Y) :- p1(X, _, C), p11(C), p3(X, V), p8(V), p7(Y).
p0(X, Y) :- p1(X, _, C), p9(C), p12(X, Y), p6(Y).
p0(X, Y) :- p1(X, _, C), p9(C), p3(X, Y), p7(Y).
