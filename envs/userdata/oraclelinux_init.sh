#!/bin/bash

# Shell Options
# e : エラーがあったら直ちにシェルを終了
# u : 未定義変数を使用したときにエラーとする
# o : シェルオプションを有効にする
# pipefail : パイプラインの返り値を最後のエラー終了値にする (エラー終了値がない場合は0を返す)
set -euo pipefail

# Timezone
timedatectl set-timezone Asia/Tokyo
systemctl restart rsyslog

# Swap 変更 (defalt 1.5GiB)
# langpacks-ja インストール時にMAXで4GiB使っていたため、SWAP拡張で対応
# 元々/etc/fstabには永続化設定は入っているためコマンド実行はしない
swapoff /.swapfile
fallocate -l 5G /.swapfile
chmod 600 /.swapfile
mkswap /.swapfile
swapon /.swapfile

# Locale
dnf install -y langpacks-ja
localectl set-locale LANG=ja_JP.utf8
localectl set-keymap jp106

# Firewall Service disable
systemctl stop firewalld
systemctl disable firewalld
systemctl mask firewalld

# SELinux disable
grubby --update-kernel ALL --args selinux=0
shutdown -r now