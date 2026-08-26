% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
f(A):-head(A,6).
f(A):-head(A,9).
f(A):-tail(A,B),f(B).
