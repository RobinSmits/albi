% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
goal(E,A,0) :- role(A), true_count(E,C), less_than(C,31).
goal(E,A,0) :- role(A), true_count(E,31), true_success(E,S), less_than(S,15).
goal(E,A,25) :- role(A), true_count(E,31), true_success(E,S), less_than(14,S), less_than(S,20).
goal(E,A,50) :- role(A), true_count(E,31), true_success(E,S), less_than(19,S), succ(24,T), less_than(S,T).
goal(E,A,100) :- role(A), true_count(E,31), true_success(E,S), less_than(29,S).
goal(E,A,75) :- role(A), true_count(E,31), true_success(E,S), less_than(24,S), less_than(S,30).
