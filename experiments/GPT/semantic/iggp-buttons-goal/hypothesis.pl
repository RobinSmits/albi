% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
goal(A,B,C) :- role(B), int_0(C), prop_q(Q), not_my_true(A,Q).
goal(A,B,C) :- role(B), int_0(C), prop_r(R), not_my_true(A,R).
goal(A,B,C) :- role(B), int_0(C), prop_p(P), not_my_true(A,P).
goal(A,B,C) :- role(B), int_100(C), prop_p(P), my_true(A,P), prop_q(Q), my_true(A,Q), prop_r(R), my_true(A,R).
