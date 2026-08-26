"""
Verify the 7-clause prime formula hypothesis discovered by Cascade Popper.
Large-scale test: N = 1..10,000.

Uses EXACT precomputed BK lookup tables from bk.pl for N=1..30,
then extends all tables to N=10,000 using the same formulas.

Hypothesis:
  R1: f(N, P) :- cipolla(N, X), inc(X, P), modulo(P, 6, O), modulo(O, 4, 1).
  R2: f(N, P) :- cipolla(N, X), ln_ceil(N, L), add(X, L, P), modulo(P, 6, 5).
  R3: f(N, P) :- rosser(N, X), modulo(X, 6, R), sub(X, R, Y), inc(Y, P).
  R4: f(N, P) :- rosser(N, X), inc(X, P), modulo(N, 5, 2).
  R5: f(N, P) :- mult(N, 4, Y), sub(Y, 7, P), greater_than(N, 9).
  R6: f(N, P) :- mult(N, 4, Y), ln_floor(N, L), sub(Y, L, P), three(L).
  R7: f(N, P) :- inc(N, P), ln_ceil(N, 0).
"""

import math
import time
from sympy import prime as nth_prime

MAX_N = 10000

# ===================================================================
# EXACT BK LOOKUP TABLES (from bk.pl, N=1..30)
# ===================================================================

BK_CIPOLLA = {
    2:1, 3:4, 4:6, 5:9, 6:12, 7:15, 8:19, 9:22, 10:26,
    11:30, 12:34, 13:38, 14:42, 15:46, 16:50, 17:55, 18:59, 19:63, 20:68,
    21:72, 22:77, 23:82, 24:86, 25:91, 26:96, 27:101, 28:106, 29:111, 30:116,
}

BK_ROSSER = {
    2:2, 3:5, 4:7, 5:10, 6:13, 7:17, 8:20, 9:24, 10:28,
    11:32, 12:36, 13:40, 14:44, 15:49, 16:53, 17:58, 18:62, 19:67, 20:72,
    21:76, 22:81, 23:86, 24:91, 25:96, 26:101, 27:106, 28:111, 29:117, 30:122,
}

BK_LN_FLOOR = {
    1:0, 2:0, 3:1, 4:1, 5:1, 6:1, 7:1, 8:2, 9:2, 10:2,
    11:2, 12:2, 13:2, 14:2, 15:2, 16:2, 17:2, 18:2, 19:2, 20:2,
    21:3, 22:3, 23:3, 24:3, 25:3, 26:3, 27:3, 28:3, 29:3, 30:3,
}

BK_LN_CEIL = {
    1:0, 2:1, 3:2, 4:2, 5:2, 6:2, 7:2, 8:3, 9:3, 10:3,
    11:3, 12:3, 13:3, 14:3, 15:3, 16:3, 17:3, 18:3, 19:3, 20:3,
    21:4, 22:4, 23:4, 24:4, 25:4, 26:4, 27:4, 28:4, 29:4, 30:4,
}

# ===================================================================
# EXTENDED BK (N>30) - computed with same formulas as bk.pl comments
# ===================================================================

def extend_cipolla(n):
    if n < 2:
        return None
    ln_n = math.log(n)
    if ln_n <= 0:
        return None
    ln_ln_n = math.log(ln_n)
    return round(n * (ln_n + ln_ln_n - 1 + (ln_ln_n - 2) / ln_n))

def extend_rosser(n):
    if n < 2:
        return None
    ln_n = math.log(n)
    if n * ln_n <= 0:
        return None
    return round(n * math.log(n * ln_n))

def get_cipolla(n):
    return BK_CIPOLLA.get(n) or extend_cipolla(n)

def get_rosser(n):
    return BK_ROSSER.get(n) or extend_rosser(n)

def get_ln_floor(n):
    if n in BK_LN_FLOOR:
        return BK_LN_FLOOR[n]
    if n < 1:
        return None
    return math.floor(math.log(n))

def get_ln_ceil(n):
    if n in BK_LN_CEIL:
        return BK_LN_CEIL[n]
    if n < 1:
        return None
    if n == 1:
        return 0
    return math.ceil(math.log(n))

# ===================================================================
# RULES
# ===================================================================

def rule1(n):
    x = get_cipolla(n)
    if x is None:
        return None
    p = x + 1
    o = p % 6
    if o % 4 == 1:
        return p
    return None

def rule2(n):
    x = get_cipolla(n)
    if x is None:
        return None
    l = get_ln_ceil(n)
    if l is None:
        return None
    p = x + l
    if p % 6 == 5:
        return p
    return None

def rule3(n):
    x = get_rosser(n)
    if x is None:
        return None
    r = x % 6
    y = x - r
    if y <= 0:
        return None
    return y + 1

def rule4(n):
    if n % 5 != 2:
        return None
    x = get_rosser(n)
    if x is None:
        return None
    return x + 1

def rule5(n):
    if n <= 9:
        return None
    p = 4 * n - 7
    return p if p > 0 else None

def rule6(n):
    l = get_ln_floor(n)
    if l != 3:
        return None
    p = 4 * n - l
    return p if p > 0 else None

def rule7(n):
    if get_ln_ceil(n) != 0:
        return None
    return n + 1

RULES = [
    ("R1: cipolla+1, P%6%4=1", rule1),
    ("R2: cipolla+ceil(ln), P%6=5", rule2),
    ("R3: rosser-rosser%6+1", rule3),
    ("R4: rosser+1, N%5=2", rule4),
    ("R5: 4N-7, N>9", rule5),
    ("R6: 4N-3, floor(ln)=3", rule6),
    ("R7: N+1, ceil(ln)=0", rule7),
]

RULE_NAMES = [r[0] for r in RULES]
RULE_FNS   = [r[1] for r in RULES]

# ===================================================================
# MAIN
# ===================================================================

def main():
    t0 = time.time()
    print("=" * 90)
    print("  PRIME FORMULA - LARGE SCALE VERIFICATION")
    print(f"  Testing N = 1 .. {MAX_N:,}")
    print("=" * 90)

    print("\nComputing primes ...")
    actual = {}
    for n in range(1, MAX_N + 1):
        actual[n] = nth_prime(n)
    print(f"  Done. Prime({MAX_N}) = {actual[MAX_N]:,}  ({time.time()-t0:.1f}s)")

    # ------------------------------------------------------------------
    # Evaluate all rules for every N
    # ------------------------------------------------------------------
    print("\nEvaluating rules ...")
    # per_n[n] = { "results": {rule_name: P}, "correct": bool }
    per_n = {}
    # per_rule[i] = {"correct": [...], "wrong": [...]}
    per_rule = [{"correct": [], "wrong": []} for _ in RULES]

    for n in range(1, MAX_N + 1):
        results = {}
        for i, fn in enumerate(RULE_FNS):
            p = fn(n)
            if p is not None:
                results[i] = p
                if p == actual[n]:
                    per_rule[i]["correct"].append(n)
                else:
                    per_rule[i]["wrong"].append(n)
        any_correct = any(p == actual[n] for p in results.values()) if results else False
        per_n[n] = {"results": results, "correct": any_correct}

    print(f"  Done.  ({time.time()-t0:.1f}s)")

    # ------------------------------------------------------------------
    # 1) UNBROKEN STREAK FROM N=1
    # ------------------------------------------------------------------
    last_unbroken = 0
    for n in range(1, MAX_N + 1):
        if per_n[n]["correct"]:
            last_unbroken = n
        else:
            break

    print("\n" + "=" * 90)
    print("  1. UNBROKEN STREAK")
    print("=" * 90)
    print(f"\n  Hypothesis is correct WITHOUT ANY BREAK for N = 1 .. {last_unbroken}")
    print(f"  Covers primes: 2 through {actual[last_unbroken]:,}")
    if last_unbroken < MAX_N:
        nb = last_unbroken + 1
        print(f"\n  First failure at N = {nb}: expected prime {actual[nb]:,}")
        for i, fn in enumerate(RULE_FNS):
            p = fn(nb)
            if p is not None:
                print(f"    {RULE_NAMES[i]:30s} -> {p:6d} (off {p - actual[nb]:+d})")

    # ------------------------------------------------------------------
    # 2) ACCURACY AT DIFFERENT SCALES
    # ------------------------------------------------------------------
    print("\n" + "=" * 90)
    print("  2. ACCURACY AT DIFFERENT SCALES")
    print("=" * 90)

    checkpoints = [30, 50, 100, 200, 500, 1000, 2000, 5000, 10000]
    checkpoints = [c for c in checkpoints if c <= MAX_N]

    print(f"\n  {'Range':>12s}  {'Correct':>8s}  {'Wrong':>8s}  {'Accuracy':>9s}  {'Sporadic':>10s}")
    print("  " + "-" * 60)

    for cp in checkpoints:
        correct = sum(1 for n in range(1, cp+1) if per_n[n]["correct"])
        wrong   = cp - correct
        acc     = correct / cp * 100
        # sporadic = correct hits beyond unbroken streak
        sporadic = sum(1 for n in range(last_unbroken+1, cp+1) if per_n[n]["correct"])
        print(f"  N=1..{cp:>5,d}  {correct:>8,d}  {wrong:>8,d}  {acc:>8.2f}%  {sporadic:>10,d}")

    # ------------------------------------------------------------------
    # 3) PER-RULE STATS
    # ------------------------------------------------------------------
    print("\n" + "=" * 90)
    print("  3. PER-RULE ANALYSIS")
    print("=" * 90)

    for i in range(len(RULES)):
        nc = len(per_rule[i]["correct"])
        nw = len(per_rule[i]["wrong"])
        fires = nc + nw
        prec = nc / fires * 100 if fires > 0 else 0
        print(f"\n  {RULE_NAMES[i]}")
        print(f"    Fires: {fires:,} | Correct: {nc:,} | Wrong: {nw:,} | Precision: {prec:.2f}%")
        if per_rule[i]["correct"]:
            lst = per_rule[i]["correct"]
            last_c = lst[-1]
            # show training vs extrapolation split
            in_train  = [x for x in lst if x <= 30]
            out_train = [x for x in lst if x > 30]
            print(f"    In training (<=30): {len(in_train)} correct  |  Beyond training: {len(out_train)} correct")
            if out_train:
                shown = out_train[:20]
                print(f"    Beyond-30 hits at N = {shown}{'...' if len(out_train) > 20 else ''}")
            print(f"    Last correct N = {last_c} (prime {actual[last_c]:,})")

    # ------------------------------------------------------------------
    # 4) SPORADIC HITS DETAIL (beyond unbroken streak)
    # ------------------------------------------------------------------
    print("\n" + "=" * 90)
    print(f"  4. ALL SPORADIC HITS BEYOND N={last_unbroken}")
    print("=" * 90)

    sporadic_hits = []
    for n in range(last_unbroken + 1, MAX_N + 1):
        if per_n[n]["correct"]:
            which = [RULE_NAMES[i] for i, fn in enumerate(RULE_FNS)
                     if fn(n) == actual[n]]
            sporadic_hits.append((n, actual[n], which))

    if sporadic_hits:
        print(f"\n  Total sporadic hits: {len(sporadic_hits)}")
        show = sporadic_hits[:50]
        for sn, sp, sr in show:
            print(f"    N={sn:>5,d}  prime={sp:>7,d}  via {', '.join(sr)}")
        if len(sporadic_hits) > 50:
            print(f"    ... and {len(sporadic_hits) - 50} more")
    else:
        print("\n  No sporadic hits at all.")

    # ------------------------------------------------------------------
    # 5) ERROR DISTRIBUTION (how far off when wrong)
    # ------------------------------------------------------------------
    print("\n" + "=" * 90)
    print("  5. ERROR MAGNITUDE (combined hypothesis, closest rule)")
    print("=" * 90)

    errors = []
    for n in range(1, MAX_N + 1):
        if not per_n[n]["correct"] and per_n[n]["results"]:
            preds = list(per_n[n]["results"].values())
            closest = min(preds, key=lambda p: abs(p - actual[n]))
            err = closest - actual[n]
            pct_err = abs(err) / actual[n] * 100
            errors.append((n, actual[n], closest, err, pct_err))

    if errors:
        abs_errs = [abs(e[3]) for e in errors]
        pct_errs = [e[4] for e in errors]
        avg_abs = sum(abs_errs) / len(abs_errs)
        avg_pct = sum(pct_errs) / len(pct_errs)
        max_abs = max(abs_errs)
        max_pct = max(pct_errs)
        med_abs = sorted(abs_errs)[len(abs_errs) // 2]
        med_pct = sorted(pct_errs)[len(pct_errs) // 2]

        print(f"\n  Wrong predictions: {len(errors):,}")
        print(f"  Absolute error:  avg={avg_abs:,.1f}  median={med_abs:,}  max={max_abs:,}")
        print(f"  Percent error:   avg={avg_pct:.2f}%  median={med_pct:.2f}%  max={max_pct:.2f}%")

        # Bucket by range
        buckets = [(1,100), (101,500), (501,1000), (1001,5000), (5001,10000)]
        print(f"\n  {'Range':>14s}  {'#Wrong':>7s}  {'Avg|err|':>10s}  {'Avg%err':>9s}  {'Max|err|':>10s}")
        print("  " + "-" * 60)
        for lo, hi in buckets:
            if lo > MAX_N:
                break
            hi = min(hi, MAX_N)
            bucket = [e for e in errors if lo <= e[0] <= hi]
            if bucket:
                ba = sum(abs(e[3]) for e in bucket) / len(bucket)
                bp = sum(e[4] for e in bucket) / len(bucket)
                bm = max(abs(e[3]) for e in bucket)
                print(f"  N={lo:>5,d}-{hi:>5,d}  {len(bucket):>7,d}  {ba:>10,.1f}  {bp:>8.2f}%  {bm:>10,d}")

    # ------------------------------------------------------------------
    # 6) NEGATIVE EXAMPLE CHECK (from exs.pl)
    # ------------------------------------------------------------------
    print("\n" + "=" * 90)
    print("  6. NEGATIVE EXAMPLE CHECK")
    print("=" * 90)

    negatives = [
        (1,3),(2,5),(3,7),(4,11),(5,13),(6,17),(7,19),(8,23),(9,29),(10,31),
        (2,4),(3,6),(4,8),(5,10),(6,12),(7,14),(8,16),(9,18),(10,20),
        (1,9),(2,9),(3,9),(4,9),(5,15),(6,15),(7,21),(8,21),(9,25),(10,27),
        (1,1),(2,2),(3,4),(4,6),(5,12),(6,14),(7,16),(8,18),(9,22),(10,28),
        (2,1),(3,3),(5,8),(7,14),(10,23),(15,41),(20,60),(25,80),(30,102),
        (1,5),(2,7),(3,11),(4,13),(5,17),(6,19),(7,23),(8,29),(9,31),(10,37),
    ]

    neg_covered = 0
    for n_neg, p_neg in negatives:
        for fn in RULE_FNS:
            p = fn(n_neg)
            if p == p_neg:
                neg_covered += 1
                print(f"  !! NEGATIVE COVERED: f({n_neg},{p_neg}) -- hypothesis is inconsistent!")
                break

    if neg_covered == 0:
        print(f"\n  All {len(negatives)} negative examples correctly REJECTED. No false positives.")
    else:
        print(f"\n  {neg_covered}/{len(negatives)} negatives wrongly covered!")

    # ------------------------------------------------------------------
    # FINAL SUMMARY
    # ------------------------------------------------------------------
    total_correct = sum(1 for n in range(1, MAX_N+1) if per_n[n]["correct"])
    total_acc = total_correct / MAX_N * 100

    print("\n" + "=" * 90)
    print("  FINAL SUMMARY")
    print("=" * 90)
    print(f"""
  Test range:          N = 1 .. {MAX_N:,}
  Total correct:       {total_correct:,} / {MAX_N:,}  ({total_acc:.2f}%)
  Unbroken streak:     N = 1 .. {last_unbroken}  (primes 2 .. {actual[last_unbroken]:,})
  Sporadic beyond:     {len(sporadic_hits)} extra hits
  Negatives rejected:  {len(negatives) - neg_covered} / {len(negatives)}
  Elapsed:             {time.time() - t0:.1f}s
""")


if __name__ == "__main__":
    main()
