#!/bin/bash
# Script sửa lỗi config cho OpenManus

echo "=== OpenManus Config Fix ==="

if [ -f "config.toml" ] && [ ! -f "config/config.toml" ]; then
    echo "✓ Phát hiện config.toml ở thư mục gốc, đang chuyển vào config/..."
    mkdir -p config
    cp config.toml config/config.toml
    echo "✓ Đã copy config.toml → config/config.toml"
else
    echo "✓ Config đã ở đúng vị trí hoặc không tìm thấy config.toml ở root"
fi

echo ""
echo "=== Kiểm tra nội dung config ==="
if [ -f "config/config.toml" ]; then
    echo "✓ config/config.toml tồn tại"
    head -20 config/config.toml
else
    echo "✗ config/config.toml KHÔNG tồn tại!"
    echo "  Hãy tạo file config/config.toml theo mẫu trong README"
fi
