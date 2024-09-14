# This file is ALWAYS sourced when zsh is started.
# DO NOT USE THIS FILE TO DEFINE ALIASES, FUNCTIONS, TOOL OVERRIDES, ETC.
# Export only environment variables here.
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
export GOPATH=$HOME/.go