% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
goal(E,A,0) :- role(A), true_control(E,black), true_blackPayoff(E,B), true_whitePayoff(E,W), succ(W,X), succ(X,Y), succ(Y,B).
goal(E,A,0) :- role(A), true_control(E,white), true_blackPayoff(E,B), true_whitePayoff(E,W), succ(B,W).
goal(E,black,B) :- true_control(E,white), true_blackPayoff(E,B), true_whitePayoff(E,W), succ(W,X), succ(X,Y), succ(Y,B).
goal(E,white,W) :- true_control(E,white), true_blackPayoff(E,B), true_whitePayoff(E,W), succ(W,X), succ(X,Y), succ(Y,B).
goal(E,black,B) :- true_control(E,black), true_blackPayoff(E,B), true_whitePayoff(E,W), succ(B,W).
goal(E,white,W) :- true_control(E,black), true_blackPayoff(E,B), true_whitePayoff(E,W), succ(B,W).
