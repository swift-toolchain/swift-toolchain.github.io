#!/usr/bin/env bash

set -exu

if ! which lsb_release &> /dev/null; then
  echo "ERR: lsb-release is required."
  exit 1
fi

distributor=$(lsb_release -is)
codename=$(lsb_release -cs)

supported_codenames=("bullseye" "buster" "focal" "bionic")
matched_codename=
for c in ${supported_codenames[@]}
do
  if [ ${c} = ${codename} ]; then
    matched_codename=${c}
    break
  fi
done

if [ "${matched_codename}" = "" ]; then
  echo "ERR: ${distributor,,} ${codename} not supported."
  exit 1
fi

download_file() {
  url=$1
  saveto=$2
  temp_file=$(mktemp)

  if which curl &> /dev/null; then
    curl -fsSL -o ${temp_file} ${url}; 
  elif which wget2 &> /dev/null; then
    wget2 -qO ${temp_file} ${url}; 
  elif which wget &> /dev/null; then
    wget -qO ${temp_file} ${url};
  else
    echo "ERR: can't download ${url}."
  fi

  [ -f ${saveto} ] && sudo rm -f ${saveto}
  sudo mv -f ${temp_file} ${saveto}
  sudo chmod 644 ${saveto}
  sudo chown root:root ${saveto}
}

swift_toolchain_keyring=/usr/share/keyrings/swift-toolchain.gpg

cat <<EOF | sudo tee /etc/apt/sources.list.d/swift-toolchain.list
deb [signed-by=${swift_toolchain_keyring}] http://deb.swift-toolchain.com/${distributor,,} ${codename} main
EOF

download_file https://swift-toolchain.com/swift-toolchain.gpg ${swift_toolchain_keyring}

sudo apt-get update -y
sudo apt-get install -y swift-toolchain

SWIFT_HOME=/opt/swift-toolchain/usr
PATH=$SWIFT_HOME/bin:$PATH

swift --version
swift build --version

clang --version
clang -fuse-ld=lld -Wl,--version
lldb --version

