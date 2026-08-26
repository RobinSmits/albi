% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A,B) :- empty(A), zero(B).
f(A,B) :- tail(A,C), f(C,D), succ(D,B).
