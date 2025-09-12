#!/bin/bash
set -euo pipefail

# Formulaの構文チェックとテスト
echo "Testing Formula syntax..."

# Ruby構文チェック
if ruby -c Formula/cloudwatch-log-tui.rb 2>/dev/null; then
	echo "✓ Ruby syntax is valid"
else
	echo "✗ Ruby syntax error detected"
	exit 1
fi

# Homebrew用の基本的なチェック
echo "Checking Formula structure..."

# 必須フィールドの確認
required_fields=("desc" "homepage" "version" "sha256" "def install")
for field in "${required_fields[@]}"; do
	if grep -q "$field" Formula/cloudwatch-log-tui.rb; then
		echo "✓ Found: $field"
	else
		echo "✗ Missing: $field"
		exit 1
	fi
done

# SHA256ハッシュの形式チェック（64文字の16進数）
if grep -E 'sha256 "[a-f0-9]{64}"' Formula/cloudwatch-log-tui.rb >/dev/null; then
	echo "✓ SHA256 hashes format is valid"
else
	echo "✗ Invalid SHA256 hash format"
	exit 1
fi

echo ""
echo "All checks passed! ✅"
