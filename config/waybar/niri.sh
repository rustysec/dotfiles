#!/usr/bin/env node

const { spawnSync } = require('child_process');

let output = process.argv[2]

let { stdout, stderr } = spawnSync('niri', ['msg', '-j', 'workspaces'])

let items = JSON.parse(stdout.toString())
    .filter(item => item.output == output)
    .map(item => {
        if (item.is_active) {
            return `(${item.idx})`
        } else {
            return ` ${item.idx} `
        }
    })
    .join(' | ');

console.log(`${items}`)
