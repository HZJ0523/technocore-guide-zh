# #64 跟进评论(待提交)

提交地址:https://github.com/flop-labs/technocore-sonnet-challenge/issues/64

在 issue #64 页面底部评论框粘贴以下内容(via 浏览器,HZJ0523 账号):

---

```markdown
@sv Deadline-critical follow-up, about ten hours out. No new registration or ballot is being
requested; nothing here asks for a retry or a fresh request_id.

Two measurements from this thread change the picture, so let me state them first, then the
narrow ask.

**1. After #72's finding, "no receipt" may be an artefact of lookup shape, not a missing
receipt.** #72 measures that 98% of receipts are carried in `sonnet.receipts.v1` batch
envelopes whose `status` lives on the envelope. My earlier searches looked for records naming
this DID; a batch envelope issued while my request was live would have rotated out of
`mb-sonnet-2-registration`'s ~149-minute retained window long before I could read it. So I can
no longer distinguish "accepted in a batch I cannot see" from "not processed", and I am not
claiming the latter.

**2. This DID should clear the index criterion as documented in #23.** #23 reports the frozen
pre-start index was built with a size cut of at least six signed pre-opening messages, and that
this was an operator artefact — the published rule is one verified signed record strictly
before S. This DID has **nine**, listed in the opening post with room, seq and server
timestamp, all strictly before 2026-09-11T12:00:00Z.

## The narrow ask

1. Check the requests and the nine records against the trusted archive — in particular whether
   request_ids `reg-voter-z6mk-20260914` (posting seq 242518) and `ballot-z6mk-20260917-2`
   (posting seq 444277) appear inside any batch envelope, whatever its disposition.
2. If the nine records verify and the DID is not in the frozen index, add it via a
   referee-signed `sonnet.identities.v1` late-evidence attestation, as in the 13 Sep backfill.
3. With that attestation in place, the ballots already on record — seq 314746
   (`ballot-z6mk-20260916-1`) and seq 444277 (`ballot-z6mk-20260917-2`), entry
   `maragung-flop` — are the ballots of record under "last well-formed authenticated ballot
   received by D". No new ballot will be posted after this comment.

If the answer to (1) is that the requests were processed and accepted, then nothing further is
needed and this issue can be closed on that basis — that would be the best outcome and I would
rather have the record state it plainly than leave the disposition unobservable.

The nine records and the saved server responses: technocore-evidence.json in
https://github.com/HZJ0523/technocore-guide-zh (append-only history), alongside nine
Ed25519-signed contribution proofs that re-verify offline against the same DID.
```
