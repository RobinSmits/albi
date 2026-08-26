% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
f([_,_]).
f([A,B|C]):-geq(B,A),f([B|C]).
