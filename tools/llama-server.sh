#!/usr/bin/env bash
llama-server -dev Vulkan0,Vulkan1 \
    --models-max 1 \
    --models-preset ~/dotfiles/etc/models.ini --host 0.0.0.0
    # -ctk q8_0 -ctv q8_0
    # --model ~/Downloads/models/Qwen3.5-27B-Q4_K_M.gguf \
    # --model-draft ~/Downloads/models/Qwen3.5-2B-Q4_K_M.gguf
