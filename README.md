# Dotfiles

This repo is organized for [GNU Stow](https://www.gnu.org/software/stow/): each top-level folder is a Stow package.

Current packages:

- `nvim`
- `zellij`
- `ghostty`
- `agents`

## 1) Install Stow

On macOS (Homebrew):

```bash
brew install stow
```

## 2) Apply dotfiles (create symlinks)

From this repo root (`~/dotfiles`):

```bash
stow --target="$HOME" nvim zellij ghostty agents fish
```

That creates symlinks like:

- `~/.config/nvim` -> `~/dotfiles/nvim/.config/nvim`
- `~/.config/zellij` -> `~/dotfiles/zellij/.config/zellij`

## 3) Safe dry-run before applying

```bash
stow --simulate --verbose --target="$HOME" nvim zellij ghostty agents fish
```

Use this whenever you are unsure about conflicts.

## 4) Re-apply after changes

If package contents change, restow it:

```bash
stow -R --target="$HOME" nvim zellij ghostty agents fish
```

## 5) Remove symlinks (unstow)

```bash
stow -D --target="$HOME" nvim zellij ghostty agents fish
```

## 6) If Stow reports conflicts

Conflicts happen when a real file already exists where Stow wants to place a symlink.

Typical flow:

1. Back up existing file(s).
2. Move/remove the conflicting file(s).
3. Run Stow again.

If you want to absorb existing files into this repo instead:

```bash
stow --adopt --target="$HOME" nvim zellij ghostty agents fish
```

Then review what changed in git to make sure adopted files are correct.

## Common routines

Fresh machine setup:

```bash
git clone git@github.com:phucnguyen035/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
./stow-all.sh
```

After pulling latest dotfiles:

```bash
cd "$HOME/dotfiles"
git pull
./stow-all.sh -R
```

## Helper script

Use the helper script to avoid repeating package names:

```bash
./stow-all.sh
```

Common options:

```bash
./stow-all.sh -n        # dry-run
./stow-all.sh -R        # restow
./stow-all.sh -D        # unstow
./stow-all.sh -t "$HOME" -R
```

