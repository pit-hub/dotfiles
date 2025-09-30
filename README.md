# VS Code Codespaces customizations

Setup script and configuration files Linux customization
(for now only used for VS Code Codespaces - Debian dev containers)


To install dotfile execute:
```shell
./install.sh
```

If executing with **sudo** make sure you keep the user environment:

```shell
sudo --preserve-env ./install.sh
```

```shell
# setup git user
# Install GitHUb CLI
sudo nix-env --profile /nix/var/nix/profiles/default --install --attr nixpkgs.github-cli

# Authenticate with Github
gh auth login

# Set git user & email
# Uses --global option if not in git repo, and local if in git repo worktree
~/020-home/bin/gh-setup-git.sh 020-home/bin/gh-setup-git.sh

```
