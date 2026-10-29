# FLOP 测试网首日作战手册

> 目标:faucet 开闸后第一小时内完成领水 → 确认 → 首笔推理消费 → 证据留痕。
> 前提:DID `did:key:z6MksWUe7FV2x68VRerNQFkjSzv8KRrTp212wRTnqP1FE7Ty`(identity.pem 在 E:\flop\technocore-did-starter\,passphrase 用户持有)。
> 路线:agent(领水消费推理,池 12 亿,3:1 消费解锁)。不做矿工/验证者。

## 规则锚点(2026-10-21 官方 docs 更新)

- **测试网无门槛**:无白名单、无人数上限、**无需申请**;miner/validator 表单只是联系名单,不审批不拒绝。11-03 直接参与。
- **空投凭 voucher**:记录快照块高前的已验证工作;voucher 可转让(HTLC),**不可花在推理上**;测试网 play token 无价值、不转换。
- **agent 领水有 per-identity 限额** → 推理量受 faucet 限额约束。
- 验证者测试网开放、网络赞助 stake;cutover 时 top-1,000 免费得 1,200,000 FLOP bond(本机硬件不达标,不参选)。

## 时间锚点(2026-10-19 官方 docs)

- **测试网目标:2026-11-03(周二)**,约 90 天;是目标而非定档,随 devnet 准入完成确认。
- 主网/TGE:**2027 Q1,目标 2 月初**(测试网 90 天后自然到达)。
- devnet 无奖励、无空投权重;矿工准入**暂无公开通道**(官方 TODO 未发布联系人)。
- **已知风险(未决)**:yellowpaper #172 — 经托管网关(api.flop.network)路由的消费,链上记在共享网关账户。官方澄清前,**agent 计分消费优先自行开通道,不依赖网关**。

## 0. 触发条件(任一出现即启动本手册)

- @flop_labs X 帖宣布测试网/faucet 开放
- flop.finance 出现测试网入口
- technocore.chat 路由表出现 faucet 端点(每日复查已覆盖)
- 官方仓库 flop-labs/technocore-chat 出现 faucet 提交(早于部署的信号)

## 0. 官方规则基线(2026-10-08 定稿,flop.finance/testnet + /airdrop)

- Agent:门槛 = DID + 钱包 + faucet(凭 DID)。**计分 = 已结算会话中购买的算力(pro rata)**;持币/领水不计分;同控钱包合并计;自导需求不认
- 解锁:锁仓每 3 FLOP 消费解锁 1 流动;无截止
- 分配:快照定格于测试网末块高 → 公示 + 哈希(可申诉)→ 写入创世块;**无 claim 截止,随时 claim**
- 矿工:质押网络赞助;需硬件 attested 或申请名单准入;按验证算力计分
- 安全披露有赏(生态储备);利用漏洞丧失资格

## 1. 开闸后 0-15 分钟:情报与确认

1. 读官方公告原文,确认:faucet 端点 URL、领水方式(签名消息?/kv 笔记?新端点?)、限额、测试网 RPC/入口
2. `curl -s https://technocore.chat/` 看路由表新增了什么
3. 若 faucet = technocore 上的签名操作:大概率复用 `say` 或 `kv set` 协议,签名规则不变(room|nonce|text)
4. 检查官方是否要求钱包地址(测试网原生地址,可能需要先装官方钱包/CLI — 以公告为准)

**未知项占位**(开闸时填):
- faucet 端点:`______`
- 领水命令形态:`______`
- 测试网网络入口/RPC:`______`
- 钱包工具:`______`

## 2. 15-30 分钟:领水

1. 用户亲手跑领水命令(passphrase 不经 Claude)
2. 立即保存服务器返回 JSON 回执(保留窗口可能只有几分钟!)
3. 记录:时间、金额、tx/seq、nonce

## 3. 30-45 分钟:首笔推理消费

1. 按公告的消费入口发一个真实推理请求(哪怕小)
2. 保存消费回执
3. 核对余额变化

## 4. 45-60 分钟:证据链闭环

1. 更新 E:\flop\testnet-runbook.md 记录段(下节)
2. X 发帖:领水 + 首笔消费 + DID + 证据(seq/tx)
3. `say technocore` 记录(用户跑,输 passphrase):
   ```
   python technocore_agent.py say technocore "Testnet day one: claimed faucet and completed first inference spend with this DID. Evidence: <URL>"
   ```
4. KV 笔记刷新(顺带续期)

## 5. 首日之后:90 天持续参与

**双线(2026-09-05 AMA 后确定)**:

- **Agent 消费线**:空投按测试网累计推理消费分配 — 稳定、真实、分散的消费,不刷量
- **矿工线(8G 卡复活)**:AMA 确认小设备可挖、无白名单无人数上限;intro 白皮书"Ordinary GPUs qualify"。8G 卡可跑量化小模型(7B 级)供推理。矿工池 12 亿 > agent 池,优先级提高
- 每次会话:复查 → 消费若干笔 / 矿工任务若干 → 记录
- 服务器(16 核)可跑消费自动化脚本,等官方消费 API 形态确定后由 Claude 编写
- 每周:KV 笔记刷新、指南更新(有新料才更)
- **反女巫暂宽松**(AMA 口径:测试网=压力测试),但仍做真实用量,防后续追溯

## 6. 防坑(开闸日骗子最多)

- 钓鱼"faucet"网站:只从 flop.finance / @flop_labs 原帖点链接
- 假冒测试网要求输主网私钥/助记词:永不
- 付费领水:官方 faucet 免费,收费皆骗
- 假 CA 交易:测试网代币无交易价值,任何买卖盘皆骗

## 官方 CLI(@flop-labs/cli@0.4.0,2026-10-29 发布;bin `flop`)

安装:`npm i -g @flop-labs/cli`(或 npx)。maintainer = CTO Sergey Vidyuk,正版。

```
flop --network testnet faucet        # 领水(子命令待开闸时 --help 细化)
flop --network testnet balance <SS58>
flop gpu                             # 本机 GPU 能力检测
flop network                         # 网络档案解析/检查
flop wallet / keys / session         # 钱包/密钥/会话管理
flop channel ...                     # 查询/结算 compute channel
flop chat "..."                      # FLOP 结算的持久会话(= agent 消费最简入口)
flop proxy                           # 本地 OpenAI 兼容代理,每请求在 FLOP 结算(自己 signer → 记自己账户)
flop launch <agent-type>             # 启动 agent 并把 LLM 调用路由到 FLOP 网关
flop miner ...                       # 矿工 onboarding(8G 卡线)
flop info <miner-ss58>               # 矿工 stake 信息
```

要点:`--keystore <polkadot.json> --password-env <VAR>` 用 Polkadot.js 导出的加密 keystore(passphrase 不进命令行历史);`--output agent` 模式适合脚本;**`proxy`/`chat`/直连 `session run` 走自己 signer → 计分归自己账户**(避开 #172 网关记账问题);`launch`/hermes 走托管网关,计分主体未官方澄清前不用。

## 记录段(开闸时填)

- 开闸时间:
- 领水回执:
- 首笔消费回执:
- X 帖 URL:
- technocore 记录 seq:
