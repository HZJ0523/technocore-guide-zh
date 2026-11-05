# network 仓库 access issue 文案(官方邮件指定路径)

> 依据:info@flop.finance 回信"setup questions → GitHub issues,工程师直接回复"。
> 开 issue 地址:https://github.com/flop-labs/network/issues/new?template=node-bug.yml
> (无 access 专用模板时用最接近的模板,标题前缀 `access:` —— #65/#68/#69 同款)
> **发之前**:先用 CLI 生成专用矿工账户(SS58),填入 Public identifiers;种子/助记词永不入 issue。

---

**Title:** access: devnet miner sponsorship for 1x RTX 4060 (8 GB)

**Request**

devnet miner sponsorship (public installer pack / operator review)

**Network**

devnet

**Public identifiers**

`<MINER_SS58>` (SS58, miner account, sr25519)

**Details**

Single owned host: 1x NVIDIA RTX 4060 Laptop (8 GB), Ubuntu 26.04 (WSL2), Docker 29.8.2 with the NVIDIA container runtime verified (GPU visible in CUDA containers), driver 616.92 / CUDA 13.4. Home connection (no inbound ports): sessions will be served through our own HTTPS tunnel to 127.0.0.1:8645.

Model we can serve within 8 GB: Qwen/Qwen2.5-0.5B-Instruct (0x1a52c1ab…, BF16), with the pinned images from releases.json (miner-worker 0.1.238, miner-vllm-toploc 0.1.239, digests verified). Happy to retry sponsor.sh within the rate limit behind the auto-sponsorship cap.

Miner interest form submitted 2026-10-08; invited via email reply from info@flop.finance pointing here. Goal: registered + calibrated + accepted-work evidence before testnet day one. One miner account, no fleet.

---

## 发 issue 前置:生成矿工 SS58(我来跑,种子只留本机)

WSL 内:
```bash
npm i -g @flop-labs/cli@0.4.0
flop --network devnet keys generate --output ~/.flop/miner-keystore.json   # 子命令名以 flop keys --help 为准
```
只把打印出的 **SS58 地址** 填进 issue;keystore 文件与密码留在 WSL。
