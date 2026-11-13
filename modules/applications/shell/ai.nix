{ dotfiles, ... }:

{
  home.file.".agents/skills".source = "${dotfiles}/ai/agents/skills";

  # Claude
  home.file.".claude/CLAUDE.md".source = "${dotfiles}/ai/AGENTS.md";
  home.file.".claude/skills".source = "${dotfiles}/ai/agents/skills";

  # Codex
  home.file.".codex/AGENTS.md".source = "${dotfiles}/ai/AGENTS.md";
}
