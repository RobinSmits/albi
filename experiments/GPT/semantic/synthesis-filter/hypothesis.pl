% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
f([],[]).
f([A|B],C):-odd(A),f(B,C).
f([A|B],[A|C]):-even(A),f(B,C).
