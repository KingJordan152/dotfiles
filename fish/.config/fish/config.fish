if status is-interactive
  # ==================
  # GENERAL SETTINGS
  # ==================
  set fish_greeting # Remove greeting

  set -gx EDITOR "nvim"
  set -gx VISUAL "$EDITOR"

  # ==================
  # ALIASES
  # ==================
  alias nvim="SHELL=$(which fish) command nvim" # Ensure Neovim uses `fish` as its default shell
  alias tmux="SHELL=$(which fish) command tmux" # Ensure Tmux uses `fish` as its default shell

  if command -q eza
    alias ls="eza --icons --color --group-directories-first --hyperlink --git --time-style relative"
  end

  # ==================
  # MISC.
  # ==================

  # Bootstrap `fisher` plugin manager
  if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source

    if not test -f $__fish_config_dir/fish_plugins
      fisher install jorgebucaran/fisher # Install primary `fisher` plugin
    else
      fisher update # Install all plugins from `fish_plugins` file
    end
  end

  # Ensure Ghostty Shell Integration persists through shell restarts
  if test -n "$GHOSTTY_RESOURCES_DIR"
    source "$GHOSTTY_RESOURCES_DIR"/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
  end

  # Activate Starship prompt
  if command -q starship
    starship init fish | source
  end

  # Activate Mise
  if command -q mise
    mise activate fish | source
  end
end
