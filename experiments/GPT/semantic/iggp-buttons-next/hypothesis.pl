% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
next(E,Y) :- my_true(E,X), my_succ(X,Y).
next(E,P) :- does(E,_,Act), c_a(Act), c_p(P), not_my_true(E,P).
next(E,Q) :- does(E,_,Act), c_a(Act), c_q(Q), my_true(E,Q).
next(E,T) :- does(E,_,Act), c_a(Act), c_r(T), my_true(E,T).
next(E,P) :- does(E,_,Act), c_c(Act), c_p(P), my_true(E,P).
next(E,Q) :- does(E,_,Act), c_b(Act), c_q(Q), my_true(E,P), c_p(P).
next(E,T) :- does(E,_,Act), c_c(Act), c_r(T), my_true(E,Q), c_q(Q).
next(E,Q) :- does(E,_,Act), c_c(Act), c_q(Q), my_true(E,R), c_r(R).
next(E,P) :- does(E,_,Act), c_b(Act), c_p(P), my_true(E,Q), c_q(Q).
next(E,T) :- does(E,_,Act), c_b(Act), c_r(T), my_true(E,T).
