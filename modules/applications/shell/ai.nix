{ dotfiles, ... }:

{
  home.file.".agents/skills".source = "${dotfiles}/ai/agents/skills";

  # Claude
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/ai/AGENTS.md";
  home.file.".claude/skills".source = "${dotfiles}/ai/agents/skills";
  home.file.".claude/themes".source = "${dotfiles}/ai/claude/themes";

  # Codex
  home.file.".codex/AGENTS.md".source = "${dotfiles}/ai/AGENTS.md";
  home.file.".codex/rules/custom.rules".source = "${dotfiles}/ai/codex/rules/custom.rules";
  home.file.".codex/themes/island-dark.tmTheme".source = "${dotfiles}/sublime/themes/island-dark.tmTheme";
}
