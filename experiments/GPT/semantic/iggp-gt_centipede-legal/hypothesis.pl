% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
legal(E,A,continue) :- true_control(E,A).
legal(E,A,finish) :- true_control(E,A).
legal(E,black,noop) :- true_control(E,white).
legal(E,white,noop) :- true_control(E,black).
