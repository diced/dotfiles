{ ... }:

# workaround until ghostty 1.1.3 is fixed!

{
  home.file.".config/ghostty/config".text = ''
    font-family = "JetbrainsMono Nerd Font"
    shell-integration-features = true
    theme = "dark:dark,light:light"
    # font-feature = "-calt, -liga, -dlig"

    window-theme = "ghostty"
  '';

  home.file.".config/ghostty/themes/dark".text = ''
    background = #161616
    foreground = #ffffff
    cursor-color = #acb1ab
    cursor-text = #ffffff
    selection-background = #FFFFFF
    selection-foreground = #101010

    palette = 0=#232627
    palette = 1=#C0392B
    palette = 2=#8BD49C
    palette = 3=#FDBC4B
    palette = 4=#1D99F3
    palette = 5=#8E44AD
    palette = 6=#1ABC9C
    palette = 7=#FCFCFC
    palette = 8=#7F8C8D
    palette = 9=#D64030
    palette = 10=#1CDC9A
    palette = 11=#FDBC4B
    palette = 12=#3DAEE9
    palette = 13=#8E44AD
    palette = 14=#0DC9B8
    palette = 15=#FFFFFF
  '';

  home.file.".config/ghostty/themes/light".text = ''
    background = #fcffff
    foreground = #232323
    cursor-color = #0055bb
    selection-background = #d4eaf3
    selection-foreground = #232323

    palette = 0=#eaefef
    palette = 1=#c42d2f
    palette = 2=#008a00
    palette = 3=#aa6100
    palette = 4=#004fc0
    palette = 5=#aa44c5
    palette = 6=#1f6fbf
    palette = 7=#232323
    palette = 8=#b5b8b8
    palette = 9=#cf2f4f
    palette = 10=#00845f
    palette = 11=#996c4f
    palette = 12=#065fff
    palette = 13=#7f5ae0
    palette = 14=#007a85
    palette = 15=#66657f
  '';
}
