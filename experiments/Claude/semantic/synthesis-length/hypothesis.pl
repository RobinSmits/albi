% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
f(A,B) :- tail(A,C), empty(C), one(B).
f(A,B) :- tail(A,C), f(C,D), succ(D,B).
