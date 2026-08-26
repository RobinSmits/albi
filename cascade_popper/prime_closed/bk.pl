%% ============================================================
%% BACKGROUND KNOWLEDGE: Nth Prime - ALL LITERATURE KNOWLEDGE
%% Target: f(N, P) - P is the N-th prime number
%%
%% Sources:
%%   [1] Willans (1964) - "On Formulae for the Nth Prime Number"
%%       Wilson's theorem: (p-1)! + 1 ≡ 0 (mod p) iff p is prime
%%       Prime counting: pi(x) = sum_{j=2}^{x} floor(cos^2(pi*((j-1)!+1)/j))
%%
%%   [2] Rosser & Schoenfeld (1962) - "Approximate formulas"
%%       p_n > n * ln(n) for n >= 1
%%       p_n < n * (ln(n) + ln(ln(n))) for n >= 6
%%
%%   [3] Dusart (2010) - Tighter bounds
%%       p_n >= n * (ln(n) + ln(ln(n)) - 1) for n >= 2
%%       p_n <= n * (ln(n) + ln(ln(n)) - 0.9385) for n >= 39017
%%
%%   [4] Cipolla (1902) - Asymptotic expansion
%%       p_n ~ n*(ln(n) + ln(ln(n)) - 1 + (ln(ln(n))-2)/ln(n))
%%
%%   [5] Prime counting function pi(x) = #{p <= x : p prime}
%%       KEY INSIGHT: f(N, P) :- pi(P, N), is_prime(P).
%%       "P is the Nth prime iff there are exactly N primes <= P"
%%
%% ============================================================

%% --- Number Domain (1..200) ---
num(1). num(2). num(3). num(4). num(5). num(6). num(7). num(8). num(9). num(10).
num(11). num(12). num(13). num(14). num(15). num(16). num(17). num(18). num(19). num(20).
num(21). num(22). num(23). num(24). num(25). num(26). num(27). num(28). num(29). num(30).
num(31). num(32). num(33). num(34). num(35). num(36). num(37). num(38). num(39). num(40).
num(41). num(42). num(43). num(44). num(45). num(46). num(47). num(48). num(49). num(50).
num(51). num(52). num(53). num(54). num(55). num(56). num(57). num(58). num(59). num(60).
num(61). num(62). num(63). num(64). num(65). num(66). num(67). num(68). num(69). num(70).
num(71). num(72). num(73). num(74). num(75). num(76). num(77). num(78). num(79). num(80).
num(81). num(82). num(83). num(84). num(85). num(86). num(87). num(88). num(89). num(90).
num(91). num(92). num(93). num(94). num(95). num(96). num(97). num(98). num(99). num(100).
num(101). num(102). num(103). num(104). num(105). num(106). num(107). num(108). num(109). num(110).
num(111). num(112). num(113). num(114). num(115). num(116). num(117). num(118). num(119). num(120).
num(121). num(122). num(123). num(124). num(125). num(126). num(127). num(128). num(129). num(130).
num(131). num(132). num(133). num(134). num(135). num(136). num(137). num(138). num(139). num(140).
num(141). num(142). num(143). num(144). num(145). num(146). num(147). num(148). num(149). num(150).
num(151). num(152). num(153). num(154). num(155). num(156). num(157). num(158). num(159). num(160).
num(161). num(162). num(163). num(164). num(165). num(166). num(167). num(168). num(169). num(170).
num(171). num(172). num(173). num(174). num(175). num(176). num(177). num(178). num(179). num(180).
num(181). num(182). num(183). num(184). num(185). num(186). num(187). num(188). num(189). num(190).
num(191). num(192). num(193). num(194). num(195). num(196). num(197). num(198). num(199). num(200).

%% ============================================================
%% [1] WILSON'S THEOREM: Primality via (p-1)! + 1 mod p = 0
%% wilson_prime(P) holds iff P is prime (by Wilson's theorem)
%% This is the theoretical foundation of Willans' formula
%% ============================================================
wilson_prime(2). wilson_prime(3). wilson_prime(5). wilson_prime(7). wilson_prime(11).
wilson_prime(13). wilson_prime(17). wilson_prime(19). wilson_prime(23). wilson_prime(29).
wilson_prime(31). wilson_prime(37). wilson_prime(41). wilson_prime(43). wilson_prime(47).
wilson_prime(53). wilson_prime(59). wilson_prime(61). wilson_prime(67). wilson_prime(71).
wilson_prime(73). wilson_prime(79). wilson_prime(83). wilson_prime(89). wilson_prime(97).
wilson_prime(101). wilson_prime(103). wilson_prime(107). wilson_prime(109). wilson_prime(113).
wilson_prime(127). wilson_prime(131). wilson_prime(137). wilson_prime(139). wilson_prime(149).
wilson_prime(151). wilson_prime(157). wilson_prime(163). wilson_prime(167). wilson_prime(173).
wilson_prime(179). wilson_prime(181). wilson_prime(191). wilson_prime(193). wilson_prime(197).
wilson_prime(199).

%% ============================================================
%% [1] is_prime/1 - Same set, standard name
%% ============================================================
is_prime(2). is_prime(3). is_prime(5). is_prime(7). is_prime(11).
is_prime(13). is_prime(17). is_prime(19). is_prime(23). is_prime(29).
is_prime(31). is_prime(37). is_prime(41). is_prime(43). is_prime(47).
is_prime(53). is_prime(59). is_prime(61). is_prime(67). is_prime(71).
is_prime(73). is_prime(79). is_prime(83). is_prime(89). is_prime(97).
is_prime(101). is_prime(103). is_prime(107). is_prime(109). is_prime(113).
is_prime(127). is_prime(131). is_prime(137). is_prime(139). is_prime(149).
is_prime(151). is_prime(157). is_prime(163). is_prime(167). is_prime(173).
is_prime(179). is_prime(181). is_prime(191). is_prime(193). is_prime(197).
is_prime(199).

%% not_prime(N) - complement
not_prime(N) :- num(N), N > 1, \+ is_prime(N).

%% ============================================================
%% [5] PRIME COUNTING FUNCTION pi(X, C)
%% pi(X, C) means: there are exactly C primes <= X
%% This is the KEY to Willans' approach.
%% INVERSE: if pi(P, N) and is_prime(P), then P is the Nth prime.
%% ============================================================
pi(1,0).
pi(2,1). pi(3,2). pi(4,2). pi(5,3). pi(6,3). pi(7,4). pi(8,4). pi(9,4). pi(10,4).
pi(11,5). pi(12,5). pi(13,6). pi(14,6). pi(15,6). pi(16,6). pi(17,7). pi(18,7). pi(19,8). pi(20,8).
pi(21,8). pi(22,8). pi(23,9). pi(24,9). pi(25,9). pi(26,9). pi(27,9). pi(28,9). pi(29,10). pi(30,10).
pi(31,11). pi(32,11). pi(33,11). pi(34,11). pi(35,11). pi(36,11). pi(37,12). pi(38,12). pi(39,12). pi(40,12).
pi(41,13). pi(42,13). pi(43,14). pi(44,14). pi(45,14). pi(46,14). pi(47,15). pi(48,15). pi(49,15). pi(50,15).
pi(51,15). pi(52,15). pi(53,16). pi(54,16). pi(55,16). pi(56,16). pi(57,16). pi(58,16). pi(59,17). pi(60,17).
pi(61,18). pi(62,18). pi(63,18). pi(64,18). pi(65,18). pi(66,18). pi(67,19). pi(68,19). pi(69,19). pi(70,19).
pi(71,20). pi(72,20). pi(73,21). pi(74,21). pi(75,21). pi(76,21). pi(77,21). pi(78,21). pi(79,22). pi(80,22).
pi(81,22). pi(82,22). pi(83,23). pi(84,23). pi(85,23). pi(86,23). pi(87,23). pi(88,23). pi(89,24). pi(90,24).
pi(91,24). pi(92,24). pi(93,24). pi(94,24). pi(95,24). pi(96,24). pi(97,25). pi(98,25). pi(99,25). pi(100,25).
pi(101,26). pi(102,26). pi(103,27). pi(104,27). pi(105,27). pi(106,27). pi(107,28). pi(108,28). pi(109,29). pi(110,29).
pi(111,29). pi(112,29). pi(113,30). pi(114,30). pi(115,30). pi(116,30). pi(117,30). pi(118,30). pi(119,30). pi(120,30).
pi(121,30). pi(122,30). pi(123,30). pi(124,30). pi(125,30). pi(126,30). pi(127,31). pi(128,31). pi(129,31). pi(130,31).
pi(131,32). pi(132,32). pi(133,32). pi(134,32). pi(135,32). pi(136,32). pi(137,33). pi(138,33). pi(139,34). pi(140,34).
pi(141,34). pi(142,34). pi(143,34). pi(144,34). pi(145,34). pi(146,34). pi(147,34). pi(148,34). pi(149,35). pi(150,35).
pi(151,36). pi(152,36). pi(153,36). pi(154,36). pi(155,36). pi(156,36). pi(157,37). pi(158,37). pi(159,37). pi(160,37).
pi(161,37). pi(162,37). pi(163,38). pi(164,38). pi(165,38). pi(166,38). pi(167,39). pi(168,39). pi(169,39). pi(170,39).
pi(171,39). pi(172,39). pi(173,40). pi(174,40). pi(175,40). pi(176,40). pi(177,40). pi(178,40). pi(179,41). pi(180,41).
pi(181,42). pi(182,42). pi(183,42). pi(184,42). pi(185,42). pi(186,42). pi(187,42). pi(188,42). pi(189,42). pi(190,42).
pi(191,43). pi(192,43). pi(193,44). pi(194,44). pi(195,44). pi(196,44). pi(197,45). pi(198,45). pi(199,46). pi(200,46).

%% --- Approximate pi: pi_approx(N, C) ~ N/ln(N) rounded ---
pi_approx(5,3). pi_approx(10,4). pi_approx(20,7). pi_approx(30,9).
pi_approx(40,11). pi_approx(50,13). pi_approx(60,14). pi_approx(70,16).
pi_approx(80,18). pi_approx(90,19). pi_approx(100,22). pi_approx(120,24).
pi_approx(150,28). pi_approx(200,35).

%% ============================================================
%% PRIME NAVIGATION
%% ============================================================

%% next_prime(X, P) - P is the smallest prime > X
next_prime(1,2). next_prime(2,3). next_prime(3,5). next_prime(4,5).
next_prime(5,7). next_prime(6,7). next_prime(7,11). next_prime(8,11).
next_prime(9,11). next_prime(10,11). next_prime(11,13). next_prime(12,13).
next_prime(13,17). next_prime(14,17). next_prime(15,17). next_prime(16,17).
next_prime(17,19). next_prime(18,19). next_prime(19,23). next_prime(20,23).
next_prime(21,23). next_prime(22,23). next_prime(23,29). next_prime(24,29).
next_prime(25,29). next_prime(26,29). next_prime(27,29). next_prime(28,29).
next_prime(29,31). next_prime(30,31). next_prime(31,37). next_prime(32,37).
next_prime(33,37). next_prime(34,37). next_prime(35,37). next_prime(36,37).
next_prime(37,41). next_prime(38,41). next_prime(39,41). next_prime(40,41).
next_prime(41,43). next_prime(42,43). next_prime(43,47). next_prime(44,47).
next_prime(45,47). next_prime(46,47). next_prime(47,53). next_prime(48,53).
next_prime(49,53). next_prime(50,53). next_prime(51,53). next_prime(52,53).
next_prime(53,59). next_prime(54,59). next_prime(55,59). next_prime(56,59).
next_prime(57,59). next_prime(58,59). next_prime(59,61). next_prime(60,61).
next_prime(61,67). next_prime(62,67). next_prime(63,67). next_prime(64,67).
next_prime(65,67). next_prime(66,67). next_prime(67,71). next_prime(68,71).
next_prime(69,71). next_prime(70,71). next_prime(71,73). next_prime(72,73).
next_prime(73,79). next_prime(74,79). next_prime(75,79). next_prime(76,79).
next_prime(77,79). next_prime(78,79). next_prime(79,83). next_prime(80,83).
next_prime(81,83). next_prime(82,83). next_prime(83,89). next_prime(84,89).
next_prime(85,89). next_prime(86,89). next_prime(87,89). next_prime(88,89).
next_prime(89,97). next_prime(90,97). next_prime(91,97). next_prime(92,97).
next_prime(93,97). next_prime(94,97). next_prime(95,97). next_prime(96,97).
next_prime(97,101). next_prime(98,101). next_prime(99,101). next_prime(100,101).
next_prime(101,103). next_prime(102,103). next_prime(103,107). next_prime(104,107).
next_prime(105,107). next_prime(106,107). next_prime(107,109). next_prime(108,109).
next_prime(109,113). next_prime(110,113). next_prime(111,113). next_prime(112,113).

%% prev_prime(X, P) - P is the largest prime < X
prev_prime(4,3). prev_prime(5,3). prev_prime(6,5). prev_prime(7,5).
prev_prime(8,7). prev_prime(9,7). prev_prime(10,7). prev_prime(11,7).
prev_prime(12,11). prev_prime(13,11). prev_prime(14,13). prev_prime(15,13).
prev_prime(16,13). prev_prime(17,13). prev_prime(18,17). prev_prime(19,17).
prev_prime(20,19). prev_prime(21,19). prev_prime(22,19). prev_prime(23,19).
prev_prime(24,23). prev_prime(25,23). prev_prime(26,23). prev_prime(27,23).
prev_prime(28,23). prev_prime(29,23). prev_prime(30,29). prev_prime(31,29).

%% prime_at_or_after(X, P) - P is the smallest prime >= X
prime_at_or_after(X, P) :- num(X), is_prime(X), P = X.
prime_at_or_after(X, P) :- num(X), \+ is_prime(X), next_prime(X, P).

%% ============================================================
%% DIVISIBILITY
%% ============================================================
divisible(X, Y) :- num(X), num(Y), Y > 0, 0 is X mod Y.
not_divisible(X, Y) :- num(X), num(Y), Y > 0, R is X mod Y, R > 0.

%% has_factor(N, D) - N is divisible by D, where 2 <= D, D*D <= N
has_factor(N, D) :- num(N), num(D), D >= 2, D*D =< N, 0 is N mod D.

%% no_small_factor(N) - N > 1 and has no factor from 2..sqrt(N)
no_small_factor(N) :- num(N), N > 1, \+ (num(D), D >= 2, D*D =< N, 0 is N mod D).

%% ============================================================
%% [2] ROSSER & SCHOENFELD BOUNDS (1962)
%% rosser(N, X) where X = round(N * ln(N * ln(N)))
%% ============================================================
rosser(1,1). rosser(2,2). rosser(3,5). rosser(4,7). rosser(5,10).
rosser(6,13). rosser(7,17). rosser(8,20). rosser(9,24). rosser(10,28).
rosser(11,32). rosser(12,36). rosser(13,40). rosser(14,44). rosser(15,49).
rosser(16,53). rosser(17,58). rosser(18,62). rosser(19,67). rosser(20,72).
rosser(21,76). rosser(22,81). rosser(23,86). rosser(24,91). rosser(25,96).
rosser(26,101). rosser(27,106). rosser(28,111). rosser(29,117). rosser(30,122).

%% ============================================================
%% [3] DUSART BOUNDS (2010) - Tighter than Rosser
%% dusart_lower(N, L): p_n >= L = round(N*(ln(N) + ln(ln(N)) - 1))
%% dusart_upper(N, U): p_n <= U = round(N*(ln(N) + ln(ln(N)) - 0.9385))
%% ============================================================
dusart_lower(2,1). dusart_lower(3,2). dusart_lower(4,4). dusart_lower(5,7).
dusart_lower(6,10). dusart_lower(7,13). dusart_lower(8,17). dusart_lower(9,20).
dusart_lower(10,24). dusart_lower(11,28). dusart_lower(12,33). dusart_lower(13,37).
dusart_lower(14,41). dusart_lower(15,46). dusart_lower(16,50). dusart_lower(17,55).
dusart_lower(18,60). dusart_lower(19,65). dusart_lower(20,70). dusart_lower(21,75).
dusart_lower(22,80). dusart_lower(23,85). dusart_lower(24,90). dusart_lower(25,96).
dusart_lower(26,101). dusart_lower(27,107). dusart_lower(28,112). dusart_lower(29,118).
dusart_lower(30,123).

dusart_upper(2,3). dusart_upper(3,5). dusart_upper(4,8). dusart_upper(5,11).
dusart_upper(6,15). dusart_upper(7,19). dusart_upper(8,23). dusart_upper(9,27).
dusart_upper(10,32). dusart_upper(11,36). dusart_upper(12,41). dusart_upper(13,46).
dusart_upper(14,51). dusart_upper(15,56). dusart_upper(16,62). dusart_upper(17,67).
dusart_upper(18,72). dusart_upper(19,78). dusart_upper(20,83). dusart_upper(21,89).
dusart_upper(22,95). dusart_upper(23,100). dusart_upper(24,106). dusart_upper(25,112).
dusart_upper(26,118). dusart_upper(27,124). dusart_upper(28,130). dusart_upper(29,136).
dusart_upper(30,142).

%% ============================================================
%% [4] CIPOLLA APPROXIMATION (1902)
%% cipolla(N, X) ~ round(N*(ln(N) + ln(ln(N)) - 1 + (ln(ln(N))-2)/ln(N)))
%% ============================================================
cipolla(2,1). cipolla(3,4). cipolla(4,6). cipolla(5,9).
cipolla(6,12). cipolla(7,15). cipolla(8,19). cipolla(9,22). cipolla(10,26).
cipolla(11,30). cipolla(12,34). cipolla(13,38). cipolla(14,42). cipolla(15,46).
cipolla(16,50). cipolla(17,55). cipolla(18,59). cipolla(19,63). cipolla(20,68).
cipolla(21,72). cipolla(22,77). cipolla(23,82). cipolla(24,86). cipolla(25,91).
cipolla(26,96). cipolla(27,101). cipolla(28,106). cipolla(29,111). cipolla(30,116).

%% ============================================================
%% SIMPLE APPROXIMATIONS
%% ============================================================

%% n_ln_n(N, X) = round(N * ln(N))
n_ln_n(1,0). n_ln_n(2,1). n_ln_n(3,3). n_ln_n(4,5). n_ln_n(5,8).
n_ln_n(6,10). n_ln_n(7,13). n_ln_n(8,16). n_ln_n(9,19). n_ln_n(10,23).
n_ln_n(11,26). n_ln_n(12,29). n_ln_n(13,33). n_ln_n(14,36). n_ln_n(15,40).
n_ln_n(16,44). n_ln_n(17,48). n_ln_n(18,52). n_ln_n(19,55). n_ln_n(20,59).
n_ln_n(21,63). n_ln_n(22,67). n_ln_n(23,71). n_ln_n(24,76). n_ln_n(25,80).
n_ln_n(26,84). n_ln_n(27,89). n_ln_n(28,93). n_ln_n(29,97). n_ln_n(30,102).

%% n_ln_n_ln_ln_n(N, X) = round(N * (ln(N) + ln(ln(N))))
n_ln_n_ln_ln_n(2,2). n_ln_n_ln_ln_n(3,4). n_ln_n_ln_ln_n(4,7).
n_ln_n_ln_ln_n(5,11). n_ln_n_ln_ln_n(6,14). n_ln_n_ln_ln_n(7,18).
n_ln_n_ln_ln_n(8,22). n_ln_n_ln_ln_n(9,26). n_ln_n_ln_ln_n(10,30).
n_ln_n_ln_ln_n(11,35). n_ln_n_ln_ln_n(12,39). n_ln_n_ln_ln_n(13,44).
n_ln_n_ln_ln_n(14,49). n_ln_n_ln_ln_n(15,53). n_ln_n_ln_ln_n(16,58).
n_ln_n_ln_ln_n(17,63). n_ln_n_ln_ln_n(18,68). n_ln_n_ln_ln_n(19,73).
n_ln_n_ln_ln_n(20,78). n_ln_n_ln_ln_n(21,83). n_ln_n_ln_ln_n(22,89).
n_ln_n_ln_ln_n(23,94). n_ln_n_ln_ln_n(24,99). n_ln_n_ln_ln_n(25,105).
n_ln_n_ln_ln_n(26,110). n_ln_n_ln_ln_n(27,116). n_ln_n_ln_ln_n(28,121).
n_ln_n_ln_ln_n(29,127). n_ln_n_ln_ln_n(30,133).

%% ============================================================
%% SUCCESSOR / PREDECESSOR
%% ============================================================
succ(0,1). succ(1,2). succ(2,3). succ(3,4). succ(4,5). succ(5,6). succ(6,7). succ(7,8). succ(8,9). succ(9,10).
succ(10,11). succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16). succ(16,17). succ(17,18). succ(18,19). succ(19,20).
succ(20,21). succ(21,22). succ(22,23). succ(23,24). succ(24,25). succ(25,26). succ(26,27). succ(27,28). succ(28,29). succ(29,30).
succ(30,31). succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36). succ(36,37). succ(37,38). succ(38,39). succ(39,40).
succ(40,41). succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46). succ(46,47). succ(47,48). succ(48,49). succ(49,50).

prec(2,1). prec(3,2). prec(4,3). prec(5,4). prec(6,5). prec(7,6). prec(8,7). prec(9,8). prec(10,9).
prec(11,10). prec(12,11). prec(13,12). prec(14,13). prec(15,14). prec(16,15). prec(17,16). prec(18,17). prec(19,18). prec(20,19).
prec(21,20). prec(22,21). prec(23,22). prec(24,23). prec(25,24). prec(26,25). prec(27,26). prec(28,27). prec(29,28). prec(30,29).

%% ============================================================
%% BASIC ARITHMETIC
%% ============================================================
add(X, Y, Z) :- num(X), num(Y), Z is X + Y, Z > 0, num(Z).
sub(X, Y, Z) :- num(X), num(Y), Z is X - Y, Z > 0, num(Z).
mult(X, Y, Z) :- num(X), num(Y), X > 0, Y > 0, Z is X * Y, num(Z).
int_div(X, Y, Z) :- num(X), num(Y), Y > 0, Z is X // Y, Z > 0, num(Z).
modulo(X, Y, Z) :- num(X), num(Y), Y > 0, Z is X mod Y, Z >= 0.

inc(X, Y) :- num(X), Y is X + 1, num(Y).
dec(X, Y) :- num(X), X > 1, Y is X - 1, num(Y).
double(X, Y) :- num(X), Y is 2 * X, num(Y).
square(X, Y) :- num(X), X > 0, Y is X * X, num(Y).

%% ============================================================
%% COMPARISON
%% ============================================================
greater_than(X, Y) :- num(X), num(Y), X > Y.
less_than(X, Y) :- num(X), num(Y), X < Y.
geq(X, Y) :- num(X), num(Y), X >= Y.
leq(X, Y) :- num(X), num(Y), X =< Y.

%% ============================================================
%% CONSTANTS
%% ============================================================
zero(0).
one(1).
two(2).
three(3).
six(6).

