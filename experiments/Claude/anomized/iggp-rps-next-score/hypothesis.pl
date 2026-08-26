% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(X, Y, Z) :- p1(X, Y, Z), p3(X, Y, V), p6(Y, Y2), p3(X, Y2, V).
p0(X, Y, Z) :- p1(X, Y, A), p2(A, Z), p3(X, Y, V), p6(Y, Y2), p3(X, Y2, W), p4(V, W).
p0(X, Y, Z) :- p1(X, Y, Z), p3(X, Y, V), p6(Y, Y2), p3(X, Y2, W), p4(W, V).
