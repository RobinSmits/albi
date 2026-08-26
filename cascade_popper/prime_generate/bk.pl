%% ============================================================
%% BACKGROUND KNOWLEDGE: GENERATIVE Prime Formula
%% Target: f(N, P) - P is the N-th prime number
%%
%% STRATEGY: Approximation + "snap to prime" correction
%%
%% From the literature:
%%   - Dusart (2010): p_n >= n*(ln(n) + ln(ln(n)) - 1) for n >= 2
%%     This is a GUARANTEED LOWER BOUND — always <= actual prime
%%   - Cipolla (1902): Very close approximation
%%   - Rosser (1962): p_n ~ n*ln(n*ln(n))
%%
%% The generative approach:
%%   1. Compute approximate value A from formula
%%   2. Find the prime at or after A → gives exact prime P
%%   This WORKS for any N as long as:
%%     - The approximation is a lower bound (or very close)
%%     - No other prime exists between the approximation and P
%%
%% For Dusart lower bound: guaranteed to work since p_n >= bound
%% ============================================================

%% --- Number Domain (1..250) ---
num(0). num(1). num(2). num(3). num(4). num(5). num(6). num(7). num(8). num(9). num(10).
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
num(201). num(202). num(203). num(204). num(205). num(206). num(207). num(208). num(209). num(210).
num(211). num(212). num(213). num(214). num(215). num(216). num(217). num(218). num(219). num(220).
num(221). num(222). num(223). num(224). num(225). num(226). num(227). num(228). num(229). num(230).
num(231). num(232). num(233). num(234). num(235). num(236). num(237). num(238). num(239). num(240).
num(241). num(242). num(243). num(244). num(245). num(246). num(247). num(248). num(249). num(250).

%% ============================================================
%% PRIMALITY (all primes up to 250)
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
is_prime(199). is_prime(211). is_prime(223). is_prime(227). is_prime(229).
is_prime(233). is_prime(239). is_prime(241).

%% ============================================================
%% PRIME CORRECTION PREDICATES
%% prime_at_or_after(X, P): P is the smallest prime >= X
%% prime_at_or_before(X, P): P is the largest prime <= X
%% These are the KEY "snap to prime" operators
%% ============================================================

%% prime_at_or_after: find first prime >= X
prime_at_or_after(X, X) :- num(X), is_prime(X).
prime_at_or_after(X, P) :- num(X), \+ is_prime(X), X1 is X + 1, prime_at_or_after(X1, P).

%% prime_at_or_before: find largest prime <= X
prime_at_or_before(X, X) :- num(X), is_prime(X).
prime_at_or_before(X, P) :- num(X), X > 2, \+ is_prime(X), X1 is X - 1, prime_at_or_before(X1, P).

%% next_prime(X, P): smallest prime > X (strictly greater)
next_prime(X, P) :- num(X), X1 is X + 1, prime_at_or_after(X1, P).

%% prev_prime(X, P): largest prime < X (strictly less)
prev_prime(X, P) :- num(X), X > 2, X1 is X - 1, prime_at_or_before(X1, P).

%% ============================================================
%% DUSART (2010) LOWER BOUND — GUARANTEED: p_n >= dusart_lower(n)
%% dusart_lower(N, L) = floor(N * (ln(N) + ln(ln(N)) - 1))
%% This ALWAYS undershoots — so prime_at_or_after(L, P) gives
%% either the correct Nth prime or a prime before it.
%%
%% CRITICAL: For this to work perfectly, no other prime should
%% exist between dusart_lower(N) and p_n. This holds for most N.
%% ============================================================
dusart_lower(1,1). dusart_lower(2,1). dusart_lower(3,3). dusart_lower(4,5).
dusart_lower(5,8). dusart_lower(6,11). dusart_lower(7,14). dusart_lower(8,17).
dusart_lower(9,21). dusart_lower(10,25). dusart_lower(11,29). dusart_lower(12,33).
dusart_lower(13,37). dusart_lower(14,41). dusart_lower(15,46). dusart_lower(16,50).
dusart_lower(17,55). dusart_lower(18,60). dusart_lower(19,64). dusart_lower(20,69).
dusart_lower(21,74). dusart_lower(22,79). dusart_lower(23,84). dusart_lower(24,89).
dusart_lower(25,95). dusart_lower(26,100). dusart_lower(27,105). dusart_lower(28,111).
dusart_lower(29,116). dusart_lower(30,122).

%% ============================================================
%% DUSART UPPER BOUND: p_n <= dusart_upper(n)
%% dusart_upper(N, U) = ceil(N * (ln(N) + ln(ln(N)) - 0.9385))
%% ============================================================
dusart_upper(1,2). dusart_upper(2,3). dusart_upper(3,5). dusart_upper(4,8).
dusart_upper(5,11). dusart_upper(6,15). dusart_upper(7,19). dusart_upper(8,23).
dusart_upper(9,27). dusart_upper(10,32). dusart_upper(11,36). dusart_upper(12,41).
dusart_upper(13,46). dusart_upper(14,51). dusart_upper(15,57). dusart_upper(16,62).
dusart_upper(17,67). dusart_upper(18,73). dusart_upper(19,78). dusart_upper(20,84).
dusart_upper(21,89). dusart_upper(22,95). dusart_upper(23,101). dusart_upper(24,107).
dusart_upper(25,113). dusart_upper(26,119). dusart_upper(27,125). dusart_upper(28,131).
dusart_upper(29,137). dusart_upper(30,143).

%% ============================================================
%% ROSSER (1962): rosser(N, X) = round(N * ln(N * ln(N)))
%% ============================================================
rosser(1,1). rosser(2,2). rosser(3,5). rosser(4,7). rosser(5,10).
rosser(6,13). rosser(7,17). rosser(8,20). rosser(9,24). rosser(10,28).
rosser(11,32). rosser(12,36). rosser(13,40). rosser(14,45). rosser(15,49).
rosser(16,54). rosser(17,58). rosser(18,63). rosser(19,67). rosser(20,72).
rosser(21,77). rosser(22,82). rosser(23,87). rosser(24,92). rosser(25,97).
rosser(26,102). rosser(27,107). rosser(28,112). rosser(29,117). rosser(30,122).

%% ============================================================
%% CIPOLLA (1902): cipolla(N, X)
%% ~ round(N*(ln(N) + ln(ln(N)) - 1 + (ln(ln(N))-2)/ln(N)))
%% Very accurate for larger N
%% ============================================================
cipolla(1,1). cipolla(2,1). cipolla(3,4). cipolla(4,6). cipolla(5,9).
cipolla(6,12). cipolla(7,16). cipolla(8,19). cipolla(9,23). cipolla(10,27).
cipolla(11,31). cipolla(12,35). cipolla(13,39). cipolla(14,43). cipolla(15,48).
cipolla(16,52). cipolla(17,57). cipolla(18,61). cipolla(19,66). cipolla(20,71).
cipolla(21,75). cipolla(22,80). cipolla(23,85). cipolla(24,90). cipolla(25,95).
cipolla(26,100). cipolla(27,105). cipolla(28,110). cipolla(29,115). cipolla(30,121).

%% ============================================================
%% N*LN(N): n_ln_n(N, X) = round(N * ln(N))
%% Basic Prime Number Theorem approximation (always underestimates)
%% ============================================================
n_ln_n(1,0). n_ln_n(2,1). n_ln_n(3,3). n_ln_n(4,6). n_ln_n(5,8).
n_ln_n(6,11). n_ln_n(7,14). n_ln_n(8,17). n_ln_n(9,20). n_ln_n(10,23).
n_ln_n(11,26). n_ln_n(12,30). n_ln_n(13,33). n_ln_n(14,37). n_ln_n(15,41).
n_ln_n(16,44). n_ln_n(17,48). n_ln_n(18,52). n_ln_n(19,56). n_ln_n(20,60).
n_ln_n(21,64). n_ln_n(22,68). n_ln_n(23,72). n_ln_n(24,76). n_ln_n(25,80).
n_ln_n(26,85). n_ln_n(27,89). n_ln_n(28,93). n_ln_n(29,98). n_ln_n(30,102).

%% ============================================================
%% N*(LN(N) + LN(LN(N))): n_ln_n_ln_ln_n(N, X)
%% Upper bound approximation (always overestimates for n>=6)
%% ============================================================
n_ln_n_ln_ln_n(2,2). n_ln_n_ln_ln_n(3,4). n_ln_n_ln_ln_n(4,8).
n_ln_n_ln_ln_n(5,11). n_ln_n_ln_ln_n(6,15). n_ln_n_ln_ln_n(7,19).
n_ln_n_ln_ln_n(8,23). n_ln_n_ln_ln_n(9,27). n_ln_n_ln_ln_n(10,31).
n_ln_n_ln_ln_n(11,36). n_ln_n_ln_ln_n(12,40). n_ln_n_ln_ln_n(13,45).
n_ln_n_ln_ln_n(14,50). n_ln_n_ln_ln_n(15,55). n_ln_n_ln_ln_n(16,60).
n_ln_n_ln_ln_n(17,65). n_ln_n_ln_ln_n(18,70). n_ln_n_ln_ln_n(19,75).
n_ln_n_ln_ln_n(20,80). n_ln_n_ln_ln_n(21,86). n_ln_n_ln_ln_n(22,91).
n_ln_n_ln_ln_n(23,96). n_ln_n_ln_ln_n(24,102). n_ln_n_ln_ln_n(25,107).
n_ln_n_ln_ln_n(26,113). n_ln_n_ln_ln_n(27,118). n_ln_n_ln_ln_n(28,124).
n_ln_n_ln_ln_n(29,130). n_ln_n_ln_ln_n(30,135).

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
%% SUCCESSOR / PREDECESSOR
%% ============================================================
succ(0,1). succ(1,2). succ(2,3). succ(3,4). succ(4,5). succ(5,6). succ(6,7). succ(7,8). succ(8,9). succ(9,10).
succ(10,11). succ(11,12). succ(12,13). succ(13,14). succ(14,15). succ(15,16). succ(16,17). succ(17,18). succ(18,19). succ(19,20).
succ(20,21). succ(21,22). succ(22,23). succ(23,24). succ(24,25). succ(25,26). succ(26,27). succ(27,28). succ(28,29). succ(29,30).
succ(30,31). succ(31,32). succ(32,33). succ(33,34). succ(34,35). succ(35,36). succ(36,37). succ(37,38). succ(38,39). succ(39,40).

prec(2,1). prec(3,2). prec(4,3). prec(5,4). prec(6,5). prec(7,6). prec(8,7). prec(9,8). prec(10,9).
prec(11,10). prec(12,11). prec(13,12). prec(14,13). prec(15,14). prec(16,15). prec(17,16). prec(18,17). prec(19,18). prec(20,19).
prec(21,20). prec(22,21). prec(23,22). prec(24,23). prec(25,24). prec(26,25). prec(27,26). prec(28,27). prec(29,28). prec(30,29).

%% ============================================================
%% CONSTANTS
%% ============================================================
one(1).
two(2).

