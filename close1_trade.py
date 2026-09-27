#!/usr/bin/env python3
"""close-1 trade tool: make or accept offers on technocore.chat close1 room.

Usage:
  python close1_trade.py make buy 224.90 43 2580          # side px qty until_sweep
  python close1_trade.py accept <room> <seq>              # countersign a taker:"any" order
  python close1_trade.py take sell 1                      # auto-accept best open sell <= qty (we buy)
Requires technocore-did-starter on sys.path; prompts for identity passphrase.
"""
from __future__ import annotations

import getpass
import json
import sys
import time
import uuid
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "technocore-did-starter"))
import technocore_agent as tc  # noqa: E402

SEASON = "close-1"
DID = "did:key:z6MksWUe7FV2x68VRerNQFkjSzv8KRrTp212wRTnqP1FE7Ty"
KEY_PATH = Path(__file__).parent / "technocore-did-starter" / "identity.pem"


def terms_canon(terms: dict) -> str:
    return json.dumps(terms, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def load_key():
    return tc.load_identity(KEY_PATH, allow_prompt=True)


def post(text: str):
    resp = tc.post_signed_message(load_key(), "close1", text, base_url=tc.DEFAULT_BASE_URL)
    print(json.dumps(resp, ensure_ascii=True, indent=1)[:1500])


def make(side: str, px: str, qty: str, until: int):
    terms = {
        "id": uuid.uuid4().hex[:12],
        "maker": DID,
        "px": f"{float(px):.2f}",
        "qty": f"{float(qty):.2f}".rstrip("0").rstrip(".") if float(qty) % 1 else str(int(float(qty))),
        "side": side,
        "taker": "any",
        "until": int(until),
    }
    canon = terms_canon(terms)
    key = load_key()
    maker_sig = tc.sign_bytes(key, f"{SEASON}|terms|{canon}".encode())
    msg = {"t": "trade", "season": SEASON, "terms": terms, "taker": "any", "maker_sig": maker_sig}
    print("terms:", canon)
    post(json.dumps(msg, ensure_ascii=False, separators=(",", ":")))


def accept(room: str, seq: int):
    view = tc.read_room(room, limit=200)
    m = next((x for x in view["messages"] if x["seq"] == seq), None)
    if m is None:
        sys.exit(f"seq {seq} not in retained window of {room}")
    msg = json.loads(m["text"])
    if msg.get("t") not in ("trade", "offer"):
        sys.exit(f"seq {seq} is not a trade/offer")
    terms = msg["terms"]
    if terms.get("taker") not in ("any", DID):
        sys.exit("order not open to us")
    if "maker_sig" not in msg:
        sys.exit("no maker_sig on order")
    canon = terms_canon(terms)
    key = load_key()
    taker_sig = tc.sign_bytes(key, f"{SEASON}|accept|{canon}|{DID}".encode())
    out = {"t": "trade", "season": SEASON, "terms": terms,
           "taker": DID, "maker_sig": msg["maker_sig"], "taker_sig": taker_sig}
    print("accepting:", canon)
    post(json.dumps(out, ensure_ascii=False, separators=(",", ":")))


def take(maker_side: str, max_qty: float, room: str = "close1"):
    """Accept the best open maker order of maker_side (we take the other side)."""
    view = tc.read_room(room, limit=200)
    price_view = tc.read_room("d-close1-price", limit=1)
    lo, hi = json.loads(price_view["messages"][-1]["text"])["limits"]
    best = None
    for m in reversed(view["messages"]):
        try:
            j = json.loads(m["text"])
        except (json.JSONDecodeError, KeyError):
            continue
        if j.get("t") != "trade" or j.get("season") != SEASON or "taker_sig" in j:
            continue
        terms = j.get("terms", {})
        if terms.get("taker") != "any" or "maker_sig" not in j:
            continue
        if terms.get("side") != maker_side:
            continue
        px, qty = float(terms["px"]), float(terms["qty"])
        if not (float(lo) <= px <= float(hi)) or qty > max_qty:
            continue
        # best for us: buy->lowest sell px; sell->highest buy px
        score = px if maker_side == "sell" else -px
        if best is None or score > best[0]:
            best = (score, m["seq"], terms, j["maker_sig"])
    if best is None:
        sys.exit(f"no open {maker_side} order <= {max_qty} in band [{lo},{hi}] within window")
    _, seq, terms, maker_sig = best
    canon = terms_canon(terms)
    key = load_key()
    taker_sig = tc.sign_bytes(key, f"{SEASON}|accept|{canon}|{DID}".encode())
    out = {"t": "trade", "season": SEASON, "terms": terms,
           "taker": DID, "maker_sig": maker_sig, "taker_sig": taker_sig}
    print(f"taking seq {seq}: {canon}")
    post(json.dumps(out, ensure_ascii=False, separators=(",", ":")))


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 1
    cmd = sys.argv[1]
    if cmd == "make" and len(sys.argv) == 6:
        make(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    elif cmd == "accept" and len(sys.argv) == 4:
        accept(sys.argv[2], int(sys.argv[3]))
    elif cmd == "take" and len(sys.argv) in (4, 5):
        take(sys.argv[2], float(sys.argv[3]), sys.argv[4] if len(sys.argv) == 5 else "close1")
    else:
        print(__doc__)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
