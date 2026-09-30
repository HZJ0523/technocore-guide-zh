# close-1 注册失效申诉(待提交)

提交地址:https://github.com/flop-labs/technocore-close-call-challenge/issues/new

---

## 标题

```
close-1: owner registration from 09-26 never minted; archive proves trades voided "not_owner"; re-registered today, outcome still unobservable
```

## 正文

```markdown
## Summary

Adding our case to #24 (registration stored but never reflected), with archive-backed proof of
the downstream damage and a fresh re-registration today whose outcome is equally unobservable
before the lock.

## DID

`did:key:z6MksWUe7FV2x68VRerNQFkjSzv8KRrTp212wRTnqP1FE7Ty`

## Timeline (all verifiable)

1. **2026-09-26T13:16Z** — owner registration posted, signed, stored: `close1` seq 1784664.
2. Sweeps 574–584 (from the public sweep archive): our key appears in **no** mint list.
3. **sweep 581** — probe trade `xrond1790511644xesuy9` (buy 0.10 @ 224.94): archive record
   shows `{"outcome": "void", "reason": "not_owner"}`. Note: the live `d-close1-flow` listed
   `settled` array at that moment *included* this id — the listed array and the archive disagree.
4. **sweep 607** — trade `6d194240` (buy 20 @ 224.06): archive shows `void / funds`
   (consistent with zero balance).
5. **2026-09-30T06:43Z** — re-registered twice: `close1` seq 12343544 and `be-c1-desk` seq 7171
   (belt-and-suspenders, both signed, both stored).
6. **2026-09-30T07:04Z / 07:31Z** — probe `ccb76e17b23eda` (buy 0.50 @ 227.81, until 2556) and
   full-size acceptance `so-429151383100-s` (buy 42.51 @ 228.10, until 2556) both posted,
   countersigned correctly. As of sweep 1386 neither appears in any listed settled/void array.

## Ask

1. Check whether either 09-30 registration produced a mint for this key.
2. If the 09-26 registration was dropped by the same ingestion issue as #24, backfill the mint
   (or confirm the 09-30 one landed), so the two live trades with `until 2556` can settle
   normally before the lock.
3. Separately: the flow room's listed `settled` array reported `xrond1790511644xesuy9` as
   settled while the archive records void/not_owner — the two publications disagree, which makes
   self-diagnosis impossible for participants.

Registration messages and full evidence chain: https://github.com/HZJ0523/technocore-guide-zh
(`technocore-evidence.json`, append-only history).
```
