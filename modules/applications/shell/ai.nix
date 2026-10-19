{ dotfiles, ... }:

{
  home.file.".agents/skills".source = "${dotfiles}/ai/agents/skills";
  home.file.".codex/AGENTS.md".source = "${dotfiles}/ai/AGENTS.md";
}
