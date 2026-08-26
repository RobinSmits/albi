%% ============================================================
%% BACKGROUND KNOWLEDGE: Prime Number CLOSED-FORM Formula
%% Target: f(N, P) - P is the N-th prime number
%%
%% CONSTRAINT: Only arithmetic operations provided.
%%   NO recursion helpers, NO primality testing, NO next_prime.
%%   The system MUST compose a formula P = g(N) from arithmetic.
%%
%% Known approximations from number theory:
%%   - Prime Number Theorem: p(n) ~ n * ln(n)
%%   - Better: p(n) ~ n * ln(n) + n * ln(ln(n)) - n
%%   - Cipolla: p(n) ~ n*(ln(n) + ln(ln(n)) - 1 + (ln(ln(n))-2)/ln(n))
%%   - Rosser: p(n) ~ n * ln(n * ln(n))
%%
%% PRECOMPUTED VALUES: All approximations are rounded to nearest int
%% for N = 1..50. The ILP must compose these with arithmetic to match.
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

%% --- Precomputed: floor(N * ln(N)) ---
%% n_ln_n(N, floor(N * ln(N)))
n_ln_n(1,0). n_ln_n(2,1). n_ln_n(3,3). n_ln_n(4,5). n_ln_n(5,8).
n_ln_n(6,10). n_ln_n(7,13). n_ln_n(8,16). n_ln_n(9,19). n_ln_n(10,23).
n_ln_n(11,26). n_ln_n(12,29). n_ln_n(13,33). n_ln_n(14,36). n_ln_n(15,40).
n_ln_n(16,44). n_ln_n(17,48). n_ln_n(18,52). n_ln_n(19,55). n_ln_n(20,59).
n_ln_n(21,63). n_ln_n(22,67). n_ln_n(23,71). n_ln_n(24,76). n_ln_n(25,80).
n_ln_n(26,84). n_ln_n(27,89). n_ln_n(28,93). n_ln_n(29,97). n_ln_n(30,102).

%% --- Precomputed: round(N * (ln(N) + ln(ln(N)))) ---
%% Better upper bound approximation
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

%% --- Precomputed: Cipolla approximation (rounded) ---
%% cipolla(N) ~ N*(ln(N) + ln(ln(N)) - 1 + (ln(ln(N))-2)/ln(N))
cipolla(2,1). cipolla(3,4). cipolla(4,6). cipolla(5,9).
cipolla(6,12). cipolla(7,15). cipolla(8,19). cipolla(9,22). cipolla(10,26).
cipolla(11,30). cipolla(12,34). cipolla(13,38). cipolla(14,42). cipolla(15,46).
cipolla(16,50). cipolla(17,55). cipolla(18,59). cipolla(19,63). cipolla(20,68).
cipolla(21,72). cipolla(22,77). cipolla(23,82). cipolla(24,86). cipolla(25,91).
cipolla(26,96). cipolla(27,101). cipolla(28,106). cipolla(29,111). cipolla(30,116).

%% --- Precomputed: Rosser bound round(N * ln(N * ln(N))) ---
rosser(2,2). rosser(3,5). rosser(4,7). rosser(5,10).
rosser(6,13). rosser(7,17). rosser(8,20). rosser(9,24). rosser(10,28).
rosser(11,32). rosser(12,36). rosser(13,40). rosser(14,44). rosser(15,49).
rosser(16,53). rosser(17,58). rosser(18,62). rosser(19,67). rosser(20,72).
rosser(21,76). rosser(22,81). rosser(23,86). rosser(24,91). rosser(25,96).
rosser(26,101). rosser(27,106). rosser(28,111). rosser(29,117). rosser(30,122).

%% --- Precomputed: floor(ln(N)) ---
ln_floor(1,0). ln_floor(2,0). ln_floor(3,1). ln_floor(4,1). ln_floor(5,1).
ln_floor(6,1). ln_floor(7,1). ln_floor(8,2). ln_floor(9,2). ln_floor(10,2).
ln_floor(11,2). ln_floor(12,2). ln_floor(13,2). ln_floor(14,2). ln_floor(15,2).
ln_floor(16,2). ln_floor(17,2). ln_floor(18,2). ln_floor(19,2). ln_floor(20,2).
ln_floor(21,3). ln_floor(22,3). ln_floor(23,3). ln_floor(24,3). ln_floor(25,3).
ln_floor(26,3). ln_floor(27,3). ln_floor(28,3). ln_floor(29,3). ln_floor(30,3).

%% --- Precomputed: ceil(ln(N)) ---
ln_ceil(1,0). ln_ceil(2,1). ln_ceil(3,2). ln_ceil(4,2). ln_ceil(5,2).
ln_ceil(6,2). ln_ceil(7,2). ln_ceil(8,3). ln_ceil(9,3). ln_ceil(10,3).
ln_ceil(11,3). ln_ceil(12,3). ln_ceil(13,3). ln_ceil(14,3). ln_ceil(15,3).
ln_ceil(16,3). ln_ceil(17,3). ln_ceil(18,3). ln_ceil(19,3). ln_ceil(20,3).
ln_ceil(21,4). ln_ceil(22,4). ln_ceil(23,4). ln_ceil(24,4). ln_ceil(25,4).
ln_ceil(26,4). ln_ceil(27,4). ln_ceil(28,4). ln_ceil(29,4). ln_ceil(30,4).

%% --- Successor (1..150) ---
succ(1,2). succ(2,3). succ(3,4). succ(4,5). succ(5,6). succ(6,7). succ(7,8). succ(8,9). succ(9,10). succ(10,11).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16). succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(21,22). succ(22,23). succ(23,24). succ(24,25). succ(25,26). succ(26,27). succ(27,28). succ(28,29). succ(29,30). succ(30,31).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36). succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46). succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(51,52). succ(52,53). succ(53,54). succ(54,55). succ(55,56). succ(56,57). succ(57,58). succ(58,59). succ(59,60). succ(60,61).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66). succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76). succ(76,77). succ(77,78). succ(78,79). succ(79,80). succ(80,81).
succ(81,82). succ(82,83). succ(83,84). succ(84,85). succ(85,86). succ(86,87). succ(87,88). succ(88,89). succ(89,90). succ(90,91).
succ(91,92). succ(92,93). succ(93,94). succ(94,95). succ(95,96). succ(96,97). succ(97,98). succ(98,99). succ(99,100). succ(100,101).
succ(101,102). succ(102,103). succ(103,104). succ(104,105). succ(105,106). succ(106,107). succ(107,108). succ(108,109). succ(109,110). succ(110,111).
succ(111,112). succ(112,113). succ(113,114). succ(114,115). succ(115,116). succ(116,117). succ(117,118). succ(118,119). succ(119,120). succ(120,121).
succ(121,122). succ(122,123). succ(123,124). succ(124,125). succ(125,126). succ(126,127). succ(127,128). succ(128,129). succ(129,130). succ(130,131).
succ(131,132). succ(132,133). succ(133,134). succ(134,135). succ(135,136). succ(136,137). succ(137,138). succ(138,139). succ(139,140). succ(140,141).
succ(141,142). succ(142,143). succ(143,144). succ(144,145). succ(145,146). succ(146,147). succ(147,148). succ(148,149). succ(149,150).

%% --- Basic Arithmetic (computed) ---
add(X, Y, Z) :- num(X), num(Y), Z is X + Y, Z > 0, num(Z).
sub(X, Y, Z) :- num(X), num(Y), Z is X - Y, Z > 0, num(Z).
mult(X, Y, Z) :- num(X), num(Y), X > 0, Y > 0, Z is X * Y, num(Z).
int_div(X, Y, Z) :- num(X), num(Y), Y > 0, Z is X // Y, Z > 0, num(Z).
modulo(X, Y, Z) :- num(X), num(Y), Y > 0, Z is X mod Y, Z >= 0.

%% --- Multiply by constants ---
double(X, Y) :- num(X), Y is 2 * X, num(Y).
triple(X, Y) :- num(X), Y is 3 * X, num(Y).

%% --- Powers ---
square(X, Y) :- num(X), X > 0, Y is X * X, num(Y).

%% --- Increment/Decrement ---
inc(X, Y) :- num(X), Y is X + 1, num(Y).
dec(X, Y) :- num(X), X > 1, Y is X - 1, num(Y).

%% --- Comparison ---
greater_than(X, Y) :- num(X), num(Y), X > Y.
less_than(X, Y) :- num(X), num(Y), X < Y.

%% --- Constants ---
one(1).
two(2).
three(3).
six(6).

