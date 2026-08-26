%% EXAMPLES: prime(X, Y) - Y is the next prime after X
%% Full context mode (~30 pos + ~30 neg)

%% --- Positive Examples ---
pos(prime(2,3)).
pos(prime(3,5)).
pos(prime(5,7)).
pos(prime(7,11)).
pos(prime(11,13)).
pos(prime(13,17)).
pos(prime(17,19)).
pos(prime(19,23)).
pos(prime(23,29)).
pos(prime(29,31)).
pos(prime(31,37)).
pos(prime(37,41)).
pos(prime(41,43)).
pos(prime(43,47)).
pos(prime(47,53)).
pos(prime(53,59)).
pos(prime(59,61)).
pos(prime(61,67)).
pos(prime(67,71)).
pos(prime(71,73)).
pos(prime(73,79)).
pos(prime(79,83)).
pos(prime(83,89)).
pos(prime(89,97)).
pos(prime(97,101)).
pos(prime(101,103)).
pos(prime(103,107)).
pos(prime(107,109)).
pos(prime(109,113)).
pos(prime(113,127)).

%% --- Negative Examples ---
neg(prime(2,4)).
neg(prime(3,4)).
neg(prime(5,6)).
neg(prime(7,8)).
neg(prime(11,12)).
neg(prime(13,14)).
neg(prime(17,18)).
neg(prime(19,20)).
neg(prime(23,24)).
neg(prime(29,30)).
neg(prime(4,5)).
neg(prime(6,7)).
neg(prime(8,11)).
neg(prime(9,11)).
neg(prime(10,11)).
neg(prime(12,13)).
neg(prime(14,17)).
neg(prime(15,17)).
neg(prime(16,17)).
neg(prime(18,19)).
neg(prime(2,5)).
neg(prime(3,7)).
neg(prime(5,11)).
neg(prime(7,13)).
neg(prime(11,17)).
neg(prime(13,19)).
neg(prime(17,23)).
neg(prime(19,29)).
neg(prime(23,31)).
neg(prime(29,37)).
