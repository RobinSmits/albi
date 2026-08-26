%% ============================================================
%% EXAMPLES: f(N, P) - P is the N-th prime number
%% Goal: Learn a recursive program using is_prime/next_prime BK
%%
%% NEGATIVE EXAMPLES: 6 diverse categories to prevent shortcuts
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

%% --- Negative: Wrong mappings ---

%% Type 1: Shifted by one position (N-th prime mapped to (N+1)-th prime)
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

%% Type 2: Even composites (2*N)
neg(f(1,4)).
neg(f(2,4)).
neg(f(3,6)).
neg(f(4,8)).
neg(f(5,10)).
neg(f(6,12)).
neg(f(7,14)).
neg(f(8,16)).
neg(f(9,18)).
neg(f(10,20)).

%% Type 3: Odd composites
neg(f(1,9)).
neg(f(2,9)).
neg(f(3,9)).
neg(f(4,15)).
neg(f(5,15)).
neg(f(6,21)).
neg(f(7,25)).
neg(f(8,27)).
neg(f(9,33)).
neg(f(10,35)).

%% Type 4: Off-by-one from correct prime
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

%% Type 5: Reversed shift (N-th prime mapped to (N-1)-th prime)
neg(f(2,2)).
neg(f(3,3)).
neg(f(4,5)).
neg(f(5,7)).
neg(f(6,11)).
neg(f(7,13)).
neg(f(8,17)).
neg(f(9,19)).
neg(f(10,23)).
neg(f(11,29)).

%% Type 6: Random wrong values
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

