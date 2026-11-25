#!/usr/bin/env node
// FLOP Testnet agent-faucet claim, step 2.
//
// Step 1 is a signed Technocore message in room flop-testnet-faucet:
//     !faucet request <SS58 address> <nonce>
// The official faucet bot replies with a challenge string. This script signs
// that challenge with the wallet keystore (sr25519) and POSTs the claim to the
// official faucet. The keystore password is prompted for locally, kept in
// process memory only, and never printed. The signature is never printed.
//
// Usage: node flop_faucet_claim.mjs <nonce> [--keystore <path>] [--no-post]
//   nonce      the nonce used in the step-1 message (milliseconds timestamp)
//   --no-post  sign only, do not send the claim
//
// Proxy: when HTTPS_PROXY is set, run with NODE_USE_ENV_PROXY=1.

import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
import { Keyring } from '@polkadot/keyring';
import { cryptoWaitReady } from '@polkadot/util-crypto';

const ADDRESS = process.env.FLOP_CLAIM_ADDRESS || '5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY';
const GENESIS = '0x918abd58fb16306b30ef3886514cfaebffecb4de43e82b6f8ec4795c43cfd800';
const CLAIM_URL = 'https://faucet.flop.network/v1/testnet/agent-claims';
const DEFAULT_KEYSTORE = fileURLToPath(new URL('./5ED4bNNKCq6miyYyyeURuNWpirECfuDxt465aAtEY1VwQoZY.json', import.meta.url));

function readAllStdin() {
  return new Promise((resolve, reject) => {
    const chunks = [];
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (c) => chunks.push(c));
    process.stdin.on('end', () => resolve(chunks.join('').replace(/[\r\n]+$/, '')));
    process.stdin.on('error', reject);
  });
}

function promptMasked(label) {
  return new Promise((resolve, reject) => {
    const stdin = process.stdin;
    if (!stdin.isTTY) {
      // Piped input: one line, the password. Used by flop_faucet_claim.ps1.
      readAllStdin().then(resolve, reject);
      return;
    }
    stdin.setRawMode(true);
    stdin.resume();
    stdin.setEncoding('utf8');
    let buf = '';
    process.stdout.write(label);
    const onData = (chunk) => {
      for (const c of chunk) {
        if (c === '\r' || c === '\n') {
          stdin.setRawMode(false); stdin.pause(); stdin.removeListener('data', onData);
          process.stdout.write('\n'); resolve(buf); return;
        } else if (c === '\u0003') {
          stdin.setRawMode(false); stdin.pause(); stdin.removeListener('data', onData);
          process.stdout.write('\n'); reject(new Error('cancelled')); return;
        } else if (c === '\u007f' || c === '\b') {
          buf = buf.slice(0, -1); process.stdout.write('\b \b');
        } else if (c >= ' ') {
          buf += c; process.stdout.write('*');
        }
      }
    };
    stdin.on('data', onData);
  });
}

async function main() {
  const args = process.argv.slice(2);
  const noPost = args.includes('--no-post');
  const keystoreArg = args[args.indexOf('--keystore') + 1];
  const keystorePath = args.includes('--keystore') ? keystoreArg : DEFAULT_KEYSTORE;
  const nonce = args.find((a, i) => !a.startsWith('--') && args[i - 1] !== '--keystore');

  if (!/^[0-9]{1,19}$/.test(nonce || '')) {
    console.error('usage: node flop_faucet_claim.mjs <nonce> [--keystore <path>] [--no-post]');
    process.exit(2);
  }
  if (!fs.existsSync(keystorePath)) {
    console.error('keystore not found: ' + keystorePath);
    process.exit(2);
  }

  await cryptoWaitReady();
  const keyring = new Keyring({ type: 'sr25519' });
  const pair = keyring.addFromJson(JSON.parse(fs.readFileSync(keystorePath, 'utf8')));

  const password = process.env.FLOP_WALLET_PW ?? await promptMasked('keystore password: ');
  try {
    pair.decodePkcs8(password);
  } catch {
    console.error('wrong keystore password');
    process.exit(1);
  }
  if (pair.address !== ADDRESS) {
    console.error('keystore address mismatch: ' + pair.address);
    process.exit(1);
  }

  const challenge = `flop-faucet-agent/v1|${GENESIS}|${ADDRESS}|${nonce}`;
  // pair.sign returns the raw 64-byte sr25519 signature over the exact UTF-8 bytes.
  const signature = '0x' + Buffer.from(pair.sign(new TextEncoder().encode(challenge))).toString('hex');
  pair.lock();

  if (noPost) {
    console.log('signed challenge (' + Buffer.byteLength(challenge) + ' bytes); not sent');
    return;
  }
  const res = await fetch(CLAIM_URL, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ address: ADDRESS, nonce: Number(nonce), signature }),
  });
  const text = await res.text();
  console.log('HTTP ' + res.status + ' ' + text.slice(0, 800));
}

main().catch((err) => {
  console.error('error: ' + (err && err.message ? err.message : err));
  process.exit(1);
});
