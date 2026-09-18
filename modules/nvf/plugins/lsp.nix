{ lib, ... }:

{
  vim = {
    lsp = {
      enable = true;
      formatOnSave = true;

      inlayHints.enable = true;

      trouble = {
        enable = true;
        mappings.lspReferences = null;
      };

      otter-nvim.enable = true;

      mappings.goToDefinition = null;

      presets = {
        tailwindcss-language-server.enable = true;
        superhtml.enable = lib.mkForce false;
      };

      servers = {
        basedpyright.handlers."$/progress" = lib.generators.mkLuaInline ''
          function(err, result, ctx)
            -- Filter noisy notifications by only forwarding the first progress token.
            if result.token == (vim.g.basedpyright_progress_token or result.token) then
              vim.g.basedpyright_progress_token = result.token
              vim.lsp.handlers['$/progress'](err, result, ctx)
            end
          end
        '';

        clangd = {
          cmd = lib.mkForce [
            "clangd"
            "--background-index"
            "--query-driver=**/.platformio/packages/toolchain-xtensa-esp32*/bin/*-g*,**/.platformio/packages/toolchain-riscv32-esp*/bin/*-g*"
          ];
        };

        tinymist.settings = {
          formatterPrintWidth = 80;
          formatterProseWrap = true;
        };

        oxlint = { };
        tsc = {
          cmd = lib.generators.mkLuaInline ''
            function(dispatchers, config)
              local cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin/tsc")
              local on_exit = dispatchers.on_exit
              local wrapped_dispatchers = vim.tbl_extend("force", dispatchers, {
                on_exit = function(code, signal)
                  if code ~= 0 then
                    vim.schedule(function()
                      vim.notify_once(
                        "tsc LSP exited unsuccessfully; node_modules/.bin/tsc must support --lsp (TypeScript 7+).",
                        vim.log.levels.ERROR
                      )
                    end)
                  end

                  if on_exit then
                    on_exit(code, signal)
                  end
                end,
              })

              return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, wrapped_dispatchers)
            end
          '';

          filetypes = [
            "javascript"
            "javascriptreact"
            "typescript"
            "typescriptreact"
          ];

          root_dir = lib.generators.mkLuaInline ''
            function(bufnr, on_dir)
              local filename = vim.api.nvim_buf_get_name(bufnr)
              local dir = filename == "" and vim.fn.getcwd() or vim.fs.dirname(filename)

              while dir do
                local cmd = vim.fs.joinpath(dir, "node_modules/.bin/tsc")
                if vim.fn.executable(cmd) == 1 then
                  on_dir(dir)
                  return
                end

                local parent = vim.fs.dirname(dir)
                if not parent or parent == dir then
                  break
                end
                dir = parent
              end

              vim.notify_once(
                "tsc LSP not started: node_modules/.bin/tsc was not found or is not executable.",
                vim.log.levels.WARN
              )
            end
          '';
        };

        "vscode-json-language-server".settings.json = {
          schemas = lib.generators.mkLuaInline ''
            require("schemastore").json.schemas()
          '';
          validate.enable = true;
        };

        "yaml-language-server".settings.yaml = {
          schemaStore = {
            enable = false;
            url = "";
          };
          schemas = lib.generators.mkLuaInline ''
            require("schemastore").yaml.schemas()
          '';
        };
      };
    };

    # for lsp
    keymaps = [
      {
        mode = "n";
        key = "<A-O>";
        lua = true;
        action = ''
          function()
            vim.lsp.buf.code_action({
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
              apply = true,
            })
          end
        '';
        desc = "LSP: Organize imports";
        noremap = true;
        silent = true;
      }
    ];
  };
}
