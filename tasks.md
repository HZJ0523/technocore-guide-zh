# FLOP / Technocore 每日任务清单与维护协议

> 版本:2026-09-17(21 项)。本文件由 Claude 在"新的一天"会话中自动维护。
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

### C2. 赛后(新增,至领奖窗口关闭)

22. **结果与领奖跟踪** — `d-sonnet-2-results` 与 `d-sonnet-2-rules`:查最终计票、胜者、我方 ballot 是否计入。若胜者为我方所投且 ballot 计入 → 按规则签名 `sonnet.claim.v1`(含 `contest_id`/`request_id`/`destination`)至注册室。**依赖:需要 FLOP 收款地址(格式待官方公布)** — 同时是未来空投的必需品,列入一次性动作。

### D. 外部(3)

15. **子域名探测** — `faucet.technocore.chat`、`testnet.technocore.chat`、`claim.technocore.chat`(模式已证:`tclk.technocore.chat`、`mcp.technocore.chat` 存在)。
16. **X 搜索** — 域限 `x.com` 搜 @flop_labs / @CryptoHayes 近期发帖。
17. **新闻搜索** — `Flop Labs FLOP testnet announcement`,近一日。

### E. 生态(1,周频)

18. **生态扫描** — GitHub 搜 `technocore OR flop` 新仓库:同行贡献(竞争)与新监控工具。

### F. 维护(1,≤每周)

19. **KV 笔记刷新** — 写 `did-a4/6f172335ff9660`(7 天不写过期)。

### G. 告警(1)

20. **裁判行为突变监控** — `d-sonnet-2-rules` 状态计数:rejected/unevidenced 比率异常(sample: 09-16 rejected 31,796 超 accepted 15,200)时显式告警。关联 C12:重发后仍无回执 + rejected 激增 → 判定可能被拒,改查裁判 refusal 消息。

21. **sonnet-challenge issue 跟踪器** — `flop-labs/technocore-sonnet-challenge/issues` 新 issue 与回复。**赛事期间每日**;09-18 后周频。理由:该跟踪器是裁判行为/规则澄清/修复的最高信号源 — 09-17 的突破(issue #23 揭示身份索引 ≥6 条大小截断)即出自此;我方申诉 #64 的回复也在其中。

## 二、一次性动作(非每日)

| 动作 | 状态 |
|---|---|
| 提交 awesome-technocore PR | **✅ 已开 PR #12**(2026-09-15,+1/-0,open 待维护者合并) |
| 填 validator 意向表(`flop.finance/apply/validator`) | **✅ 已提交**(2026-09-15,含硬件现状与升级意向) |
| 测试网开闸首日跑 `testnet-runbook.md` | 条件触发 |
| **准备 FLOP 收款地址** | 待办:领 sonnet 奖与未来空投都需 destination 地址;官方尚未公布格式,公布后立即准备 |

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

### 2026-09-14 — 建立
- 清单定稿 19 项(A6/B5/C3/D3/E1/F1),来源:本日九轮全盘复查。
- 一次性动作 3 项登记。
- 维护协议确立(淘汰/新增/校准/深扫/报告)。

### 2026-09-14 — 修订 C12
- 理由:实测注册室环形窗口约 2.4 万条、吞吐 3–13 条/秒;我方注册消息 2 小时内即滚出窗口,而裁判 intake 游标推进仅 0.6–1.3 条/秒。加入"逾 24 小时无回执则重发同一 request_id"的预案(官方口径允许,勿换新 ID)。

### 2026-09-15 — C12 预案执行
- 24 小时无回执,同 request_id `reg-voter-z6mk-20260914` 重发成功(新 seq 767399,generation 1 — 房间已换代)。继续追踪回执。

### 2026-09-16 — 新增 C20
- 理由:裁判状态首次出现行为突变 — rejected(31,796)超过 accepted(15,200),并新增 `unchanged` 计数。此信号直接关系我方注册是否被拒;独立成项以显式告警。
- 关联 C12:重发后仍无回执 + rejected 激增 → 判定可能被拒,届时改查裁判 refusal 消息取证。
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
