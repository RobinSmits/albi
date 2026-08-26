% Solved by Cascade in 0 iterations
% Time: 0.000s
% Model: claude-opus-4-6
next_score(Ex, Player, Score) :- does(Ex, Player, lay_claim), my_true_score(Ex, Player, OldScore), my_succ(Score, OldScore).
next_score(Ex, Player, Score) :- my_true_score(Ex, Player, Score), does(Ex, Player, noop), does(Ex, Other, lay_claim), opponent(Player, Other).
next_score(Ex, Player, Score) :- my_true_score(Ex, Player, Score), does(Ex, Player, end_game).
