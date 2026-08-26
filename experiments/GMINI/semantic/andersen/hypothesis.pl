% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
pt(A,B) :- addr(A,B).
pt(A,B) :- assgn(A,C), pt(C,B).
pt(A,B) :- load(A,C), pt(C,D), pt(D,B).
pt(A,B) :- store(C,D), pt(C,A), pt(D,B).
