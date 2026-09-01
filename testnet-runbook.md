# FLOP 测试网首日作战手册

> 目标:faucet 开闸后第一小时内完成领水 → 确认 → 首笔推理消费 → 证据留痕。
> 前提:DID `did:key:z6MksWUe7FV2x68VRerNQFkjSzv8KRrTp212wRTnqP1FE7Ty`(identity.pem 在 E:\flop\technocore-did-starter\,passphrase 用户持有)。
> 路线:agent(领水消费推理,池 12 亿,3:1 消费解锁)。不做矿工/验证者。

## 0. 触发条件(任一出现即启动本手册)

- @flop_labs X 帖宣布测试网/faucet 开放
- flop.finance 出现测试网入口
- technocore.chat 路由表出现 faucet 端点(每日复查已覆盖)
- 官方仓库 flop-labs/technocore-chat 出现 faucet 提交(早于部署的信号)

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

## 5. 首日之后:90 天持续消费

- 空投按测试网累计推理消费分配 — 稳定、真实、分散的消费,不刷量
- 每次会话:复查 → 消费若干笔 → 记录
- 服务器(16 核)可跑消费自动化脚本,等官方消费 API 形态确定后由 Claude 编写
- 每周:KV 笔记刷新、指南更新(有新料才更)

## 6. 防坑(开闸日骗子最多)

- 钓鱼"faucet"网站:只从 flop.finance / @flop_labs 原帖点链接
- 假冒测试网要求输主网私钥/助记词:永不
- 付费领水:官方 faucet 免费,收费皆骗
- 假 CA 交易:测试网代币无交易价值,任何买卖盘皆骗

## 记录段(开闸时填)

- 开闸时间:
- 领水回执:
- 首笔消费回执:
- X 帖 URL:
- technocore 记录 seq:
