#!/bin/bash
# Script tự động khởi tạo repo GitHub cho OpenManus
# Sử dụng: bash setup-github.sh <YOUR_GITHUB_USERNAME>

set -e

if [ -z "$1" ]; then
    echo "❌ Lỗi: Cần điền GitHub username!"
    echo ""
    echo "Cách dùng:"
    echo "  bash setup-github.sh <YOUR_GITHUB_USERNAME>"
    echo ""
    echo "Ví dụ:"
    echo "  bash setup-github.sh john-doe"
    exit 1
fi

USERNAME=$1
REPO_NAME="openmanus"

echo "🔧 Chuẩn bị đẩy code lên GitHub..."
echo ""

# Kiểm tra git
if ! command -v git &> /dev/null; then
    echo "❌ Git chưa được cài đặt. Vui lòng cài Git trước:"
    echo "   https://git-scm.com/downloads"
    exit 1
fi

# Kiểm tra đã tạo repo trên GitHub chưa
echo "⚠️  QUAN TRỌNG: Trước khi tiếp tục, bạn phải:"
echo ""
echo "1️⃣  Vào https://github.com/new"
echo "2️⃣  Tạo repo tên '$REPO_NAME'"
echo "3️⃣  Chọn 'Public' (hoặc Private nếu muốn)"
echo "4️⃣  Bỏ tích 'Initialize this repository with a README'"
echo "5️⃣  Click 'Create repository'"
echo ""
read -p "✅ Đã tạo repo trên GitHub chưa? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Hãy tạo repo trước, rồi chạy lại script này."
    exit 0
fi

# Khởi tạo git
if [ -d ".git" ]; then
    echo "⚠️  Git repo đã tồn tại, sẽ reset nó..."
    rm -rf .git
fi

echo ""
echo "📦 Khởi tạo Git repository..."
git init
git add .
git commit -m "Initial commit: OpenManus cutdown version with GitHub Actions workflow"
git branch -M main

echo ""
echo "🔗 Thêm remote GitHub..."
git remote add origin "git@github.com:${USERNAME}/${REPO_NAME}.git"

echo ""
echo "🔑 Kiểm tra SSH key..."
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "⚠️  SSH key chưa tồn tại!"
    echo ""
    echo "Vui lòng tạo SSH key trước:"
    echo "  ssh-keygen -t rsa -b 4096 -C \"your_email@example.com\""
    echo ""
    echo "Rồi thêm public key vào GitHub:"
    echo "  https://github.com/settings/ssh/new"
    echo ""
    read -p "✅ Đã tạo SSH key và thêm vào GitHub chưa? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Hãy tạo SSH key trước, rồi chạy lại script này."
        exit 0
    fi
fi

echo ""
echo "📤 Đẩy code lên GitHub..."
git push -u origin main

echo ""
echo "✅ Hoàn tất! Repo đã được tạo tại: https://github.com/${USERNAME}/${REPO_NAME}"
echo ""
echo "📋 Bước tiếp theo:"
echo ""
echo "1️⃣  Cấu hình Secrets:"
echo "    Vào: https://github.com/${USERNAME}/${REPO_NAME}/settings/secrets/actions"
echo ""
echo "    Thêm 3 secrets:"
echo "    • LLM_API_KEY = (API key của bạn)"
echo "    • LLM_BASE_URL = https://api.anthropic.com/v1/"
echo "    • LLM_MODEL = claude-3-7-sonnet-20250219"
echo ""
echo "2️⃣  Chạy workflow:"
echo "    Vào: https://github.com/${USERNAME}/${REPO_NAME}/actions"
echo "    Chọn 'Run OpenManus Agent' → 'Run workflow'"
echo "    Nhập prompt rồi chạy!"
echo ""
echo "3️⃣  Lấy kết quả:"
echo "    Sau khi job xanh ✓, tải Artifacts"
echo ""
echo "📖 Xem hướng dẫn chi tiết: SETUP_GITHUB_ACTIONS.md"
