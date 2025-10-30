{ inputs, system, pkgs, ... }:

let bgStatus = "#161616";
    fgStatus = "#c0c0c0";
    
in
{
  home.file.".config/zellij/config.kdl".source = ./config.kdl;

  home.file.".config/zellij/layouts/default.kdl".text = ''
    layout {
      default_tab_template {
        children
          pane size=1 borderless=true {
            plugin location="file://${inputs.zjstatus.packages."aarch64-darwin".default}/bin/zjstatus.wasm" {
              format_left  "{mode} #[bg=${bgStatus},fg=${fgStatus}]{session} "
              format_center "{tabs}"
              format_right "#[bg=${bgStatus},fg=${fgStatus}] {swap_layout}"
              format_space  "#[bg=${bgStatus}]"

              mode_normal        "#[bg=green,fg=black] NORMAL "
              mode_locked        "#[bg=red,fg=black]  LOCKED "
              mode_resize        "#[bg=magenta,fg=black] RESIZE "
              mode_pane          "#[bg=magenta,fg=black] PANE "
              mode_tab           "#[bg=magenta,fg=black] TAB "
              mode_scroll        "#[bg=magenta,fg=black] SCROLL "
              mode_enter_search  "#[bg=magenta,fg=black] ENTER_SEARCH "
              mode_search        "#[bg=magenta,fg=black] SEARCH "
              mode_rename_tab    "#[bg=magenta,fg=black] RENAME_TAB "
              mode_rename_pane   "#[bg=magenta,fg=black] RENAME_PANE "
              mode_session       "#[bg=magenta,fg=black] SESSION "
              mode_move          "#[bg=magenta,fg=black] MOVE "
              mode_prompt        "#[bg=magenta,fg=black] PROMPT "
              mode_tmux          "#[bg=magenta,fg=black] TMUX "

              tab_normal "#[bg=${bgStatus},fg=${fgStatus}] #[bg=${bgStatus},fg=${fgStatus}]{name} {sync_indicator}{fullscreen_indicator}{floating_indicator}#[bg=green,fg=black]"
              tab_active "#[bg=black,fg=green] #[bg=black,fg=green]{name} {sync_indicator}{fullscreen_indicator}{floating_indicator}#[bg=black,fg=green]"

              tab_sync_indicator       "󰓦 "
              tab_fullscreen_indicator "󱟱  "
              tab_floating_indicator   "󰉈 "
            }
          }
      }
    }
    '';

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };
}
