#!/usr/bin/env bash

##############
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustup target add x86_64-pc-windows-gnu
rustup component add clippy
rustup component add llvm-tools
rustup component add rust-analyzer
rustup component add rust-src
cargo install -f cargo-make
cargo install -f cargo-tree
cargo install cross --git https://github.com/cross-rs/cross

current=`pwd`
git clone https://github.com/cross-rs/cross ~/pkgs/cross
cd ~/pkgs/cross
git submodule update --init --remote
cd $current
