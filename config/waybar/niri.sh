#!/usr/bin/env node

const { spawnSync } = require('child_process');

let output = process.argv[2]

let { stdout, stderr } = spawnSync('niri', ['msg', '-j', 'workspaces'])

let items = JSON.parse(stdout.toString())
    .filter(item => item.output == output)
    .sort((a, b) => {
        if (a.idx < b.idx) {
            return -1;
        } else {
            return 1;
        }
    })
    .map(item => {
        if (item.is_active) {
            return ''
        } else {
            return ''
        }
    })
    .join('  ');

console.log(`${items}`)
