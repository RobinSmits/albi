%% ============================================================
%% EXAMPLES: f(N, P) - P is the N-th prime number
%% Goal: Discover a CLOSED-FORM approximation formula
%%
%% NEGATIVE EXAMPLES STRATEGY:
%%   - Wrong prime mappings (shifted by 1, 2)
%%   - Composite numbers near primes
%%   - Values from wrong approximation functions
%%   - Random non-prime values
%%   This forces the ILP to learn the EXACT mapping, not just
%%   "filter out even numbers"
%% ============================================================

%% --- Positive: f(N, P) where P is the N-th prime ---
pos(f(1,2)).
pos(f(2,3)).
pos(f(3,5)).
pos(f(4,7)).
pos(f(5,11)).
pos(f(6,13)).
pos(f(7,17)).
pos(f(8,19)).
pos(f(9,23)).
pos(f(10,29)).
pos(f(11,31)).
pos(f(12,37)).
pos(f(13,41)).
pos(f(14,43)).
pos(f(15,47)).
pos(f(16,53)).
pos(f(17,59)).
pos(f(18,61)).
pos(f(19,67)).
pos(f(20,71)).
pos(f(21,73)).
pos(f(22,79)).
pos(f(23,83)).
pos(f(24,89)).
pos(f(25,97)).
pos(f(26,101)).
pos(f(27,103)).
pos(f(28,107)).
pos(f(29,109)).
pos(f(30,113)).

%% --- Negative: DIVERSE wrong mappings ---

%% Type 1: Shifted primes (off by 1 position)
neg(f(1,3)).
neg(f(2,5)).
neg(f(3,7)).
neg(f(4,11)).
neg(f(5,13)).
neg(f(6,17)).
neg(f(7,19)).
neg(f(8,23)).
neg(f(9,29)).
neg(f(10,31)).

%% Type 2: Composites (even numbers, 2*N)
neg(f(2,4)).
neg(f(3,6)).
neg(f(4,8)).
neg(f(5,10)).
neg(f(6,12)).
neg(f(7,14)).
neg(f(8,16)).
neg(f(9,18)).
neg(f(10,20)).

%% Type 3: Odd composites near primes
neg(f(1,9)).
neg(f(2,9)).
neg(f(3,9)).
neg(f(4,9)).
neg(f(5,15)).
neg(f(6,15)).
neg(f(7,21)).
neg(f(8,21)).
neg(f(9,25)).
neg(f(10,27)).

%% Type 4: Off-by-one from correct answer
neg(f(1,1)).
neg(f(2,2)).
neg(f(3,4)).
neg(f(4,6)).
neg(f(5,12)).
neg(f(6,14)).
neg(f(7,16)).
neg(f(8,18)).
neg(f(9,22)).
neg(f(10,28)).

%% Type 5: n_ln_n values (to reject raw approximation without correction)
neg(f(2,1)).
neg(f(3,3)).
neg(f(5,8)).
neg(f(7,14)).
neg(f(10,23)).
neg(f(15,41)).
neg(f(20,60)).
neg(f(25,80)).
neg(f(30,102)).

%% Type 6: Random wrong values (primes mapped to wrong N)
neg(f(1,5)).
neg(f(2,7)).
neg(f(3,11)).
neg(f(4,13)).
neg(f(5,17)).
neg(f(6,19)).
neg(f(7,23)).
neg(f(8,29)).
neg(f(9,31)).
neg(f(10,37)).

