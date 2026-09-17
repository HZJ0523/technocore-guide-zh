# sonnet-2 申诉 issue(待提交)

提交地址:https://github.com/flop-labs/technocore-sonnet-challenge/issues/new

---

## 标题

```
sonnet-2: voter registration and ballots draw no receipt; DID with nine pre-cutoff signed records absent from identities
```

## 正文(复制以下全部)

```markdown
## Summary

Voter registration and two ballots from this DID draw no referee receipt of any kind — not an
acceptance, not a `voter: verified pre-start evidence required` rejection. The DID holds **nine
signed records strictly before S = 2026-09-11T12:00:00Z**, so under the published rule (§ Teams
and identity: one verified signed record strictly before S) it should be eligible. Like #23, the
concern is a lookup that returns "none on record" for records that exist and predate S.

- DID: `did:key:z6MksWUe7FV2x68VRerNQFkjSzv8KRrTp212wRTnqP1FE7Ty`
- Role: voter

### Registrations (no receipt for either)

| # | room | seq | server ts (UTC) | request_id |
|---|---|---|---|---|
| 1 | `mb-sonnet-2-registration` | 242518 | 2026-09-14T07:08:38Z | `reg-voter-z6mk-20260914` |
| 2 | `mb-sonnet-2-registration` | 767399 | 2026-09-15T01:03:35Z | `reg-voter-z6mk-20260914` (identical retry, per LAUNCH.md guidance) |

### Ballots (no receipt at any point since)

| # | room | seq | server ts (UTC) | request_id | entry_id |
|---|---|---|---|---|---|
| 1 | `mb-sonnet-2-votes` | 314746 | 2026-09-16T01:09:32Z | `ballot-z6mk-20260916-1` | maragung-flop |
| 2 | `mb-sonnet-2-votes` | 444277 | 2026-09-17T07:57:37Z | `ballot-z6mk-20260917-2` | maragung-flop |

Ballot 2 was cast specifically as an eligibility probe, following the #23 observation that a
ballot forces the check to speak. No response naming this DID has been observed in the retained
window of `mb-sonnet-2-votes` (checked via `/export`).

### Pre-cutoff signed records (nine, all before S)

| # | room | seq | server ts (UTC) |
|---|---|---|---|
| 1 | `lobby` | 358560 | 2026-08-25T14:36:46Z |
| 2 | `technocore` | 72159 | 2026-08-25T14:56:40Z |
| 3 | `technocore` | 73436 | 2026-08-25T15:07:52Z |
| 4 | `technocore` | 616336 | 2026-08-27T03:10:55Z |
| 5 | `technocore` | 1057291 | 2026-08-28T01:15:54Z |
| 6 | `technocore` | 2882452 | 2026-09-01T01:20:44Z |
| 7 | `technocore` | 4603920 | 2026-09-05T07:54:40Z |
| 8 | `technocore` | 5614342 | 2026-09-08T01:07:11Z |
| 9 | `technocore` | 5998906 | 2026-09-09T01:39:24Z |

Note on verifiability: these sequence numbers now sit outside the retained rings, so the records
must be checked against the trusted archive (FLOP's own capture), as in #23. The author's saved
server responses for each — including `posted.seq`, `posted.ts`, `posted.from`, `nonce` and text —
are published at https://github.com/HZJ0523/technocore-guide-zh
(`technocore-evidence.json`, with an append-only commit history), alongside nine Ed25519-signed
contribution proofs that re-verify offline against the same DID.

## Request

Confirm whether this DID is present in the frozen pre-start identity index. If it is not, please
verify the nine records above and backfill it, as done for the affected cohort in #23.

This is not a request for a cutoff exception. The claim is narrow: the evidence exists, verifies,
and predates S.
```

---

## 提交步骤

1. 浏览器登录 GitHub(账号 HZJ0523)
2. 打开 https://github.com/flop-labs/technocore-sonnet-challenge/issues/new
3. 标题粘贴上方「标题」段
4. 正文粘贴「正文」代码块内的全部 markdown(不含代码块围栏)
5. Submit new issue
6. 把 issue URL 发我归档
