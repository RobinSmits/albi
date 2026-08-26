% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
ancestor(A,B):-mother(A,B).
ancestor(A,B):-father(A,C),mother(C,D),father(D,B).
ancestor(A,B):-mother(A,C),mother(C,D),father(D,B).
