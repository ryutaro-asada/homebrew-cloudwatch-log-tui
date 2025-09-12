#!/bin/bash
set -euo pipefail

# 最新リリースのバージョンを取得
get_latest_version() {
	curl -s https://api.github.com/repos/ryutaro-asada/cloudwatch-log-tui/releases/latest |
		jq -r '.tag_name' |
		sed 's/^v//'
}

# 現在のFormulaのバージョンを取得
get_current_version() {
	grep 'version "' Formula/cloudwatch-log-tui.rb |
		sed 's/.*version "\(.*\)"/\1/'
}

# メイン処理
main() {
	echo "Checking for new cloudwatch-log-tui release..."

	LATEST_VERSION=$(get_latest_version)
	CURRENT_VERSION=$(get_current_version)

	echo "Latest release:  ${LATEST_VERSION}"
	echo "Current version: ${CURRENT_VERSION}"

	if [ "${LATEST_VERSION}" = "${CURRENT_VERSION}" ]; then
		echo "Formula is up to date"
		echo "update_needed=false" >>"${GITHUB_OUTPUT:-/dev/stdout}"
		exit 0
	else
		echo "New version available: ${LATEST_VERSION}"
		echo "new_version=${LATEST_VERSION}" >>"${GITHUB_OUTPUT:-/dev/stdout}"
		echo "update_needed=true" >>"${GITHUB_OUTPUT:-/dev/stdout}"
		exit 0
	fi
}

main
