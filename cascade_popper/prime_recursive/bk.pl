%% ============================================================
%% BACKGROUND KNOWLEDGE: Nth Prime - UNRESTRICTED
%% Target: f(N, P) - P is the N-th prime number
%%
%% RICH BK: Recursion allowed, primality testing provided.
%% Provides is_prime/1, next_prime/2, and all arithmetic.
%%
%% Expected learnable hypothesis:
%%   f(1, 2).
%%   f(N, P) :- prec(N, N1), f(N1, Q), next_prime(Q, P).
%% Or:
%%   f(1, 2).
%%   f(N, P) :- dec(N, N1), f(N1, Q), next_prime(Q, P).
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
%% PRIMALITY TESTING (precomputed facts for all primes up to 200)
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

%% ============================================================
%% NEXT PRIME: next_prime(P, Q) - Q is the smallest prime > P
%% ============================================================
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

%% ============================================================
%% PRIME BETWEEN: prime_between(Low, High, P) - P is a prime, Low < P =< High
%% Useful if ILP wants to find a prime in a range
%% ============================================================
prime_between(L, H, P) :- num(P), is_prime(P), P > L, P =< H.

%% ============================================================
%% SUCCESSOR / PREDECESSOR
%% ============================================================
succ(1,2). succ(2,3). succ(3,4). succ(4,5). succ(5,6). succ(6,7). succ(7,8). succ(8,9). succ(9,10). succ(10,11).
succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16). succ(16,17). succ(17,18). succ(18,19). succ(19,20). succ(20,21).
succ(21,22). succ(22,23). succ(23,24). succ(24,25). succ(25,26). succ(26,27). succ(27,28). succ(28,29). succ(29,30). succ(30,31).
succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36). succ(36,37). succ(37,38). succ(38,39). succ(39,40). succ(40,41).
succ(41,42). succ(42,43). succ(43,44). succ(44,45). succ(45,46). succ(46,47). succ(47,48). succ(48,49). succ(49,50). succ(50,51).
succ(51,52). succ(52,53). succ(53,54). succ(54,55). succ(55,56). succ(56,57). succ(57,58). succ(58,59). succ(59,60). succ(60,61).
succ(61,62). succ(62,63). succ(63,64). succ(64,65). succ(65,66). succ(66,67). succ(67,68). succ(68,69). succ(69,70). succ(70,71).
succ(71,72). succ(72,73). succ(73,74). succ(74,75). succ(75,76). succ(76,77). succ(77,78). succ(78,79). succ(79,80). succ(80,81).

prec(2,1). prec(3,2). prec(4,3). prec(5,4). prec(6,5). prec(7,6). prec(8,7). prec(9,8). prec(10,9). prec(11,10).
prec(12,11). prec(13,12). prec(14,13). prec(15,14). prec(16,15). prec(17,16). prec(18,17). prec(19,18). prec(20,19). prec(21,20).
prec(22,21). prec(23,22). prec(24,23). prec(25,24). prec(26,25). prec(27,26). prec(28,27). prec(29,28). prec(30,29). prec(31,30).
prec(32,31). prec(33,32). prec(34,33). prec(35,34). prec(36,35). prec(37,36). prec(38,37). prec(39,38). prec(40,39). prec(41,40).

%% ============================================================
%% BASIC ARITHMETIC
%% ============================================================
add(X, Y, Z) :- num(X), num(Y), Z is X + Y, Z > 0, num(Z).
sub(X, Y, Z) :- num(X), num(Y), Z is X - Y, Z > 0, num(Z).
modulo(X, Y, Z) :- num(X), num(Y), Y > 0, Z is X mod Y, Z >= 0.

inc(X, Y) :- num(X), Y is X + 1, num(Y).
dec(X, Y) :- num(X), X > 1, Y is X - 1, num(Y).
double(X, Y) :- num(X), Y is 2 * X, num(Y).

%% ============================================================
%% COMPARISON
%% ============================================================
greater_than(X, Y) :- num(X), num(Y), X > Y.
less_than(X, Y) :- num(X), num(Y), X < Y.
geq(X, Y) :- num(X), num(Y), X >= Y.

%% ============================================================
%% CONSTANTS
%% ============================================================
zero(0).
one(1).
two(2).

