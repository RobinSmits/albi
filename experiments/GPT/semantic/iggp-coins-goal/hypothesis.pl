% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: gpt-5.4-pro
goal(A,B,C):-role(B),score_0(C),my_true_cell(A,_,D),c_onecoin(D).
goal(A,B,C):-role(B),score_100(C),my_true_step(A,D),pos_5(D).
