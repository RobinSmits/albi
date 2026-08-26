% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
p0(A, B) :- p2(A, B), p3(B).
p0(A, B) :- p1(A, H), p2(A, T), p0(T, R), p8(H, R, B).
