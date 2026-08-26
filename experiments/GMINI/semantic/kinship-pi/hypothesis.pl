% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gemini-3-pro-preview
grandparent(A, B) :- mother(A, C), father(C, B).
grandparent(A, B) :- mother(A, C), mother(C, B).
grandparent(A, B) :- father(A, C), mother(C, B).
grandparent(A, B) :- father(A, C), father(C, B).
