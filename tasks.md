# FLOP / Technocore 每日任务清单与维护协议

> 版本:2026-11-25(**测试网实战期**;在跑 18 项 = T3 + S7 + W4 + M4)。本文件由 Claude 在"新的一天"会话中自动维护。
> 维护规则见文末;变更记入"变更日志"。旧编号 → 新编号对照见 2026-11-24 变更日志。

## 一、检查项(按阶段:测试网 2026-11-24 起分阶段开放;当前 `live, unscored` — 见 runbook「测试网开放实况」)

### T. 测试网实战(每日 — 空投只认这里)

1. **T1 Agent 线:领水 + 推理消费 + 证据(最优先)** — 每天凭 Technocore DID(`z6MksWUe7FV2x68…`,08-25 起有记录)**领测试网 FLOP**(形态以官方 setup 页为准:Technocore 聊天室签名或一次 API 调用)→ **花在推理上** → 回执(tx/channel/receipt)写入 `technocore-evidence.json`。
    - 规则:无审批无等待名单;**空投按 agent 在测试网的行为计量,攒着不花 = 零**。
    - passphrase / keystore 密码相关的命令**由用户亲手跑**;我只给命令、收地址与回执。
    - **计分尚未开始**:官方 — earning 自"未来一次 runtime 升级的公示 finalized activation block"起算,目前未公布区块或日期;此前活动记零、不补。
    - 待官方发布后补入:最低活跃门槛("随测试网规则发布")。
    - **领水通道已公布(11-25)**:Technocore 房间 `flop-testnet-faucet`,签名消息 `!faucet request <SS58> <nonce>`(命令见 runbook「测试网开放进展」);agent 每笔 10 FLOP、24 小时上限 10、需先花掉上一笔才能再领。
    - **硬规则(官方 `flop.finance/testnet/` 四条公平规则)**:同控钱包按一个参与者计;**花到自己矿工的支出不计** — agent 消费必须选独立矿工,绝不买我方矿工;刷量没收;每个角色有最低活跃门槛(数值未公布)。
    - **暂不领取**:计分未开始,官方称 TechnoCore claims "await an announced, finalized grant",且 11-25 04:10 UTC 实测 bot 只兑付过 1 笔(1082 条请求)。开领条件:激活区块公布,或 bot 兑付转正常(faucet 签名账户 `5CcDr5Bc…gXtw` 的 txCount 开始增长)。
2. **T2 矿工线:栈运维(每日;每次"新的一天"先拉栈)** — Docker Desktop 引擎 → `compose up -d` → 重起 cloudflared 取新域名 → 更新 `miner.env` 的 `SESSION_PUBLIC_HOST` → `up -d worker` → 端点应 401。然后查:
    - 容器状态(restarts=0);**announce 存活**:近 1 小时 `Endpoint ad … published` >0,**为 0 → restart worker**(#358:RPC 停滞后 announce 循环静默死亡,矿工健康但隐形)
    - **实际服务量**:`explorer…/api/compute-channels?miner=<地址>` 与网关 price_sources(测试网等价端点)是否含我方。**"Uptime on its own is not counted. Inference served is what counts."**
    - `releases.json` 版本 diff → **有新版即自动升级**(11-12 用户授权):备份身份文件 → `compose pull` → `up -d` → 验证 "Session host listening" + 端点 401 + 校准仍在
    - 网关准入无需申请:校准通过 + 端点应答探测即自动列入(devnet 阶段此步未开放 = 当时零单根因)
3. **T3 反馈/赏金线(每日)** — 当日遇到的矿工/agent/faucet/网关/CLI 异常,先搜 `flop-labs/network` 同类,无则整理成可提交的 issue(公开信息、不带密钥)。依据:Hayes 11-20 — 测试网期 X/GitHub 有用反馈换主网 FLOP。

### S. 信号(每日)

4. **S1 测试网开放进度**(原 D15/C27)— 四个信号任一出现即上报:①**签名 Testnet 矿工包**(`flop.network/releases.json` 哈希、`docs.flop.network/docs/run-miner?network=testnet` 正文哈希);②**bot 兑付转正常**(`testnet.flopscan.io/api/accounts/5CcDr5BcVWGqdyk7EK3S43PPd4E1yTFHPMGjtjqvRLttgXtw` 的 txCount > 1);③**计分激活区块公布**(`llms.txt?network=testnet`、`docs/network-testnet`、`docs/testnet-and-timeline?network=testnet` 正文哈希);④测试网公共服务上线(`gateway` / `mailbox` / `explorer` / `faucet` 的 `.testnet.flop.network` DNS,目前均无;官方:gateway 与快照源 `snapshots.flop.network` await publication)。哨兵脚本:`$TEMP/flop_watch.sh`(正文哈希比对,空读数跳过;原 S7 的 Technocore 领水通道已并入此项:bot DID 与房间见 runbook)。
5. **S2 docs.flop.network**(原 C24)— `llms.txt` 页数 + **全量页面 `Last updated` 扫描**(页数不变内容也会改)。重点:**testnet 规则页、setup 页、agent-onboarding、testnet-and-timeline**。附 ask.flop.finance MCP(manifest 可当更新索引)。
6. **S3 工具链版本**(原 C28)— `flop.network/releases.json`(cli / miner-worker / miner-vllm-toploc + notices 段)+ npm `@flop-labs/*`(cli、sdk、client)latest diff。**附查:CLI 镜像的 testnet 档案是否已 pin**(`flop network status --network testnet` 的 `profile_status` 是否从 `planned` 变 `live`、`matches_expected` 是否为 true;11-25 仍未 pin)。SDK 需 ≥ 0.10.0 才接受 runtime 1014035。CLI 出新版 → T2 升级;npm 跳版 = 修复在路上的信号。
7. **S4 黄皮书决议号**(原 C30)— 抓 `flop.finance/intro/yellowpaper/` 正文最大 `D-0xxx` diff(页脚日期不可信)。**基线 2026-11-24:D-0547**(D-0547 Era-T 赛季长度可配置、修订空投快照窗口;D-0541 容量质押锚定 400,000 G_n/s per H100 — 这两条直接影响计分/质押,细读)。
8. **S5 flop-labs/network**(原 C31)— 新 issue 与官方回复 diff;对照我方异常;开闸首日必查。
9. **S6 X + 新闻**(原 D16/D17)— @flop_labs / @CryptoHayes;`flopnetworknews.com` 头条;**诈骗动向**(官方:开闸前不发链接;带 Solana 合约的转帖是假的)。
11. **S8 官网规则页正文哈希**(原 B7 改)— `flop.finance/testnet/`、`flop.finance/airdrop/`、`docs.flop.network/docs/official-links`。**页脚 `Updated` 日期不可信**(testnet 页已整页改写仍显示 2026-10-05)— 只认正文哈希。sitemap diff 降为周频并入 W1。

### W. 周频

12. **W1 官方站巡检**(合并原 A1/A2/A4/A5/A6/B8/B11)— teaser / intro 日期、首页 href、technocore `/config`、org 事件流、tc-chat open issues、分配数字一致性(35 亿 vs 44 亿历史漂移)、sitemap diff(B7 并入)。注意:页脚日期不可信,以正文为准。
13. **W2 黄皮书 issues + 托管 vs 镜像**(原 B9/B10)— `flop-labs/yellowpaper` 新 issue;托管页比镜像新,以托管页为准。
14. **W3 生态扫描**(原 C18)— GitHub 新仓库、`ecosystem-pulse.technocore.chat`(周报)、`gpus.flop.finance`(可租 GPU 行情)、机构入场动向(operator 配额申请)。
15. **W4 KV 笔记刷新**(原 C19)— 写 `did-a4/6f172335ff9660`;**7 天不写即被回收**(11-24 实测已过期,已用 `?if_absent=1` 重新认领)。建议每周固定刷。

### M. 月频 / 触发式

16. **M1 sonnet-2 领奖**(原 C22)— 主网开 claim:在 `mb-sonnet-2-registration` 签 `sonnet.claim.v1`(contest_id / request_id=`ballot-z6mk-20260917-2` / destination=`5ED4bNNK…QoZY`);我方 7 FLOP 在 `payouts.json` 在册。
17. **M2 KOL 排行榜**(原 C25)— **主网才开启**(官方 11-23);无需申请;出现即入驻(绑钱包 + X @HzzzJ87419)。
18. **M3 kibble**(原 C26)— 官方 0 提及、连续 5 周无产出,降为月频:只看官方是否提及或与 "certified work" 挂钩;不参与。
19. **M4 模型上传赞助(线索)** — `flop-labs/network` 的 `model-upload-sponsorship.yml`(testnet):官方可承担已批准模型的注册费 + 可退 DA 押金。触发条件:测试网注册表没有适配 8G 卡的模型、或我方矿工长期无流量 → 评估自己注册一个小模型。

**已归档(不再检查)**:验证者席位路径(原 C29 — 本机磁盘/网络不达标,不参选;换硬件才重启)、close-1 参赛(原 C23)、sonnet-2 赛事项(原 C12–14,9 月到期)、裁判监控(原 C20/C21)。

## 二、一次性动作(非每日)

| 动作 | 状态 |
|---|---|
| 提交 awesome-technocore PR | **❌ 作废(10-18)**:`flop-labs/awesome-technocore` 仓库已删除,PR #12 随之消失 |
| validator 意向表(`flop.finance/apply/validator`) | **✅ 已提交**(2026-09-15) |
| miner 意向表(`flop.finance/apply/miner`) | **✅ 已提交**(2026-10-08) |
| FLOP 收款地址 | **✅ 已完成(2026-10-19)**:`5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY`(SS58 prefix 42,Polkadot.js;加密 keystore 在 `E:lop`,已 gitignore;种子/密码用户自持)。用途:sonnet-2 claim、测试网 faucet、空投 destination |
| Devnet 矿工 | **✅ 2026-11-08 上线**:账户 `5FU6JExTpvUqraVgNni33RRF664PA6h67M3V8zsLWX38EQdS`,G_n cap 130;**官方 11-23:devnet 成果不继承测试网** |
| **测试网矿工重新加入** | **等官方发布签名 Testnet 矿工包**(11-25:sponsor 已 open、0/64,包仍 pending)。赞助席位条件:硬件 attested 或从申请名单准入(我方意向表 10-08 已交);推荐 16 GB+/卡,我方 8 GB 低于推荐 — 准入结果待观察 |发布后:专用 Testnet 账户 + 独立数据目录 → 注册 → sponsor → 校准 → 端点广告 → 网关准入。devnet 矿工继续单独跑,不继承 |
| **测试网 Agent 线首日** | **faucet 已切 Testnet(11-25),通道已公布但暂不领**:计分未开始、bot 16 小时只兑付 1 笔。开领后:凭 DID 在 `flop-testnet-faucet` 签名领水 → 推理消费 → 回执入库;此后每日(T1)。**passphrase 命令用户亲手跑** |
| **测试网计分激活区块** | **等官方公布**。此前一切活动记零、不补 — 不必抢跑;公布后按日执行 T1/T2 |
| **测试网期机器常开** | **待用户决策**:只算 inference served,关机 = 零。Claude 建议尽量常开;不自启则重启后说"新的一天"由 Claude 拉起 |
| sonnet-2 领奖(7 FLOP) | 主网 claim,见 M1 |
| KOL 排行榜入驻 | 主网才开启,见 M2 |
| close-2 启动预案 | 启动时改 `close1_trade.py` 的 `SEASON` 字符串 + 重跑注册/交易流程 |
| 模型上传赞助 | 线索,见 M4 |

## 三、维护协议(每次"新的一天"执行)

每次会话按顺序执行:**跑检查 → 维护清单 → 报告**。

### 1. 跑检查
每日执行 T1–T3、S1–S8,只记录**差异**与异常;无差异则一句话确认。W 组每周、M 组每月或触发时执行。

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

### 2026-11-25(续)— 深扫:官网测试网规则页改写;清单 19 → 18
- **新面**:`flop.finance/testnet/` 已整页改写为正式规则(阶段、角色、硬件、onboarding、计分口径、最低活跃门槛、四条公平规则),页脚日期未变(仍 2026-10-05)— 官网页脚日期不可信,改用正文哈希。`official-links`(11-24)新增 Public Testnet access 段。
- **对 agent 线的硬约束**:花到自己矿工的支出不计;同控钱包合并计分;每角色有最低活跃门槛(未公布)→ 写入 T1。
- FAQ(04:15 UTC 更新):SDK 0.10.0 才接受 runtime 1014035。CLI 镜像的 testnet 档案仍未 pin genesis → S3 加附查。
- **清单调整**:删 S7(Technocore 领水通道 — 已查清,并入 S1);S8 由 sitemap 改为官网规则页正文哈希;sitemap 并入 W1。计数 19 → 18。

### 2026-11-25 — 测试网 faucet 切到 Testnet;bot 兑付未跟上;矿工包仍待发
- `faucet.flop.network/chain` 报 `testnet`,公布 `technocoreBot`(房间 `flop-testnet-faucet`);限额与领水格式写入 runbook。
- 实测:1082 条请求 / 826 个 DID,faucet 签名账户仅 1 笔交易 — bot 未规模化兑付。**暂不领**(计分也未开始)。
- miner sponsor open(0/64、0/100),签名包未发布。
- 文档站新增 `?network=testnet` 视角(3 页);npm cli 0.8.2、sdk 0.10.0;releases.json 未变;黄皮书 D-0547 未变。
- S1 改为四个信号;哨兵脚本改为正文哈希比对。
- devnet 矿工栈重启后已拉起。

### 2026-11-24(续)— 测试网实为分阶段开放:当前 live, unscored
- 官方 07:00 UTC 未准点(06:46、08:20 两次承认延期);12:18 UTC 链起块;约 14:17 UTC docs 状态页改为《Testnet opening FAQ》。
- **只有 validator / RPC 团队能接入**;无 Testnet faucet、无 Testnet 矿工包;**计分未开始**(等公示激活区块,此前记零不补)。
- 我方"开闸日执行序"B/C 暂停,改为盯三个信号(S1 重写);一次性动作表两行改为"等发布",新增"计分激活区块"。
- 哨兵教训(三次误报/漏报):判定不能匹配 NXDOMAIN 响应里的 SOA `data`;空读数必须跳过;`grep -c` 空输入会输出 0;状态页措辞会整体更换,"Status: planned" 字符串消失不算瞬时失败 — 已改为**正文哈希比对**的脚本 `$TEMP/flop_watch.sh`。
- npm `@flop-labs/sdk@0.9.0`(allowlist 到 1014034,开网 runtime 1014035)。

### 2026-11-24 — 阶段换挡:清单重构为"测试网实战"模式(27 → 19 项)
- **触发**:官方 @flop_labs 确认测试网 11-24 07:00 UTC 开闸;规则变为"只算 agent 行为与 inference served"。
- **新增 T1(agent 线:每日领水 + 推理消费 + 证据)** — 这是空投的主要计分线,此前清单里没有对应日检项。
- **新增 T3(反馈/赏金线)** — Hayes:测试网期 X/GitHub 有用反馈换主网 FLOP。
- **合并降频**:A1/A2/A4/A5/A6 + B8/B11 → W1 周频(官网页面自 10-05 未动;org 事件被 network 仓库覆盖且烧 GitHub 限额);B9/B10 → W2;C26 kibble → M3 月频(官方 0 提及、连续 5 周无产出)。
- **触发式**:C22 → M1(主网);C25 KOL → M2(**官方 11-23:主网才开启**)。
- **删除/归档**:C12–14(9 月即到期,一直没清)、C23 close-1、C29 验证者路径(本机硬件不达标,不参选)。
- **改写**:D15/C27 → S1(改用 CLI 内置的真实测试网主机名:`testnet.flop.network`、`gateway.testnet.flop.network`、`faucet.testnet.flop.network` — 之前探测的 `rpc.testnet.*` 是错的主机名);C28 拆为 S3(版本)+ T2(运维);C31b → T2(加入"实际服务量"与网关准入机制);C30 → S4(**基线刷新:D-0539 → D-0547**,此前漏了 D-0540–0547)。
- **一次性动作表重写**:清掉过时的"Devnet 矿工邀请"行(早已完成);新增测试网矿工重新加入、Agent 线首日、机器常开决策、模型上传赞助线索。
- **同日修正**:KV 笔记已过期被回收 → 已用 `?if_absent=1` 重新认领并刷新。
- 计数:在跑 27 → **19 项**(T3 + S8 + W4 + M4)。

### 2026-11-03 — 深扫(邮件后):sponsor 端点已部署 + MCP 15 工具 + FRCR 页
- **faucet `POST /sponsor/miner` 已上线**(实测 400 "Missing 'address'" = 服务存在待参数)— 矿工质押请求通道就绪,等官方批准即可调用。
- **官方 MCP(mcp.flop.network/mcp)15 个工具**:health/balance/generate_secrets/check_htlc/trust_root/get_compute_channel/list_session_offers/list_settlements/list_swaps/indexer_query/get_stats/get_block/get_poui_leaderboard/check_session/verify_tee_quote — 只读为主,信息面比 docs 更细。
- 网关 20 → 21 路径(新增 `/keys/me/receipts/{request_id}` 单回执查询)。
- explorer `/markets` 200(Compute Market / FRCR 仪表盘,邮件首披露);API 路径暂无(/api/markets 404)。
- docs 38 页不变(run-miner 11-02 仍是最新)。
- 计数:26 项不变。

### 2026-11-24 — 开闸日:官方确认 07:00 UTC 上线
- 官方 @flop_labs(11-23):testnet **11-24 07:00 UTC** 上线。Agent 无审批、凭 DID 每日领水、花在推理上才算分;矿工赞助质押、首日排队校准;**devnet 不继承须重新加入**;只算 inference served(不算 uptime);KOL 计划改在主网开启(C25 触发条件更新);07:00 UTC 前任何 setup 链接均非官方。
- 网关准入机制查清:校准通过 + 端点应答探测即自动列入(devnet 阶段未开放 = 零单根因)。
- 执行序写入 runbook「开闸日执行序」。

### 2026-11-14 — 测试网目标日公布:2026-11-24
- **官方口径(新页 agent-onboarding,11-14)**:public testnet targeted **2026-11-24**,subject to readiness;devnet 活动不赚空投;**空投只认测试网合格已结算推理消费**。
- faucet linked 层:500 基础 / 单笔至多 2000 / 滚动 7 天 2000 / 24h 冷却;Self/BrightID 同层无乘数。
- **离线损失实锤**:04:04 UTC 有 channel 指向我们时机器离线(错失)。→ 测试网期须 7×24 挂机;与用户确认开机策略(当前用户拍板不自启,需重新评估)。
- docs 38→39(+agent-onboarding);devnet agents 16,217;#238 仍开;price_sources 21 无我们。

### 2026-11-08 — 矿工上线日(本机 devnet miner 全绿)+ 新增 C31b
- **矿工栈完整上线**:sponsor settled → 校准 G_n=130 GFLOP/s → backend(8G 显存调参:util 0.4 + MAX_MODEL_LEN 4096 + expandable_segments)→ 隧道端点 401 活 → 端点广告发布 mailbox。
- **新增 C31b(矿工运维日检,每日)**:容器/端点/版本/注册表/paid-sessions 信号五查。
- 一次性动作:接入条目闭环 ✅;新增"开机自启脚本"待办。
- 环境大事记:Docker 数据迁 D 盘(C 盘救回);cloudflared 走官方 apt 源;quick tunnel 域名随重启轮换(待脚本固化)。
- 计数:26 → 27 项。

### 2026-11-07 — 深扫:faucet /limits 全队列端点 + sponsor 实况
- **新端点 `faucet.flop.network/limits`**:miner sponsor **automatic_full**(未校准 40/40 满;配额已提至 100 新赞助/日,今日用 28;stake 预算 200M/日用 36M)→ #73 获批也暂挤不进,等清位;**validator sponsor open**(0/100 用,150M 预算)— 验证者线随时可赞助(本机硬件不达标,仅记录)。agent 领水粒度 2 FLOP/日。
- miner-worker 镜像 0.1.238 → **0.1.286**;新 pack `miner-pack-devnet-ts-20261106`。
- YP **D-0539**(DA 纠删码 R=6/k=3 + serve-or-slash 规范)。
- run-validator 11-06 更新。C28 增 /limits 检查。
- 计数:26 项不变。

### 2026-11-03 — 官方邮件:Devnet 公开 + 测试网无日期 + 矿工邀请通道
- **官方邮件(Shu,用户转发)落地三大信息**:①Devnet 公开(explorer/faucet/API/MCP/SDK 可用);②**测试网日期取消**("haven't set a testnet date yet",11-03 目标作废,等 devnet 稳定后公布);③**矿工/验证者卡住可回复邮件求助** — 即事实上的邀请申请通道;KOL 无需申请,推荐链接 soon;GPU 租赁 20+ 卡可引荐机构数据中心。
- **run-miner 11-02 版新增 "Join the devnet"**:10-30 起公共端点(wss://rpc.devnet.flop.network、mailbox.devnet.flop.network、faucet POST /sponsor/miner);**仍需 operator 逐户批准**;限额:10 新矿工/24h、20M FLOP/24h、新矿工 ~1M FLOP sponsor 质押;**paid sessions 未开放**(DA 与网关准入收尾中)。
- 一次性动作:新增"Devnet 矿工邀请"(**用户发邮件,草稿已备**);KOL 条目更新。
- 附:mcp.flop.network/mcp 已可用(flop_health/balance 等只读工具);网关自注册(enroll)仍 404 — agent 走 CLI 直连或等网关开放。

### 2026-11-02 — 深扫 + 清单修剪(27 → 26)
- **新增发现:`flop.finance/official/` 页面**(sitemap 首次收录)— 官方链接/账号/邮箱的全集 + "尚无代币"警告,与 docs `official-links` 同源。开闸前的防骗装甲,又一前兆。
- **修剪**(用户要求审查过时项):
  - **删 C20**(裁判行为监控):裁判停摆 6 周,`d-sonnet-2-results` 环形已滚空(实测 0 条),对象不存在。
  - **C21 并入 C22**:sonnet 仓库最后 push 09-23,结果已发布、申诉结案;C22 本就是"待主网"档,合并后月频。
  - **B11 降周频**:分配表两页 10-05 后未动。
- 其余保留:开闸窗口期,A/D/C24-31 全部高信息密度。
- 计数:27 → 26 项。

### 2026-11-01 — 新官方仓库 network(一线 triage)+ devnet 首批 agent 出现
- **新增 C31(flop-labs/network 每日跟踪)**:官方反馈仓库(10-30 建,Hayes 分享)。已知要点:#3 确认 **devnet miner preview 仍 invite-only、官方联系方式 TODO**(表单后无下一步);#7 devnet settle 实付 99%+1% 非 85/15;#8 devnet faucet 曾被索引器卡死 503;#9 faucet UI 的 RPC 主机名是死的;#11 SDK README 的 specVersion 列表过时。**开闸首日必查此仓库**。
- **devnet 首批外部 agent 出现**:activeAgents 0 → **9**,accounts 64 → 98(块高 2.54M)。
- 其他无变化:docs 38 页、11-03 目标日不变、releases.json 不变(0.1.239/0.1.238)、YP D-0537、faucet 仅 devnet、网关自注册仍关、mailbox.devnet 仍 404。
- 计数:26 → 27 项。

### 2026-10-31 — 开闸前加速:矿工镜像跳版 + sdk-references 页 + FCU 决议
- **releases.json 矿工镜像跳版**(10-30/31):miner-vllm-toploc → 0.1.239、miner-worker → 0.1.238(cli 仍 0.1.220)。测试网前最后集成迹象。
- **docs 37 → 38 页**:新增 `sdk-references`(10-30,六包清单 + 选型;**官方明示未发布 Rust/Go/agent-SDK — 同名公开包皆为假**)。
- 大批页面 10-30 改版;**11-03 目标日不变**,确认节奏 "as devnet onboarding completes"。
- **YP D-0534..D-0537**:FCU(算力期货/预订)规范细化 — booking horizon、payment rules、consolidated FCU。测试网不含,仅跟踪。
- explorer /api 恢复(502 三天后);块高 2.50M,tps 0,avgBlockTime 1000ms。
- C30 基线:D-0533 → **D-0537**。
- 计数:26 项不变。

### 2026-10-30 — 深扫:C24 日期清单不全;protocol-parameters 10-26 改版载明活参数
- 漏检修正:agent-integration / protocol-parameters / run-validator 三页 **10-26 改版**,原 C24 只盯 12 个 FAQ 页未覆盖。C24 改为全量 37 页日期扫描(ask MCP manifest 可作更新索引)。
- **protocol-parameters 现有活参数**(10-26):矿工容量保证金**实测含义 7,560 FLOP/校准 GFLOP·s⁻¹**(604,800 块撤销窗 ×1.25 surge 后);基础自 stake 10,000 FLOP;审计率 2.5%;挑战窗 ~7 天;响应时限 2 小时(沉默=判欺诈);争议押金 100 FLOP;开发者补贴 16/块(8+8,五纪元后停)。
- agent-integration 10-26:内联写明 3:1 解锁 + 社区质押池(D-0530 口径统一)。
- explorer /api 五种路径全 502(索引后端故障第三天);ask corpus 37 概念与 docs 同步。
- 计数:26 项不变。

### 2026-10-29 — 深扫:官方 npm/PyPI 包全部首发(工具链公开)
- **五个官方 npm 包今日发布**:`@flop-labs/sdk@0.4.0`、`cli@0.4.0`(bin `flop`)、`client@0.2.1`、`contracts@0.1.1`、`pi@0.3.1`;PyPI `flop-sdk@0.2.0`。maintainer **svidyuk(CTO Sergey Vidyuk)**,repo `flop-labs/flop-core` — 正版。
- 与 `upgrade` 页候选版本表逐项吻合 → 版本已从"待发布"转"已发布"。**devnet 公开/测试网开闸的最强前置信号**。
- CLI deps:`@polkadot/api`(Substrate 栈,与 ss58=42 一致)。
- 动作:本地安装 CLI 抓取 `flop --help` 命令面,补全 agent runbook(测试网首日直接可用)。
- 其他:CT 无新子域;`/runbooks`、`/knowledge/*` 404;upgrade 页含 hybrid 加载器/控制器细节(与我们 SOFT 单卡线无关)。
- C28 扩容:npm/PyPI 版本检查。

### 2026-10-29 — 开闸倒计时状态:工具链就位,devnet 将公开
- **Hayes 10-26:devnet "coming days" 内对所有人开放**(miner/validator/agent 三角色)。今日 network-devnet 页仍 "administrator-reviewed",未开。**开放即触发:矿工预演**(devnet 无空投权重,价值=测试网首日机器就绪)。
- **官方镜像版本表上线:`flop.network/releases.json`** — cli / miner-worker / miner-vllm-toploc 均 v0.1.220(GHCR 带 SHA256,minimum 0.1.172)。**加入 C28 每日检查**。
- **docs 34 → 37 页**:新 `upgrade`(10-26,升级手册 + 候选包版本:sdk@0.4.0/cli@0.4.0/contracts@0.1.1 等)、`send-to-specific-miner`(10-20,**agent 直连会话 CLI 完整命令**,含 `--new-wallet` 自动领水)、`official-links`(10-23,官方账号全集;**无官方 Discord/Telegram/Reddit/Medium**;唯一邮箱 security@flop.finance)。
- **airdrop-and-testnet-conversion 更新 10-26**:agent 3:1 解锁已写明(与黄皮书 R8.7 一致,#178 矛盾解决)。
- **C30 基线:D-0531 → D-0533**(新增两条决议编号,正文未渲染详情)。
- 观察:explorer `/api/*` 今日 502(索引后端故障,RPC 正常);新骗局:Robinhood Chain 假 "Flop Labs" 代币。
- 计数:26 → 27 项(releases.json 并入 C28 不新增编号;实为 C24/C28/C30 扩容)。

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
