#!/usr/bin/env node

// @ts-check

/**
 * @typedef {{ name: string, 'bs-dependencies': string[] }} BsConfig
 */

const fs = require('fs');
const path = require('path');

const cwd = process.cwd();
const configPath = path.join(cwd, 'bsconfig.json');

/**
 * @type [BsConfig | undefined, BsConfig | undefined]
 */
const [myConfig, yourConfig] = (() => {
  try {
    return [
      JSON.parse(
        fs.readFileSync(path.join(cwd, '..', '..', 'bsconfig.json'), 'utf-8')
      ),
      JSON.parse(fs.readFileSync(configPath, 'utf-8'))
    ];
  } catch (error) {
    return [undefined, undefined];
  }
})();

if (myConfig && yourConfig) {
  const myName = myConfig.name;
  const myDeps = myConfig['bs-dependencies'] || [];
  const dependencies = new Set(yourConfig['bs-dependencies'] || []);

  for (const dep of [myName, ...myDeps]) {
    dependencies.add(dep);
  }

  yourConfig['bs-dependencies'] = [...dependencies];

  fs.writeFileSync(configPath, JSON.stringify(yourConfig, null, 2));
}
