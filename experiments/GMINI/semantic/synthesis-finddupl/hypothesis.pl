% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A,B) :- head(A,B), tail(A,C), element(C,B).
f(A,B) :- tail(A,C), f(C,B).
