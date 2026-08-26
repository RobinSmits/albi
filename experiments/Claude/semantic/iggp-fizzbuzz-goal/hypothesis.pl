% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
goal(Ex, Agent, 0) :- true_success(Ex, S), less_than(S, 15), role(Agent).
goal(Ex, Agent, 25) :- true_success(Ex, S), less_than(14, S), less_than(S, 20), role(Agent).
goal(Ex, Agent, 50) :- true_success(Ex, S), less_than(19, S), less_than(S, 26), role(Agent).
goal(Ex, Agent, 75) :- true_success(Ex, S), less_than(25, S), less_than(S, 30), role(Agent).
goal(Ex, Agent, 100) :- true_success(Ex, S), less_than(29, S), role(Agent).
