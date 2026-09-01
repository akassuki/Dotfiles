#!/usr/bin/env bash
# install.sh — script duy nhất cần chạy trên máy mới (đã clone sẵn repo này)
# Cách dùng: cd ~/Dotfiles && bash install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/3] Kiểm tra chezmoi..."
if ! command -v chezmoi &>/dev/null; then
    if [ -x "$HOME/.local/bin/chezmoi" ]; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
fi

if ! command -v chezmoi &>/dev/null; then
    echo "    Chưa có chezmoi, đang cài vào ~/.local/bin ..."
    sh -c "$(curl -fsLS get.chezmoi.io)"
    export PATH="$HOME/.local/bin:$PATH"

    if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ] && ! grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
else
    echo "    Đã có sẵn: $(chezmoi --version)"
fi

echo "==> [2/3] Đăng ký source path: $REPO_DIR"
chezmoi init --source="$REPO_DIR"

echo "==> [3/3] Áp dụng cấu hình (chạy script cài đặt + symlink file)..."
chezmoi apply --verbose

echo ""
echo "==> Hoàn tất!"
echo "    Mở terminal mới (hoặc: source ~/.bashrc) để nhận đủ PATH/alias."
echo "    Từ giờ chỉ cần: chezmoi apply   (không cần --source nữa)"


