"""Verify ILP-generated rules for N-th prime against prime_formula BK and examples."""

import math

# === BK Data (from prime_formula/bk.pl) ===
cipolla_data = {
    2:1, 3:4, 4:6, 5:9, 6:12, 7:15, 8:19, 9:22, 10:26,
    11:30, 12:34, 13:38, 14:42, 15:46, 16:50, 17:55, 18:59, 19:63, 20:68,
    21:72, 22:77, 23:82, 24:86, 25:91, 26:96, 27:101, 28:106, 29:111, 30:116
}

rosser_data = {
    2:2, 3:5, 4:7, 5:10, 6:13, 7:17, 8:20, 9:24, 10:28,
    11:32, 12:36, 13:40, 14:44, 15:49, 16:53, 17:58, 18:62, 19:67, 20:72,
    21:76, 22:81, 23:86, 24:91, 25:96, 26:101, 27:106, 28:111, 29:117, 30:122
}

ln_ceil_data = {
    1:0, 2:1, 3:2, 4:2, 5:2, 6:2, 7:2, 8:3, 9:3, 10:3,
    11:3, 12:3, 13:3, 14:3, 15:3, 16:3, 17:3, 18:3, 19:3, 20:3,
    21:4, 22:4, 23:4, 24:4, 25:4, 26:4, 27:4, 28:4, 29:4, 30:4
}

# num domain: 1..200
def num(x): return 1 <= x <= 200

# === Positive examples ===
positives = {
    1:2, 2:3, 3:5, 4:7, 5:11, 6:13, 7:17, 8:19, 9:23, 10:29,
    11:31, 12:37, 13:41, 14:43, 15:47, 16:53, 17:59, 18:61, 19:67, 20:71,
    21:73, 22:79, 23:83, 24:89, 25:97, 26:101, 27:103, 28:107, 29:109, 30:113
}

# === Negative examples (from exs.pl) ===
negatives = set()
# Type 1: shifted primes
for n, p in [(1,3),(2,5),(3,7),(4,11),(5,13),(6,17),(7,19),(8,23),(9,29),(10,31)]:
    negatives.add((n,p))
# Type 2: composites 2*N
for n, p in [(2,4),(3,6),(4,8),(5,10),(6,12),(7,14),(8,16),(9,18),(10,20)]:
    negatives.add((n,p))
# Type 3: odd composites
for n, p in [(1,9),(2,9),(3,9),(4,9),(5,15),(6,15),(7,21),(8,21),(9,25),(10,27)]:
    negatives.add((n,p))
# Type 4: off-by-one
for n, p in [(1,1),(2,2),(3,4),(4,6),(5,12),(6,14),(7,16),(8,18),(9,22),(10,28)]:
    negatives.add((n,p))
# Type 5: n_ln_n raw values
for n, p in [(2,1),(3,3),(5,8),(7,14),(10,23),(15,41),(20,60),(25,80),(30,102)]:
    negatives.add((n,p))
# Type 6: random wrong
for n, p in [(1,5),(2,7),(3,11),(4,13),(5,17),(6,19),(7,23),(8,29),(9,31),(10,37)]:
    negatives.add((n,p))

# === Rule evaluation ===

def rule1(n):
    """f(N,P) :- cipolla(N,X), inc(X,P), modulo(P,6,O), modulo(O,4,1)."""
    if n not in cipolla_data:
        return None
    x = cipolla_data[n]
    p = x + 1  # inc
    if not num(p):
        return None
    o = p % 6
    if o % 4 == 1:
        return p
    return None

def rule2(n):
    """f(N,P) :- cipolla(N,X), ln_ceil(N,L), add(X,L,P), modulo(P,6,5)."""
    if n not in cipolla_data or n not in ln_ceil_data:
        return None
    x = cipolla_data[n]
    l = ln_ceil_data[n]
    p = x + l  # add
    if p <= 0 or not num(p) or not num(x) or not num(l):
        return None
    if p % 6 == 5:
        return p
    return None

def rule3(n):
    """f(N,P) :- rosser(N,X), modulo(X,6,R), sub(X,R,Y), inc(Y,P)."""
    if n not in rosser_data:
        return None
    x = rosser_data[n]
    r = x % 6
    # modulo succeeds even for R=0 (Z >= 0), but sub needs num(R) and num(Y) with Y>0
    if not num(r):  # num(0) is false!
        return None
    y = x - r
    if y <= 0 or not num(y):
        return None
    p = y + 1  # inc
    if not num(p):
        return None
    return p

# === Main Analysis ===
print("=" * 90)
print("RULE-BY-RULE TRACE FOR N=1..30")
print("=" * 90)

r1_covers = []
r2_covers = []
r3_covers = []
r1_wrong = []
r2_wrong = []
r3_wrong = []
all_covered = set()
neg_covered = set()

print(f"\n{'N':>3} {'Exp P':>5} | {'R1 P':>5} {'R1?':>4} | {'R2 P':>5} {'R2?':>4} | {'R3 P':>5} {'R3?':>4} | {'Covered?':>8}")
print("-" * 90)

for n in range(1, 31):
    exp_p = positives[n]
    
    p1 = rule1(n)
    p2 = rule2(n)
    p3 = rule3(n)
    
    r1_ok = p1 is not None and p1 == exp_p
    r2_ok = p2 is not None and p2 == exp_p
    r3_ok = p3 is not None and p3 == exp_p
    
    if r1_ok: r1_covers.append(n)
    if r2_ok: r2_covers.append(n)
    if r3_ok: r3_covers.append(n)
    
    # Track wrong outputs
    if p1 is not None and p1 != exp_p:
        r1_wrong.append((n, p1, exp_p))
        if (n, p1) in negatives:
            neg_covered.add(("R1", n, p1))
    if p2 is not None and p2 != exp_p:
        r2_wrong.append((n, p2, exp_p))
        if (n, p2) in negatives:
            neg_covered.add(("R2", n, p2))
    if p3 is not None and p3 != exp_p:
        r3_wrong.append((n, p3, exp_p))
        if (n, p3) in negatives:
            neg_covered.add(("R3", n, p3))
    
    covered = r1_ok or r2_ok or r3_ok
    if covered:
        all_covered.add(n)
    
    r1_str = f"{p1}" if p1 is not None else "-"
    r2_str = f"{p2}" if p2 is not None else "-"
    r3_str = f"{p3}" if p3 is not None else "-"
    
    mark1 = "YES" if r1_ok else ("WRONG" if p1 is not None and p1 != exp_p else "-")
    mark2 = "YES" if r2_ok else ("WRONG" if p2 is not None and p2 != exp_p else "-")
    mark3 = "YES" if r3_ok else ("WRONG" if p3 is not None and p3 != exp_p else "-")
    
    cov = "COVERED" if covered else "MISS"
    
    print(f"{n:>3} {exp_p:>5} | {r1_str:>5} {mark1:>5} | {r2_str:>5} {mark2:>5} | {r3_str:>5} {mark3:>5} | {cov:>8}")

uncovered = sorted(set(range(1,31)) - all_covered)

print("\n" + "=" * 90)
print("COVERAGE SUMMARY")
print("=" * 90)
print(f"Rule 1 covers: {len(r1_covers)} positives -> N={r1_covers}")
print(f"Rule 2 covers: {len(r2_covers)} positives -> N={r2_covers}")
print(f"Rule 3 covers: {len(r3_covers)} positives -> N={r3_covers}")
print(f"\nTotal unique covered: {len(all_covered)}/30")
print(f"Uncovered (9 remaining): N={uncovered}")
print(f"  -> Expected primes: {[(n, positives[n]) for n in uncovered]}")

# === Negative coverage check ===
print(f"\n{'=' * 90}")
print("CONSISTENCY CHECK (negative coverage)")
print("=" * 90)
if neg_covered:
    print(f"WARNING: Rules cover {len(neg_covered)} negative example(s)!")
    for rule, n, p in sorted(neg_covered):
        print(f"  {rule}: f({n},{p}) is a NEGATIVE example!")
else:
    print("CLEAN: No negative examples covered by any rule.")

# === Wrong outputs ===
print(f"\n{'=' * 90}")
print("FALSE POSITIVES (wrong P values produced)")
print("=" * 90)
print(f"Rule 1 wrong outputs ({len(r1_wrong)}):")
for n, got, exp in r1_wrong:
    print(f"  f({n},{got})  [expected {exp}, error={got-exp:+d}]")
print(f"Rule 2 wrong outputs ({len(r2_wrong)}):")
for n, got, exp in r2_wrong:
    print(f"  f({n},{got})  [expected {exp}, error={got-exp:+d}]")
print(f"Rule 3 wrong outputs ({len(r3_wrong)}):")
for n, got, exp in r3_wrong:
    print(f"  f({n},{got})  [expected {exp}, error={got-exp:+d}]")

# === Analysis of uncovered examples ===
print(f"\n{'=' * 90}")
print("ANALYSIS OF 9 UNCOVERED EXAMPLES")
print("=" * 90)
for n in uncovered:
    exp_p = positives[n]
    print(f"\nN={n}, expected P={exp_p}:")
    
    if n in cipolla_data:
        c = cipolla_data[n]
        print(f"  cipolla({n}) = {c}  (error = {exp_p - c:+d})")
    else:
        print(f"  cipolla({n}) = NOT DEFINED")
    
    if n in rosser_data:
        r = rosser_data[n]
        print(f"  rosser({n})  = {r}  (error = {exp_p - r:+d})")
        r_mod = r % 6
        print(f"    rosser%6 = {r_mod}{'  <-- R=0, sub fails (num(0) undefined)' if r_mod == 0 else ''}")
    else:
        print(f"  rosser({n})  = NOT DEFINED")
    
    if n in ln_ceil_data:
        print(f"  ln_ceil({n}) = {ln_ceil_data[n]}")
    
    # What correction would be needed from cipolla?
    if n in cipolla_data:
        needed = exp_p - cipolla_data[n]
        print(f"  Correction needed from cipolla: {needed:+d}")
        
        # Check if any simple operation gets there
        c = cipolla_data[n]
        if n in ln_ceil_data:
            lc = ln_ceil_data[n]
            print(f"    cipolla + ln_ceil = {c} + {lc} = {c+lc}  {'MATCH!' if c+lc == exp_p else f'(off by {exp_p-(c+lc):+d})'}")
            print(f"    cipolla - ln_ceil = {c} - {lc} = {c-lc}  {'MATCH!' if c-lc == exp_p else f'(off by {exp_p-(c-lc):+d})'}")
        print(f"    cipolla + 1 (inc) = {c+1}  {'MATCH!' if c+1 == exp_p else f'(off by {exp_p-(c+1):+d})'}")
        print(f"    cipolla - 1 (dec) = {c-1}  {'MATCH!' if c-1 == exp_p else f'(off by {exp_p-(c-1):+d})'}")
        print(f"    P mod 6 = {exp_p % 6}")

print(f"\n{'=' * 90}")
print("KEY OBSERVATIONS")
print("=" * 90)
print("""
1. N=1,2: cipolla/rosser have no BK data for N=1; N=2 has cipolla(2,1) but 
   no rule path reaches P=2 or P=3. These are BASE CASES.

2. N=12,25: rosser values (36,96) are divisible by 6 -> R=0 -> sub(X,0,Y) 
   fails because num(0) is not in the domain. STRUCTURAL BK GAP.

3. N=26: rosser(26)=101 is exactly the target! But Rule 3 rounds DOWN to 
   floor(101/6)*6+1 = 97. Need a rule that uses rosser directly.

4. N=17: cipolla(17)=55, needs +4. No simple single-op correction matches.

5. N=29,30: cipolla OVERSHOOTS (111>109, 116>113). These need SUBTRACTION 
   from cipolla, which none of the current rules provide.

6. N=24: cipolla(24)=86, needs +3=89. cipolla+ln_ceil=90 (off by 1).
""")
