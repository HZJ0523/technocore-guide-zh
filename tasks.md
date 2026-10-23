# FLOP / Technocore 每日任务清单与维护协议

> 版本:2026-10-24(在跑 26 项 + 归档 4 项)。本文件由 Claude 在"新的一天"会话中自动维护。
> 维护规则见文末;变更记入"变更日志"。

## 一、每日检查(21 项)

### A. 官方(6)

1. **Teaser 版本行** — `flop.finance/teaser/` 提取 `Version X (draft) Updated YYYY-MM-DD`。
2. **首页链接 diff** — `flop.finance/` 全部 href 对比上次(新页面/新表单)。
3. **Technocore 版本 + faucet 探测** — `technocore.chat/.well-known/agent.json` 版本号;`/faucet` 状态码(**404=未上线**;出现非 404 立即上报)。
4. **Intro 页日期** — `/intro/` 与 `/intro/yellowpaper/` 的 `Updated` 日期。
5. **org 事件流** — `api.github.com/orgs/flop-labs/events`(一次覆盖全部仓库 push/PR/issue/release)。
6. **/config 参数** — `technocore.chat/config`(房间上限、dupe 过滤等运维参数)。

### B. 深挖(5)

7. **sitemap diff** — `flop.finance/sitemap.xml` 与 `technocore.chat/sitemap.xml`(新页面最先现形)。
8. **technocore-chat open issues** — 运维限制、新示例、schema 讨论。
9. **yellowpaper issues** — 团队技术评审面(D-0440 空投池变更即此发现)。
10. **托管页 vs GitHub 镜像** — `flop.finance/intro/yellowpaper/` 比 `flop-labs/yellowpaper` 新;以托管页为准。
11. **分配数字一致性** — teaser 与托管黄皮书的分配表交叉核对(历史漂移:35 亿 vs 44 亿)。

### C. 比赛(3,至 2026-09-18T12:00Z — **今日到期,下个会话归档**)

12. **回执追踪** — 轮询 `mb-sonnet-2-registration` export 查我们 DID(`z6MksWUe7FV2x68…`)的回执,验证签名者为裁判 DID `z6MkowHQwsx9xr84…`。
    - **注意环形窗口**:注册室吞吐 3–13 条/秒,窗口仅存约 2.4 万条;我方注册消息(seq 242518)已滚出。若首次注册逾 24 小时无回执,按官方口径(同 request_id 重试返回原回执)重发**同一 request_id** `reg-voter-z6mk-20260914`,勿换新 ID。
    - **2026-09-16 修订**:回执缺失是**系统性**问题,非我方个案。官方仓库 issue #39 实测:70 分钟窗口内 18,689 条注册仅 4 条回执(且裁判一旦响应仅需 8–11 秒,非延迟)。issue #40/#42/#43/#46/#47 均为同类报告。**结论:不再重发;改以"投出 ballot 触发资格审查"作为决定性测试**(issue #23 先例:ballot 可迫使裁判裁决)。
    - 资格权威判据改为 `d-sonnet-2-results` 房间的 `sonnet.identities.v1` 增量记录(含 `evidence_sha256` 与 `first_seen`)。
    - **2026-09-18 修订**:issue #72 实测 **98% 回执为批量信封**(`sonnet.receipts.v1`,status 在信封层)— "按 request_id 查无回执"多为查询形态假象。我方注册可能已被接受;已向 #64 提交跟进评论求明确处置。
    - 社区工具:`dharmanan/sonnet-registration-status`(第三方注册状态监控,可参考其累积方法)。
13. **四房间巡查** — `mb-sonnet-2-campaign` / `submissions` / `votes` / `d-sonnet-2-rules`(裁判每 4 小时状态播报)。
14. **投出 ballot** — 已投两张(seq 314746、444277,entry `maragung-flop`);截止前不再新投(已向 #64 声明"以现有两张为准")。

### C3. close-1 交易赛(已终,2026-10-04 — 归档)

23. **close-1 参赛跟踪** — **赛终归档**:结算价 234.69;我方三单全 void(mint 未发放,裁判 bug 集群 #26/#31-35);得分 0。证据全存 technocore-evidence.json。#26 申诉留档。

### C2. 赛后(至领奖窗口关闭)

22. **结果与领奖跟踪** — **结果已于 2026-09-23 发布(2026-10-16 发现)**:胜者 `maragung-flop`(我方两 ballot 所投);我方 DID 在 `payouts.json` 中,应得 **7 FLOP**(voter 池 floor(50,000/6,852),计票依据为 `ballot-z6mk-20260917-2`,intake_seq 1448731)。payouts.json sha256 `ebc0de59…` 与签名收据(seq 45498)一致。
    - **claim 待主网**:开闸后在 `mb-sonnet-2-registration` 签 `sonnet.claim.v1`(`contest_id`/`request_id`/`destination`);claim 只定收款地址,不改金额。
    - **硬依赖:FLOP 收款地址**(格式待公布)— 见一次性动作。此后本项转"待主网"档,仅需月度复查 claim 窗口是否开启。

### D. 外部(3)

15. **子域名探测** — `faucet.technocore.chat`、`testnet.technocore.chat`、`claim.technocore.chat`(模式已证:`tclk.technocore.chat`、`mcp.technocore.chat` 存在)。
16. **X 搜索** — 域限 `x.com` 搜 @flop_labs / @CryptoHayes 近期发帖。
17. **新闻搜索** — `Flop Labs FLOP testnet announcement`,近一日。

### E. 生态(1,周频)

18. **生态扫描** — GitHub 搜 `technocore OR flop` 新仓库:同行贡献(竞争)与新监控工具。附 `gpus.flop.finance`(官方可租 GPU 市场监控:H100 容量、价格地板、API 毛利、盈亏平衡租价)— 矿工租/买决策时看,平时扫一眼。

### F. 维护(1,≤每周)

19. **KV 笔记刷新** — 写 `did-a4/6f172335ff9660`(7 天不写过期)。

### G. 告警(1)

20. **裁判行为突变监控** — `d-sonnet-2-rules` 状态计数:rejected/unevidenced 比率异常(sample: 09-16 rejected 31,796 超 accepted 15,200)时显式告警。关联 C12:重发后仍无回执 + rejected 激增 → 判定可能被拒,改查裁判 refusal 消息。

21. **sonnet-challenge issue 跟踪器** — `flop-labs/technocore-sonnet-challenge/issues` 新 issue 与回复。**赛事期间每日**;09-18 后周频。理由:该跟踪器是裁判行为/规则澄清/修复的最高信号源 — 09-17 的突破(issue #23 揭示身份索引 ≥6 条大小截断)即出自此;我方申诉 #64 的回复也在其中。

24. **docs.flop.network 检查(2026-10-15 新增)** — `https://docs.flop.network/llms.txt` 页数/内容 diff + `/docs/network-testnet` 状态页 + **12 个 FAQ 页 `Last updated` 日期 diff**(2026-10-21 新增:10-20 一批页面内容更新但 llms.txt 页数不变,只查页数会漏 — 实测 12 页同时改版)。理由:官方运维文档站(2026-10-19 已从 26 → **34 页**);testnet status 页是开闸最直接信号源。附 `ask.flop.finance`(问答 + MCP,3 工具:search/get/manifest)。

28. **官方数据面/网络状态(2026-10-19 新增,每日)** — 四端点合计 <10 秒:
    - `api.flop.network/openapi.json`(版本;当前 2.0.0,17 路径,含 `/enroll/wallet`、`/chat/completions`、`/keys/me/receipts`;`/v1/models` 公开目录,现仅 `qwen/qwen2.5-0.5b-instruct`,4+ 矿工报价)
    - `explorer.devnet.flop.network/api/stats` + `/api/health`(块高/TPS/validators/agents/operators/finality state)
    - `rpc.devnet.flop.network`(JSON-RPC `chain_getBlockHash`)
    - `faucet.flop.network/health`
    - 理由:**agent 线真正的花钱入口**;yellowpaper #172 指出网关路由消费可能记在共享网关账户(实测同账户占 122 通道中 46 个),R8.4 计分主体未定(官方 0 回复)→ 澄清前,计分消费优先自行开通道,不走网关。
    - 附:devnet 实况(2026-10-19)块高 1,584,112、10 validators、**0 active agents / 0 operators** — agent 侧仍是空白,先进入者有先发优势。
    - 周频附查:`explorer.devnet.flop.network/api/miners`(活跃矿工、selfStake、G_n、calibration)与 `/api/models`(模型注册/价格)— 判断矿工生态成熟度。

25. **KOL 排行榜跟踪(2026-10-16 新增,每日)** — 2026-10-15 Arthur Hayes 预告 **KOL Leaderboard**(Flop Labs 转发):devnet explorer 的 *Participate* 菜单下,每周 FLOP 奖池按 **certified work** 比例分给公开 KOL;三步入驻 = 邮箱魔法链接 → 绑定收款钱包(签名证明所有权)→ 验证社媒(可选)。**尚未上线,池大小 TBA**。
    - 检查面:@flop_labs / @CryptoHayes 新帖;`flop.finance/apply/kol` 页变化;devnet explorer 的 Participate 区(需 devnet 访问,待开闸)。
    - 上线后动作:入驻(邮箱=已有 KOL 表单邮箱;钱包=主网钱包装好后绑定;社媒=X @HzzzJ87419)。排行榜列含 "Funded wallets"(引流钱包数),与推荐链接、定期钱包抽奖挂钩 — 与测试网矿工/agent 线协同。

26. **kibble 生态跟踪(2026-10-18 深扫新增,周频)** — `kibble.world`(社区,自述 "A public job board for useful work, until $FLOP can pay"):索引 technocore `/r/kibble` 房间(kibble-v1 协议:JOB/CLAIM/RESULT/ATTEST),按 kibble-score-v2 出 passports 排名,自称 "reputation is an IOU for a future airdrop"。规模:22.4 万 JOB、5,754 agents(实测 10-18)。
    - 每周查:`/api/status`(score_schema 变化 / reset 标志)+ 官方是否首次提及 kibble 或定义 "certified work"(docs.flop.network 与 flop.finance 当前 **0 次提及**;KOL 排行榜的 certified work 度量未定义,kibble 是头号候选解读)。
    - **暂不参与**:官方零背书;房间 bot 环境重(89 万条解析中 58.6 万被 ignore);与官方空投规则(测试网验证算力)无已证关联。若官方定义挂钩 kibble 或提及 → 提请用户决策是否以现有 DID 做真实贡献(勿 keygen 新 DID — 身份连续性是资产)。
    - 官方关联信号仅一条:tc-chat issue #955(kibble 索引游标问题)有维护者跟帖(至 10-16)— 关注但不等于背书。

27. **faucet 监测(每日)** — **官方 faucet 已上线:`https://faucet.flop.network`(devnet)**(2026-10-19 深扫发现,CT 证书枚举)。实测:`/chain` 返回 devnet 链参数(genesis `0x99c172c0…`,ss58Format **42**,decimals **18**,symbol FLOP,RPC `wss://rpc.devnet.flop.network`);`/health` signer `5DZsAQ…M8ux`;页面:quick 25 FLOP,人类验证 500–2000 FLOP(BrightID / Self,按 Human Passport 或 Guild score)。
    - 每日:faucet `/health` + `/chain` 是否新增 **testnet** network;technocore `/r/faucet` 房尾(仍为第三方 dFLOP drip + kibble 广告,**非官方,不领**)。
    - devnet 领水无空投权重;但可演练全流程(钱包→领水→消费),等 testnet 同日执行。

29. **验证者席位路径(2026-10-20 新增,周频;10-21 修订)** — 官方 `run-validator` + `validator-faq` + `skills/setup-validator`。
    - **测试网验证者开放报名:无白名单、无上限、无需购买;测试网 stake 由网络赞助**(docs testnet-and-timeline 10-20 更新)。**须切换到实网(devnet 仍是管理员控制)**。
    - 选中者(cutover 时 top-1,000)每人**免费获得 1,200,000 FLOP 的 bond**;评分维度:uptime、出块、准确度、延迟、地理分布(三个月全程,权重未公布)。
    - 硬件规划 8 核/32GB/4TB NVMe/1Gbps;本机磁盘与网络不达标 → **不参选**,仅跟踪规则变化。
    - 每周查:run-validator / testnet-and-timeline 更新。

30. **托管黄皮书决议 ID 监控(2026-10-24 新增,每日)** — `flop.finance/intro/yellowpaper/` 正文里的 `D-04xx/D-05xx` 决议编号。**页脚日期不可信**(10-05 之后正文已加 D-0528/0529/0530/0531)。做法:抓页面,提取最大 `D-0xxx`,与上次比对;新增即读该段并判断是否影响 agent/矿工/空投规则。
    - 基线(2026-10-24):最大 **D-0531**(链下推荐排行榜 + 抽奖,genesis_reserve 出资)。
    - 附:`docs.flop.network/reference`(skills 的 SHA-256 与 CLI/env 名)每周扫一眼。

## 二、一次性动作(非每日)

| 动作 | 状态 |
|---|---|
| 提交 awesome-technocore PR | **❌ 作废(2026-10-18 发现)**:`flop-labs/awesome-technocore` 仓库已删除/转移(404,org 下 7 仓无此名),PR #12 随之消失。无动作;指南仓库仍在 |
| 填 validator 意向表(`flop.finance/apply/validator`) | **✅ 已提交**(2026-09-15,含硬件现状与升级意向) |
| 填 miner 意向表(`flop.finance/apply/miner`) | **✅ 已提交**(2026-10-08,8GB 单卡 SOFT 层,申请名单通道) |
| 测试网开闸首日跑 `testnet-runbook.md` | 条件触发 |
| **准备 FLOP 收款地址** | **✅ 已完成(2026-10-19)**:`5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY`(SS58 prefix 42,Polkadot.js,种子用户自持)。devnet faucet 已到账 25 FLOP(仅演练,无空投权重)。用途:sonnet-2 的 7 FLOP claim、测试网 faucet、空投 destination |
| **close-2 启动预案** | issue #36 显示续赛设计中;启动时改 close1_trade.py 的 SEASON 字符串 + 重跑注册/交易流程 |
| **KOL 排行榜入驻** | 条件触发(上线后):邮箱 → 绑钱包(签名) → 验社媒;表单已于 2026-08-29 提交 |

## 三、维护协议(每次"新的一天"执行)

每次会话按顺序执行:**跑检查 → 维护清单 → 报告**。

### 1. 跑检查
批量执行 1–19,只记录**差异**与异常;无差异则一句话确认。

### 2. 维护清单(核心要求)

- **淘汰**:某项连续 5 次无产出且非关键信号 → 降频(每日→每周)或删除。过期任务(如 C 组 09-18 后)立即移除并归档到变更日志。
- **新增**:检查过程中发现的**新面**(新仓库/新端点/新文档/新平台/新房间)若满足「有信息量 + 成本低」→ 加入清单并注明理由。判断标准:该面能产出影响空投决策的信息。
- **校准**:频率与价值匹配(每日/每周);单项成本超过 30 秒的考虑降频。
- **输出**:任何增删改记入下方变更日志(日期 + 动作 + 理由)。

### 3. 周期深扫(每周一次,或用户要求时)

- 旧面重扫 + 主动挖掘未探面(方法同 2026-09-14 的九轮:未读文档、未探端点、生态搜索、子域名、第三方仓库)。
- 结果若产生新检查点,按维护协议加入。

### 4. 报告格式

```
检查: 无差异 / [列出差异项]
维护: 无变更 / [增/删/改 + 理由]
待办: [状态更新]
```

## 四、变更日志

### 2026-10-24 — 托管黄皮书新增 4 项决议(镜像没有) + 新增 C30
- **新增 C30(托管黄皮书决议 ID 每日监控)**:页脚日期不可信(仍 10-05,正文已含 D-0528…D-0531);改为提取最大 D-0xxx 编号做 diff。基线 D-0531。
- 深扫其他:`docs.flop.network/reference` 公开(两个 skill 的 SHA-256、CLI/env 名);官方入口仍写 "Public operator enrollment is unavailable";technocore 新出现第三方房间 `/r/mb-flop-lotto`(alphaotc.xyz 的 paper 抽奖,非官方、无空投关联)。
- **D-0530**:只允许运营者自 stake,**委托/佣金作废**;社区入口为 5% 区块奖励的限时锁定池(7 档)。→ 指南旧表述已更正。
- **D-0529**:协议零销毁;罚没 100% 归 Foundation。
- **D-0528**:赞助本金计入矿工容量 bond / 验证者最低 stake(devnet/testnet)→ 对应测试网网络赞助 stake。
- **D-0531**:链下推荐排行榜 + 定期抽奖,资金来自 `genesis_reserve`,取代 6–10% 链上推荐佣金 → **KOL Leaderboard 的协议基础**(C25 补注)。
- 注意:托管黄皮书页脚仍显示 2026-10-05(正文已变);issue #178 指出 ask 站与黄皮书矛盾(agent 解锁等)。
- 另:CRU(算力预订单元)为白皮书 §12 设计,测试网不含,**不要**碰任何"FLOP 算力期货"站点。
- 计数:25 项不变。

### 2026-10-21 — 深扫补:12 FAQ 页批量改版 → C24 加日期 diff
- **docs 站 10-20 一次性改版 12 个 FAQ 页**(competitive-landscape / core-terms / demand-and-broker / miner-and-validator-economics / staking-and-slashing / team-and-company / technology-and-chain / testnet-and-timeline / tokenomics-and-supply / verification-and-security / verification-stack / what-is-flop),而 llms.txt 页数 34 不变 → **只查页数会漏更新**。
- **C24 增强**:每日 diff 这 12 页的 `Last updated` 日期。
- 要点补充:miner economics(H100 首月约 $15k/月区块奖励,~8–10× 租金;测试网按"同算力在主网本可赚多少"计空投;25% TGE + 1:1 解锁,约 4 个月全解锁);团队(Maelstrom 唯一股权,无外部融资,2 年+ runway;Hayes 全职 CEO);验证(四层,不需 TEE 也可用消费卡)。
- 计数:25 项不变(C24 增强)。

### 2026-10-21 — 规则澄清:测试网无门槛、验证者席位免费、空投凭 voucher
- **测试网完全开放**:无白名单、无人数上限、**无申请流程**;miner/validator 表单只是联系名单,不审批不拒绝("nobody is approved or rejected").→ 用户无需等准入,11-03 直接参与。
- **测试网验证者同样开放**:无白名单、无上限、无需购买,网络赞助 stake;cutover 时 top-1,000 每人**免费得 1,200,000 FLOP bond**。评分 = uptime/出块/准确度/延迟/地理分布,权重未公布。(本机硬件不达标,仍不参选。)
- **空投凭 voucher**:voucher 记录截至快照块高的已验证工作,是链上可转让 token(HTLC 可 P2P 出售,解锁义务随买方);**不可用于推理消费**;测试网 play token 无价值、不转换;转移测试网余额是否允许未定。
- **agent 领水有 per-identity 限额** → agent 可做的推理量受 faucet 限,不受矿工供给限。
- **无地区限制、不发资格声明**;测试网算力规划 ~1,000 H100-eq。
- yellowpaper #172 收到两条社区回复(指向 R8.7/R8.8:网关代开通道的消费**无法解锁终端用户 grant**)——官方仍未表态,结论不变:自己开通道。
- 计数:在跑 25 项不变(C29 修订)。

### 2026-10-20 — 全盘深扫:验证者路径 + explorer 公共 API + ask MCP
- **新增 C29(验证者席位,周频)**:`run-validator` / `validator-faq` / **新发布 `skills/setup-validator`**。验证者纯 CPU;硬件规划 8 核/32GB/4TB NVMe/1Gbps;座位 1,200,000 FLOP 自 stake(空投即 bond);准入仍管理员控制。
- **C28 周频附查**:explorer 公共 API `/api/miners`、`/api/models`(实测:活跃矿工有真实 stake 与奖励;模型仅 Qwen2.5-0.5B,`minVramGb: 1`)。
- **ask.flop.finance MCP 可用**(3 工具:search/get/manifest)— 官方语料问答面;搜 "gateway credit" 无直接答案(yellowpaper #172 仍无官方口径)。
- 其他:证书枚举无新子域;docs 站无 sitemap;challenges.technocore.chat 根为 Not Found;tclk 根 404(仅 MCP);`/rooms` 官方房无新增。
- 计数:24 → 25 项。

### 2026-10-19 — 全盘深扫:官方 faucet / explorer / devnet RPC 全部在线
- **证书透明度枚举发现 8 个未在导航里出现的官方端点**,实测:
  - `faucet.flop.network` **200** — 官方领水站(devnet):quick 25 FLOP;人类验证 500–2000 FLOP(BrightID/Self + Human Passport/Guild score);`/chain` 给出链参数(genesis `0x99c172c0…`,**SS58 prefix 42**,decimals 18,RPC `wss://rpc.devnet.flop.network`),`/health` 有 signer
  - `explorer.devnet.flop.network` **200** — devnet 浏览器:Chain / PoUI / **Participate** / Markets / Cross-Chain;`/api/stats` 块高 1,584,112、TPS 1.73、10 validators、41 accounts、**0 agents / 0 operators**;`/api/health` phase live
  - `rpc.devnet.flop.network` **405 on GET / 200 on JSON-RPC** — devnet RPC 活
  - `api.flop.network` 200 — 推理网关(17 路径,`/v1/models` 公开,仅 Qwen2.5-0.5B,4+ 矿工实时报价)
  - `gpus.flop.finance` 200 — 可租 GPU 市场监控(H100 容量/价格地板/API 毛利);`links.tx.flop.finance` 400;`voice.flop.network` 530(Cloudflare 1033);`intro.flop.network` 302 → flop.finance/intro
- **C27 重写**:官方 faucet 已上线;每日查 testnet network 是否出现。
- **C28 扩为四端点**:api + explorer stats + rpc + faucet health。
- **一次性动作 F:FLOP 收款地址格式已定 → 立即可做**(SS58 prefix 42)。
- 计数:仍为在跑 24 项(C27 改写 + C28 扩容,未新增编号);一次性动作表更新收款地址条目。

### 2026-10-19 — 时间表落地 + docs 扩页 + 网关(api.flop.network)
- **测试网目标日确定:2026-11-03(周二)**,约 90 天;主网/TGE 2027 Q1(目标 2 月初)。来源 `docs.flop.network/docs/testnet-and-timeline`(2026-10-16)。devnet 第一批机构矿工/验证者自 10-13 周起准入,10 月下半月扩大;**devnet 无奖励无空投权重**,唯一价值是让机器在测试网首日就绪。**矿工准入无公开申请通道**(run-miner 明确 "There is no public intake path yet",TODO 联系人未发布)— user 只需保持表单在册。
- **docs 站扩容 26 → 34 页**(新增 8 页,均为 2026-10-16)。`run-miner` 于 2026-10-19 更新,并发布官方 **setup-miner skill**(`docs.flop.network/skills/setup-miner/SKILL.md`)—— 与本地预检栈一致(GPU VM + Docker + TOPLOC 后端 + tailnet HTTPS 8645)。
- **api.flop.network 实况**(新增 C28):OpenAI 兼容网关,已上线(200),`/enroll/wallet` + `/chat/completions` + `x_flop_receipt`;当前仅接受 funded API key,链上支付验证未启用。
- **风险项 yellowpaper #172**(今日开,0 回复):网关路由的已结算消费,链上 `agent` 是共享网关账户(实测同一账户占 122 通道中 46 个),**R8.4 的消费计分可能不归终端 agent**。影响 agent 空投路线 → 官方澄清前,不把"网关消费"当作有效计分消费。
- 计数:在跑 23 → 24 项。

### 2026-10-18 — 深扫:kibble/faucet 房两个新面 + PR12 作废
- **新增 C26(kibble 生态,周频)**:发现 `kibble.world`(社区有用工作板块,kibble-score-v2 排名,自称未来空投 IOU;官方文档 0 提及)。规模大(22.4 万 JOB / 5,754 agents)。策略:监控不参与,等官方 certified work 定义。
- **新增 C27(faucet 房监测,每日)**:`/r/faucet` 房已有**第三方** dFLOP drip(issuer …TSUHZM1C,非官方)+ kibble 广告 bot。官方 faucet 开前只看不领,防 DID 污染。
- **PR #12 作废**:`flop-labs/awesome-technocore` 仓库已 404(org 现 7 仓:yellowpaper、technocore-chat、tclk、close-call-challenge、**codescape(09-27 新,Rust 3D 代码可视化工具,无空投关联)**、sonnet-challenge、.github)。一次性动作表更新。
- 其他深扫结果:openapi.json 无新路径(有 kv set-signed 与 /healthz,均为已知);隐藏语言区探测 8 个全 404;flop.network 302 → flop.finance;ask.flop.finance 200 正常;docs.flop.network/explorer 等子域无解析;D-0525 见 10-18 例行报告。
- 计数:在跑 21 → 23 项。

### 2026-10-16 — sonnet-2 结果入账 + 新增 C25
- **重大补漏**:sonnet-2 结果**早在 2026-09-23 已发布**(结果包 `results/sonnet-2/`,签名记录 `d-sonnet-2-results` seq 45488–45498),今日才在每日巡查中发现 — C22 此前只盯着"shortlist 待发布",未反向复查仓库 results 目录。教训:依赖"等公告"的项,**每周至少主动查一次产出物本体**(payouts/standings/CSV),不能只等房间播报。
- **我方入账确认**:voter,`7 FLOP`,依据 `ballot-z6mk-20260917-2`(intake_seq 1448731);DID 在 payouts.json 与 allocations.csv 中一致;sha256 与签名收据相符。claim 待主网。
- C22 改写为"待主网 claim"(降频为月度复查)。
- **新增 C25(KOL 排行榜跟踪)**:2026-10-15 Hayes 预告周度FLOP奖池按 certified work 分配,三步入驻;与已有 KOL 表单、X 线、推荐钱包抽奖协同。上线即入驻。
- 一次性动作新增"KOL 排行榜入驻"。
- 其他无差异:docs 仍 26 页、testnet status `planned`;teaser/whitepaper/testnet/airdrop 页均显示 Updated 2026-10-05;首页链接无新增;子域名无变化;technocore agent.json 版本升至 **0.14.5**(最新 tag v0.14.1,09-23)。
- 计数:在跑 20 → 21 项。

### 2026-09-14 — 建立
- 清单定稿 19 项(A6/B5/C3/D3/E1/F1),来源:本日九轮全盘复查。
- 一次性动作 3 项登记。
- 维护协议确立(淘汰/新增/校准/深扫/报告)。

### 2026-09-14 — 修订 C12
- 理由:实测注册室环形窗口约 2.4 万条、吞吐 3–13 条/秒;我方注册消息 2 小时内即滚出窗口,而裁判 intake 游标推进仅 0.6–1.3 条/秒。加入"逾 24 小时无回执则重发同一 request_id"的预案(官方口径允许,勿换新 ID)。

### 2026-09-15 — C12 预案执行
- 24 小时无回执,同 request_id `reg-voter-z6mk-20260914` 重发成功(新 seq 767399,generation 1 — 房间已换代)。继续追踪回执。

### 2026-10-15 — 新增 C24(清单 → 20 项)
- 发现 `docs.flop.network` 官方文档站:operator hub(miner/validator/gpu-provider 手册,devnet 现行)、26 页知识库(llms.txt)、testnet status 页(planned)、`ask.flop.finance` 问答站 + MCP。
- 新检查项:llms.txt diff + network-testnet 状态。信号优先级高于 sitemap — 开闸前该页会先变。
- 计数:19 → 20 项。

### 2026-09-16 — 新增 C20
- 理由:裁判状态首次出现行为突变 — rejected(31,796)超过 accepted(15,200),并新增 `unchanged` 计数。此信号直接关系我方注册是否被拒;独立成项以显式告警。
- 关联 C12:重发后仍无回执 + rejected 激增 → 判定可能被拒,届时改查裁判 refusal 消息取证。
- 计数:19 → 20 项。

### 2026-09-26 — 新增 C23(close-1 参赛)
- 发现第 6 个官方仓库 `technocore-close-call-challenge`(09-25 创建,比赛已开跑):NVDA 单注期货赛,10,000 POLF/人,前 3 分 1,000,000 FLOP,结算 10-04T10:00Z。
- 用户拍板参加,已注册(seq 1784664)。铸造待 sweep(受 issue #10 mint 停滞影响可能延迟)。
- 规则要点:maker 定条款(价/量/向/until),taker 双签,发任意注册交易房;成交须在参考价 ±5% 内;1% 手续费;越远离共识的正确方向得分越高。
- 计数:19 → 20 项。

### 2026-09-20 — C 组归档 + #64 胜利结案
- **#64 已由 sv 关闭并确认**:"This registration and ballot are on record... Final results will be published with the shortlist." — 注册与两张 ballot 均在记录上,"无回执"确系批量信封假象(issue #72 判断正确)。
- **C12/C13/C14 归档**(赛事 09-18T12:00Z 已关闭):回执追踪、四房间巡查、ballot 投票 — 全部完成使命。
- C22(赛后结果与领奖)保持:等 shortlist 发布 → 核对我方 ballot 是否计入 → 若 maragung-flop 胜出且票计入则签 `sonnet.claim.v1`。
- 观察:`d-sonnet-2-results` 房 503(服务整体健康,该房疑似在重写最终数据);agent.json 版本号短暂显示 0.11.4(边缘缓存陈旧)。

### 2026-09-18 — 新增 C22 + 到期标记
- **新增 C22(赛后结果与领奖跟踪)**:赛事 12:00Z 关闭后,C 组过期归档;新任务跟踪最终计票/胜者/领奖窗口,必要时签 `sonnet.claim.v1`。理由:若我方 ballot 计入且所投 maragung-flop 胜出,可分享 50k FLOP 投票池 — 需主动跟踪领奖。
- **一次性动作新增**:准备 FLOP 收款地址(sonnet 领奖 + 未来空投共用;格式待官方公布)。
- C12/C13/C14 标记"今日 12:00Z 到期,下个会话归档"。
- 计数:21 → 22 项。

### 2026-09-18 — #72 揭示回执形态(修订 C12 认知)
- 官方仓库 issue #72(09-18T01:17Z):**98% 回执为批量信封**(`sonnet.receipts.v1`,status 在信封层);实测注册室 174 个批量信封含 4,720 条 accepted。单独按 request_id 查会误报"无回执"。
- 影响:我方注册/ballot 的"无回执"**可能只是查询形态假象**,非实际未处理 — 已无法回溯区分(注册室环形仅 ~149 分钟)。
- 行动:已在 #64 起草跟进评论(`E:\flop\issue64-comment.md`),措辞明确"不求重试/新 ID",只求:(1) 查两个 request_id 是否在任意批量信封内及处置 (2) 若九条记录核实则加入 late-evidence attestation (3) 以现有两张 ballot 为准。待用户提交。

### 2026-09-17 — 新增 C21(清单 → 21 项)
- 理由:sonnet-challenge issue 跟踪器此前不在清单,而它是当日最大突破(issue #23)的来源,也是我方申诉 #64 的回复渠道。赛事期间每日查,09-18 后降为周频。
- 关联:C12 现同时监控申诉 #64 的维护者回复。

### 2026-09-17 — 第二次 ballot + 申诉提交
- ballot 2 投出(`ballot-z6mk-20260917-2`,seq 444277,09-17T07:57:37Z)。15 分钟内无裁决;全环 export 搜我方 DID 仅见 ballot 本身。
- **申诉 issue #64 已提交**(2026-09-17T08:05:12Z):https://github.com/flop-labs/technocore-sonnet-challenge/issues/64 — 含 9 条截止前记录清单 + 证据链链接。**加入每日监控(查维护者回复)**。
- 观察:裁判现改为批量回执(`sonnet.receipts.v1` 数组),reason 含 `voter: role/room` 与 `voter: verified pre-start evidence required`。

### 2026-09-17 — 资格规则真相(issue #23)
- 官方 issue #23 披露:裁判的**冻结预启动身份索引**由存档构建时施加**大小截断** — 身份须有 **≥6 条开赛前签名消息**(或 sonnet-1 参与)。官方称此为运营产物而非规则(公布规则为"1 条截止前签名记录"),受影响 158 个身份已修复(cohort attested & replayed)。
- 我方核算:**开赛前签名消息 9 条**(lobby 358560 + technocore 72159/73436/616336/1057291/2882452/4603920/5614342/5998906,08-25 至 09-09)— **满足 ≥6**。
- ballot 裁决时延实测(issue #23):**52 秒**。09-16 所投 ballot 的裁决可能已发但滚出环形窗口。
- 行动:重投 ballot(改票规则允许,新 request_id),随后 1–2 分钟内探测裁决;若 rejected → 按他人先例向挑战仓库提 issue 申诉(附 9 条证据 seq/时间戳)。

### 2026-09-16 — 投出 ballot(触发资格审查)
- `mb-sonnet-2-votes` seq 314746,entry `maragung-flop`,request_id `ballot-z6mk-20260916-1`。
- 现场观察:裁判在该室活跃发裁决,窗口内 3 条均为 `status:"rejected"` + `reason:"voter: verified pre-start evidence required"`(他人 DID)— 证实 ballot 强制资格检查(issue #23 先例)。
- 待观察:我方 ballot 是否收到裁决。若 rejected 且理由为 evidence → 走挑战仓库 issue 申诉(他人先例)。

### 2026-09-16 — 修订 C12/C13(系统性回执缺失)
- 新证据:官方挑战仓库 issue #39(18,689 注册仅 4 回执,响应速度 8–11 秒证明非积压)、#40(已注册选民的 ballot 无任何回执;身份集 `sonnet.identities.v1` 查无其 DID)、#42/#43/#46/#47 同类。
- 行动变更:停止重发;改以投出 ballot 作为资格的**决定性测试**;资格判据锚定 `d-sonnet-2-results` 的 `sonnet.identities.v1` 增量记录。
- 投票策略:按 `mb-sonnet-2-votes` 保留窗口内的 ballot 计数选领先作品(投票池 50k FLOP 仅投中者分享)。09-16 实测领先:maragung-flop 2084、pelmora 168、wakeverse 92。
