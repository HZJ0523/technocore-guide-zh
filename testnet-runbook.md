# FLOP 测试网首日作战手册

> 目标:faucet 开闸后第一小时内完成领水 → 确认 → 首笔推理消费 → 证据留痕。
> 前提:DID `did:key:z6MksWUe7FV2x68VRerNQFkjSzv8KRrTp212wRTnqP1FE7Ty`(identity.pem 在 E:\flop\technocore-did-starter\,passphrase 用户持有)。
> 路线:agent(领水消费推理,池 12 亿,3:1 消费解锁)。不做矿工/验证者。

## 开闸公告要点(官方 @flop_labs,2026-11-23 08:07 UTC;开闸 2026-11-24 07:00 UTC = 北京 15:00)

- **Agent**:无审批、无等待名单。agent **每天**从 faucet 领测试网 $FLOP("in Technocore chat or with one API call" — 即凭 Technocore DID 或 API 调用),花在推理上。**空投按 agent 在测试网上的行为计量,攒着不花的 faucet 币=零**
- **矿工/验证者**:质押由网络赞助,无需持有 $FLOP。矿工名额不设上限,但首日**排队、按序校准**(为稳定性限流)
- **Devnet 成果不继承,必须重新加入**(全新 genesis:重新 sponsor、重新校准)
- 验证者 14 天宽限期,主网排名两周后才开始
- **"Uptime on its own is not counted toward rewards. Inference served is what counts."**(11-22 官方回复)— 只算实际服务的推理
- KOL 计划在**主网**才开启
- 网关准入(run-miner 原文):无需申请 — 校准被接受 + 端点能应答网关探测 → 自动从签名端点广告列出(devnet 阶段该步未开放 = 我们零单的原因)
- **测试网链身份(2026-11-24 12:23 UTC 公共 RPC 实测)**:`FLOP Testnet`;genesis `0x918abd58fb16306b30ef3886514cfaebffecb4de43e82b6f8ec4795c43cfd800`;runtime `flop-testnet` spec **1014035**(impl `zkv-node`,node `1.1.0-00000000000`);RPC `wss://testnet.flop.network`(WebSocket 握手 101;HTTPS POST 也可)。链约 12:18 UTC 起块(12:23 时块高 273),peers 8。`system_account` 未对公共 RPC 开放。
- **开闸顺序(实测)**:先起链(RPC)→ 再上 faucet / gateway / explorer / mailbox → 再发 setup 页。12:23 UTC 时后两步尚未发生。
- 开闸前不发任何链接:07:00 UTC 前任何"testnet setup / airdrop checker"链接均非官方;X 上带 Solana 合约地址的转帖是假的
- 线索:network 仓库 11-23 新增 **testnet 模型上传赞助表**(官方可承担已批准模型上传的注册费 + 可退 DA 押金)— 8G 卡上线索

## 测试网开放实况(官方《Testnet opening FAQ》,docs network-testnet,2026-11-24 更新)

- **状态:`testnet · next · live, unscored`**。6 个创世验证者于 2026-11-24 启动 FLOP Testnet;可看 FLOPScan、查公共 RPC、注册 validator / RPC 团队。**早期网络不计分**;测试 FLOP 无价值;可能停机、升级、重置。
- 链身份:chain id `flop_testnet`;RPC `wss://testnet.flop.network/`;genesis `0x918abd58fb16306b30ef3886514cfaebffecb4de43e82b6f8ec4795c43cfd800`(与 12:23 UTC 实测一致);bootnodes `boot-eu-1.testnet.flop.network`、`boot-sg-1.testnet.flop.network`;raw spec `flop_testnet-918abd58fb16306b.raw.json`,SHA-256 `485ecb44635609ab261ea3002c3c9fdc7a5dab38caf28a86f654cadf443893be`;签名 spec 与节点套件待发布。
- **计分开始时间:"Earning begins at the publicly announced finalized activation block of a future tested runtime upgrade. There is no announced block or date yet. Earlier activity earns zero, with no backfill."** voucher 交易、订单、swap 仍禁用。
- **矿工**:须在 Testnet 重新注册;devnet 的注册、质押、赞助、校准、工作历史都不继承;devnet 矿工可继续单独运行;准备**专用 Testnet 账户 + 独立数据目录**;**本次开放没有公开的 Testnet 矿工包,也没有 devnet→testnet 升级命令**;等 Operator Hub 列出签名的 Testnet 包和安装说明后,再安装、签名、开工。
- **Faucet**:Testnet 本次开放没有已验证的 Self 通道;通用 faucet 在开放检查时仍报 Devnet — **领水前先比对 genesis**。
- **SDK**:`@flop-labs/sdk@0.9.0`,已发布的 runtime allowlist 到 1014034,开网 runtime 是 1014035 → 保持兼容性检查开启,公共 RPC 只做读。模型 API 列的是共享网关上的模型,"listing 不代表 Testnet 挖矿或结算已开放"。
- 相关地址:FLOPScan `https://testnet.flopscan.io`;Operator Hub `https://docs.flop.network/operators?network=testnet`;签名资产 `https://github.com/flop-labs/network/releases`。
- **我方结论(2026-11-24 15:00 UTC)**:下节"开闸日执行序"的 B(agent 领水消费)、C(矿工重新加入)**现在都不具备条件**,也不产生任何计分。改为等三个信号:①Operator Hub / releases 列出签名 Testnet 矿工包;②faucet 链身份切到 Testnet(或 agent 领水通道开放);③**计分激活区块公布**。

## 测试网正式规则(`flop.finance/testnet/`,2026-11-25 读;页脚仍写 Updated 2026-10-05,不可信)

- **阶段**:Unscored opening(11-24,6 个创世验证者)→ **Scored phase(planned,最长约 90 天;治理可提前结束,奖池规模不变)** → Snapshot(在公示的 finalized 块高冻结,之后不计,无滚动快照)→ Review(公示完整分配表与哈希,可申诉)→ Genesis(Q1 2027;只带分配,不迁移链状态)。
- **"We'll be activating features over the coming hours."**;预期停机、runtime 升级、**历史与余额可能重置**。
- **计分**:Miners — 通过验证的算力;Validators — 测试网排名;**Agents — 已结算会话中购买的算力**。持有代币不计。**每个角色有最低活跃门槛,低于门槛无分配**(门槛数值未公布)。
- **四条公平规则(直接影响我方 agent 线)**:
  1. One participant, one score — 同控钱包按一个参与者计,拆账户不加分配。
  2. **Independent demand only — 花到同控矿工的支出、同控钱包间循环,不计为需求。→ 我们的 agent 绝不能买我们自己矿工的推理,必须选独立矿工。**
  3. Fraud forfeits — 被判定刷量即没收(可在 review 窗口申诉)。
  4. 安全披露 — 私下报给 security@flop.finance 可获奖励;利用漏洞则取消资格。
- **赞助矿工席位条件:硬件被 attested,或运营者从申请名单准入**(我方 miner 意向表 10-08 已交)。推荐规格 **每卡 16 GB+ VRAM**(我方 8 GB,低于推荐;"recommended specifications and subject to refinement")。
- Agent 也可"与 technocore.chat 上的其他 agent 交易",但空投只认已结算会话购买的算力。
- 验证者前 50 席注册已开;推荐 8+ 核 / 64 GB / 4 TB NVMe / 1 Gbps。
- SDK:**`@flop-labs/sdk@0.10.0` 是第一个 allowlist 接受开网 runtime 1014035 的版本;0.9.0 及更早拒绝**。
- 官方链接页(11-24):测试网网关 `https://gateway.testnet.flop.network` 与快照源 `https://snapshots.flop.network/testnet/archive/latest.json` **await publication**;"Testnet Self and TechnoCore claims await an announced, finalized grant on the Testnet…" — Technocore 领水尚未正式开放(与实测 bot 仅兑付 1 笔一致)。**11-26 更新**:网关 URL 已正式公布("The Testnet inference gateway is https://gateway.testnet.flop.network");快照源仍 await。
- Docker CLI 镜像(cli:stable 0.1.455):testnet 档案仍 `profile_status: planned`、`genesis_policy: pin-before-live`、`matches_expected: null` — CLI 镜像待更新。


## 官方 Agent Guide 与领水定论(2026-11-26)

来源:`https://flop.network/llms.txt`(《FLOP Network Agent Guide》;FAQ 里 "the agent guide" 指的就是它)。

- **领水格式(官方原文要点)**:用收款钱包自己的密钥,对 UTF-8 文本 `flop-faucet-agent/v1|<genesis hash>|<address>|<nonce>` 签名;`nonce` 是不超过 19 位的十进制。`POST https://faucet.flop.network/v1/testnet/agent-claims`,JSON 为 `{"address": "<address>", "nonce": "<nonce>", "signature": "0x<hex signature>"}` — **`nonce` 是字符串**。同一 nonce 重发返回同一笔交易,不会付两次;上一次有最终结果后才用新 nonce。
- **不需要 Technocore 房间那一步**:官方 — "claims in the TechnoCore room flop-testnet-faucet are not open yet"。房间里的 bot 会发挑战串,但那条通道未开放。
- **之前全部 401 的原因**:我把 `nonce` 作为数字发送。faucet 对任何无效 claim 都回同一句 `401 claim_signature_invalid`,所以无法从报错判断。11-26 用临时钱包实测:字符串 nonce 得到 `429 daily_cap`(过了签名校验),数字 nonce 得到 401。
- **领水不产生空投**:官方 — "a faucet grant earns no airdrop credit"。每钱包滚动 24 小时 10 FLOP。
- **官方 CLI 已支持**:`@flop-labs/cli` 0.9.0 的 `flop --network testnet --keystore <json> --password-env <VAR> faucet request [address] [--nonce <n>] [--json]`,发送前先查 faucet 状态。装在 `E:{BS}flop{BS}cli`(独立依赖树;与备用脚本的 keyring 13 混装会让 CLI 直接退出)。
- **我方工具**:一键 `powershell -NoProfile -ExecutionPolicy Bypass -File E:{BS}flop{BS}flop_faucet_claim.ps1`(掩码输入钱包导出密码,调官方 CLI;默认 keystore `agent-keystore.json`)。**`-Wait` 模式**:输一次密码后每 3 s 轮询 `faucet.status`,`open` 即提交,窗口只开几十秒也抓得住(密码在 `FLOP_PW` 环境变量里留到等待结束,默认 30 分钟,`-WaitMinutes` 可调)。PS 5.1 会把 CLI 写到 stderr 的 JSON 当 `NativeCommandError`,脚本已在调用处局部放开 `ErrorActionPreference`;输出里带一行 `node.exe : {` 噪声属正常。备用 `flop_faucet_claim.mjs`(直接 POST 官方文档格式,需 `@polkadot/keyring` 13.x)。
- **keystore**:10-29 导出的旧文件密码已不可用;11-25 重新导出为 `agent-keystore.json`(新密码,用户持有)。旧文件保留未删。
- **11-26 02:37 UTC 实况**:`faucet.status = daily_cap_reached`(滚动 24 小时 1000 万 FLOP 已领完,`retryAfterSeconds` 3600)— 等状态变 `open` 再领。
- **✅ 11-26 ~06:03 UTC 领到 10 FLOP(演练)**:open 窗口只有几十秒,`flop_faucet_claim.ps1 -Wait` 输一次密码后 3 s 轮询、open 即提交,`5ED4bNNK…QoZY` 到账(testnet-reader:`balance 1e19`、`liveBalance true`、txCount 0 即入账转账)。faucet 签名账户当日 txCount 1 → 6245 = 官方开始批量兑付。随后同 IP 再试 → `429 ip_cooldown`(`retry_after_seconds 86271`)→ **同一 IP 领到一次冷却 24 小时**,下次 11-27 06:05 UTC。领水不计空投;测试网推理仍未开放,暂时无处可花。
- **同一份指南的其它要点**:Testnet 目前 "no Testnet gateway and no registered Testnet model or miner, so Testnet inference does not work yet";`api.flop.network` 与 `mcp.flop.network` 服务的是 Devnet(Devnet 活动不计分)。Devnet 网关注册流程:钱包至少 1 FLOP → `GET /v1/enroll/wallet/challenge?address=` → 用 sr25519 签 `message` → `POST /v1/enroll/wallet {address, message, signature}` 得 `{key, model, remaining_quota, expires_at}`。矿工安装 skill 需运营方发的包:`https://flop.network/skills/flop-miner-devnet/SKILL.md`。
- **部署观察**:`gateway.testnet.flop.network` 已上线(FLOP REST Gateway 2.0.0,image 0.1.480),`/health` 为 `error`、`connected: false`,`/v1/models` 为空 — 已部署未开放。`mailbox.testnet.flop.network` 返回 404。FLOPScan:6 个验证者、2,131 账户、1,520 个 active agents。**11-26 06:0x UTC 复查**:image 0.1.497,gateway 刚重启(uptime ~34 min),仍 `error`/`connected:false`,依赖 `catalog: no_live_offers`,models 0 条。

## 测试网开放进展(2026-11-25 04:10 UTC 实测)

状态仍 `live, unscored`。**计分未开始**:官方 — earning 自未来一次升级的公示 finalized activation block 起算,未公布区块或日期;此前活动记零、不补。

### Faucet 已切到 Testnet

- `faucet.flop.network/chain`:`network: testnet`,`chain: FLOP Testnet`,genesis 与链一致,`ss58Format 42`,`decimals 18`,`rpc wss://testnet.flop.network`;**`technocoreBot: {did: did:key:z6MktjwdcBkwC6xo9wi4KY4ckWvn1GQHdQ1qzkaZtWqHAoxs, room: flop-testnet-faucet}`**。
- `/limits` 限额:`status open`,签名账户 `5CcDr5BcVWGqdyk7EK3S43PPd4E1yTFHPMGjtjqvRLttgXtw`,日上限 10,000,000;anonymous 25 FLOP/地址、冷却 86400 秒;linked 基础 500、单笔上限 2000、滚动 7 天 2000、身份冷却 86400 秒;**agent 每笔 10 FLOP,`claimPath /v1/testnet/agent-claims`,滚动 24 小时上限 10,冷却 86400 秒,`rolloverRequiresSpend: true`**;每 IP 每日 3 次、每 IP 段每日 20 次。
- **Technocore 领水格式**(房间实测):向 `flop-testnet-faucet` 发**签名消息**,正文 `!faucet request <SS58 地址> <nonce>`,正文里的 nonce 与消息 nonce 相同(毫秒时间戳);签名规则同标准 Technocore(`flop-testnet-faucet|<nonce>|<text>`)。另有 `!faucet status`、`!faucet help`。
- **我方命令(用户亲手跑,需 passphrase;PowerShell)**:

  ```powershell
  cd E:\flop\technocore-did-starter
  $n = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
  .\.venv\Scripts\python.exe technocore_agent.py say flop-testnet-faucet "!faucet request 5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY $n" --nonce $n
  ```

- **完整流程是两步**(bot 回复实测,seq 4164):
  1. 房间发签名消息 `!faucet request <SS58> <nonce>`(上面的命令)。bot 回复一条挑战串 `flop-faucet-agent/v1|<genesis>|<SS58>|<nonce>`。
  2. 用**钱包账户密钥**对挑战串的 UTF-8 字节做 sr25519 签名,私下 `POST {"address","nonce","signature":"<0x-hex>"}` 到 `https://faucet.flop.network/v1/testnet/agent-claims`。签名不要发到房间里。

  第 2 步的本地工具(官方 CLI/SDK 无现成命令):`E:\flop\flop_faucet_claim.mjs` + 包装脚本 `flop_faucet_claim.ps1`(PowerShell 掩码输入口令,经 UTF-8 管道传给 Node)。**依赖必须固定在 `@polkadot/keyring` 13.x + `@polkadot/wasm-crypto`(libsodium)**:11-25 实测,`@polkadot/keyring` 14.x 用 `@scure/sr25519` 生成的签名被 faucet 拒绝(`HTTP 401 claim_signature_invalid: "Sign the D10 versioned claim with the recipient key"`);换回 13.5.9 后同一 keystore 路径的签名能通过 libsodium 的 `sr25519Verify`。安装:`npm install --prefix E:\flop @polkadot/keyring@13 @polkadot/util-crypto@13`。

  ```powershell
  # 先只验口令(不发送):预期输出 signed challenge (150 bytes); not sent
  powershell -NoProfile -ExecutionPolicy Bypass -File E:\flop\flop_faucet_claim.ps1 -Nonce <nonce> -NoPost
  # 去掉 -NoPost 即发送;预期 HTTP 200
  ```

- **口令输错排查(11-25)**:脚本报 `wrong keystore password` = 输入的 bytes 与 keystore 不匹配。已核实 Polkadot 库各版本对口令都无规范化差异,解码路径标准;可能原因是口令记错(应使用 10-29 在 Polkadot.js 扩展导出账户时设的密码,不是 DID 口令、也不是矿工 keystore 密码)或终端 raw 模式读输入被弄乱(因此改用包装脚本)。仍不对 → 在 Polkadot.js 重新导出到 `E:\flop\agent-keystore.json`(新密码,只用字母数字),加 `-Keystore E:\flop\agent-keystore.json`。
- **兑付实况(04:10 UTC)**:房间自 11-24 12:24 起 1136 条,其中 1082 条请求、826 个不同 DID;bot 在房间内零回复;faucet 签名账户 nonce 1、txCount 1、余额 999,989.997 — **只兑付过 1 笔(10 FLOP)**。`/v1/testnet/agent-claims` 在 `api.flop.network` 与 faucet 主机均 404(测试网网关未部署)。
- **结论**:通道已公布但未规模化兑付,计分也未开始 — **暂不领取**。等两项:bot 稳定兑付(看签名账户 txCount 增长)、激活区块公布。

### 矿工

- testnet miner sponsor `status: open`,签名账户 `5E9jfrPrvQJvkjoSGLTdeqmqWHvAgxyGyTNW8VqtCUtgVcnb`,余额 2,000,000,容量 used 0 / max 64,每日新赞助 0/100,质押预算 10,000,000/日。
- **签名矿工包未发布**(Operator Hub:"The signed operator kits are pending publication")— 等包。devnet 矿工继续单独跑。

### 测试网视角的文档与浏览器

- 文档站支持 `?network=testnet`:`llms.txt?network=testnet` 仅 3 页(Testnet opening FAQ、Testnet miner onboarding、FLOP Testnet);另有 `operators?network=testnet`、`monitor?network=testnet`、`networks/testnet`。
- FLOPScan:`https://testnet.flopscan.io`,`/api/accounts/<地址>`、`/api/stats`(有限流)。链上 6 个验证者;我方钱包与 devnet 矿工账户在测试网余额均为 0。

## 开闸日执行序(更新于 2026-11-24)

**A. 确认开闸**(只认 @flop_labs / flop.finance / docs.flop.network):testnet status 页、setup 页、explorer 上线 → 核对链接
**B. Agent 线(最优先 — 不受矿工排队影响,且直接计分)**
1. 读 setup 页:faucet 领水的确切形态(Technocore 聊天室房间名/消息格式,或 API)
2. 用现有 DID(`z6MksWUe7FV2x68…`,自 08-25 有完整记录)领水 — 需 passphrase,**用户亲手跑**
3. 按官方指引做推理消费;保存每笔回执(receipt / tx / channel)
4. 以后每天领 + 花;记录到 technocore-evidence.json
**C. 矿工线(重新加入)**
1. 下载 testnet pack(sha256 校验)→ 建/沿用矿工账户 → `sponsor.sh` → 排队校准
2. 隧道端点 401 → announce 在发 → 等网关准入(校准通过后自动)
3. 用 `explorer /api/compute-channels?miner=<地址>` 与网关 price_sources 验证是否被列入
**D. 证据 + 反馈**:每日异常整理成 issue(Hayes:测试网期 X/GitHub 有用反馈换主网 FLOP)

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
