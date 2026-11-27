// Diagnostic: sign+submit a plain transfer with the agent keystore and report the
// result, to separate account-level signature failures from pallet-level ones.
const { ApiPromise, WsProvider, Keyring } = require('@polkadot/api');
const fs = require('fs');

(async () => {
  const pw = process.env.FLOP_PW || '';
  const api = await ApiPromise.create({ provider: new WsProvider('wss://testnet.flop.network'), noInitWarn: true });
  const kr = new Keyring({ type: 'sr25519', ss58Format: 42 });
  const pair = kr.addFromJson(JSON.parse(fs.readFileSync('E:/flop/agent-keystore.json', 'utf8')));
  if (typeof pair.decodePw === 'function') pair.decodePw(pw);
  else if (typeof pair.unlock === 'function') pair.unlock(pw);
  console.log('addr', pair.address);
  const tx = api.tx.balances.transferKeepAlive('5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty', 1000000);
  let done = false;
  await tx.signAndSend(pair, ({ status, isError, events }) => {
    if (isError) { console.log('TX ERROR', JSON.stringify(status.toHuman())); done = true; }
    if (status.isInBlock) { console.log('inblock', status.asInBlock.toString()); done = true; }
    if (status.isFinalized) { console.log('finalized', status.asFinalized.toString()); }
  });
  console.log('submitted');
  await new Promise((r) => setTimeout(r, 12000));
  await api.disconnect();
})().catch((e) => { console.error('ERR', e.message); process.exit(1); });
