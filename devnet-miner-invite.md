# Devnet 矿工邀请申请邮件(草稿)

> 用途:回复 Flop Labs 的 "Devnet is open" 邮件(发件人 Shu),申请 devnet 矿工邀请。
> 官方口径:"If you get stuck setting up a validator or a miner, reply to this email and we'll help you get running."
> 背景:run-miner(2026-11-02)明确 devnet 矿工自 10-30 起走公共端点,但仍需 devnet operator 逐账户批准后 sponsor 质押。
> 直接回复那封邮件即可,或发 security 之外的官方联系渠道(官方只公布过表单与邮件回复)。

---

**Subject:** Miner devnet invitation request — RTX 4060 8GB host ready

Hi Shu,

Thanks for opening the devnet. I'd like to join as a SOFT-tier miner and went through the run-miner guide — requesting operator approval for one miner account.

Host: owned machine, RTX 4060 8GB, Ubuntu 26.04 (WSL2) with Docker 29.8.2 and the NVIDIA container runtime verified (GPU visible inside CUDA containers). I'll serve the session endpoint on a public HTTPS name via the supplied Caddy sidecar or my own tunnel, and plan to run the approved Qwen/Qwen2.5-0.5B-Instruct BF16 checkpoint with the pinned worker/backend images from releases.json (0.1.238/0.1.239).

I also submitted the miner interest form on 2026-10-08 (single 8GB card, SOFT tier). I understand paid sessions aren't open yet — the goal is to have registration, calibration and accepted-work evidence done before testnet day one, exactly as the guide describes.

Could you approve my miner address for sponsorship, or point me to the intake? I'll report inference, registration, calibration and session-readiness evidence separately as they land.

Thanks!

---

## 获批后操作序(依 run-miner 2026-11-02 版)

1. 等官方给 **access bundle**(pinned 镜像 + Compose + env 模板 + decode policy + Tailscale auth key 或 Caddy 方案)
2. `flop.gpu` / `nvidia-smi` 复检(已预检通过)
3. 起 worker + vllm-toploc 后端(同 `MODEL_HASH`)
4. `POST https://faucet.flop.network/sponsor/miner` 请求 sponsor 质押(新矿工 ~1M FLOP,无需自有币)
5. 校准(hwCalibration)→ 等 accepted work;**paid sessions 未开放**,devnet 只做就绪证据
6. 限额提示:全网每 24h 最多 10 个新 sponsored 矿工 — 获批后尽早执行
