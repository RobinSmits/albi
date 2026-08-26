% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
f(A,B) :- tail(A,B), empty(B).
f(A,B) :- append_(C,D,A), append_(C,E,B), f(D,E).
