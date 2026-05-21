return {
    'milanglacier/minuet-ai.nvim',
    enabled = not os.getenv("NO_LLAMA"),
    config = function()
        require('minuet').setup {
            virtualtext = {
                auto_trigger_ft = { },
                keymap = {
                    -- accept whole completion
                    accept = '<A-Space>',
                    -- accept one line
                    accept_line = '<M-a>',
                    -- accept n lines (prompts for number)
                    -- e.g. "A-z 2 CR" will accept 2 lines
                    accept_n_lines = '<A-z>',
                    -- Cycle to prev completion item, or manually invoke completion
                    prev = '<A-M>',
                    -- Cycle to next completion item, or manually invoke completion
                    next = '<A-m>',
                    dismiss = '<A-e>',
                },
            },

            provider = 'openai_fim_compatible',
            n_completions = 1, -- recommend for local model for resource saving
            -- I recommend beginning with a small context window size and incrementally
            -- expanding it, depending on your local computing power. A context window
            -- of 512, serves as an good starting point to estimate your computing
            -- power. Once you have a reliable estimate of your local computing power,
            -- you should adjust the context window to a larger value.
            context_window = 4096,
            provider_options = {
                openai_fim_compatible = {
                    -- For Windows users, TERM may not be present in environment variables.
                    -- Consider using APPDATA instead.
                    api_key = 'TERM',
                    name = 'Llama.cpp',
                    end_point = os.getenv('LLAMA_API') or 'http://localhost:10000' .. '/v1/completions',
                    -- The model is set by the llama-cpp server and cannot be altered
                    -- post-launch.
                    model = 'PLACEHOLDER',
                    optional = {
                        max_tokens = 1024,
                        top_p = 0.9,
                    },
                    -- Llama.cpp does not support the `suffix` option in FIM completion.
                    -- Therefore, we must disable it and manually populate the special
                    -- tokens required for FIM completion.
                    template = {
                        prompt = function(context_before_cursor, context_after_cursor, _)
                            return '<|fim_prefix|>'
                                .. context_before_cursor
                                .. '<|fim_suffix|>'
                                .. context_after_cursor
                                .. '<|fim_middle|>'
                        end,
                        suffix = false,
                    },
                },
            },
        }
    end,
}
