# Swift toolchain

[Swift](https://swift.org) toolchain for Debian / Ubuntu.

version: `5.6`

archs: `aarch64`, `amd64`

Debian: `11 (bullseye)`, `10 (buster)`

Ubuntu: `20.04 (focal)`, `18.04 (bionic)`

## Automatic installation script

`swift-toolchain` will be installed at: `/opt/swift-toolchain`

Install dependencies:

```bash
sudo apt-get install -y lsb-release
```

Install `swift-toolchain` using shell script:

`curl`:
```bash
bash -c "$(curl -fsSL https://swift-toolchain.com/install.sh)"
```

`wget`:
```bash
bash -c "$(wget -qO - https://swift-toolchain.com/install.sh)"
```

`wget2`:
```bash
bash -c "$(wget2 -qO - https://swift-toolchain.com/install.sh)"
```

## How to debugging within VSCode

Install extension: [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)

- lldb.library: `/opt/swift-toolchain/lib/liblldb.so`

Install extension: [Swift](https://marketplace.visualstudio.com/items?itemName=sswg.swift-lang)

Configurate Workspace:

launch.json:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "program": "${workspaceFolder}/.build/debug/Run",
      "args": [],
      "cwd": "${workspaceFolder}",
      "preLaunchTask": "swift: Build Debug Run"
    }
  ]
}
```

tasks.json

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "swift: Build Debug Run",
      "type": "shell",
      "command": "swift build -c debug"
    }
  ]
}
```

## How to use Swift-DocC

Require Swift `5.6`.

To use the [Swift-DocC plugin](https://github.com/apple/swift-docc-plugin) with your package, first add it as a dependency:

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        // targets
    ]
)
```

You can then invoke the plugin from the root of your repository like so:

```bash
swift package generate-documentation
```

Or [Generating Documentation for Hosting Online](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/generating-documentation-for-hosting-online/):

```bash
swift package --allow-writing-to-directory doc-html \
      generate-documentation --disable-indexing \
                             --transform-for-static-hosting \
                             --output-path doc-html
```

`doc-html` is output directory path and now ready to be published online.

Transforming for Static Hosting: `--transform-for-static-hosting`

Host your documentation at a sub-path: `--hosting-base-path [hosting-base-path]`

## How to Run Swift-DocC's CLI tool ([docc](https://github.com/apple/swift-docc))

```bash
swift doc
```

Example:

```bash
git clone https://github.com/cntrump/slothkit.git
cd slothkit
```

Local preview:

```bash
swift doc preview Sources/SlothCreator/SlothCreator.docc \
                  --fallback-display-name SwiftDocC \
                  --fallback-bundle-identifier org.swift.SwiftDocC \
                  --fallback-bundle-version 1.0.0 \
                  --transform-for-static-hosting \
                  --port 8080
```

You should now see the following in your terminal:

```
Input: ~/slothkit/Sources/SlothCreator/SlothCreator.docc
Template: /opt/swift-toolchain/usr/share/docc/render
~/slothkit/Sources/SlothCreator/SlothCreator.docc/Tutorials/Creating Custom Sloths.tutorial:71:26: warning: Topic reference 'SlothCreator/Sloth' couldn't be resolved. No local documentation matches this reference.
========================================
Starting Local Preview Server
	 Address: http://localhost:8080/tutorials/slothcreator
========================================
```

Static hosting:

```bash
swift doc convert Sources/SlothCreator/SlothCreator.docc \
                  --fallback-display-name SwiftDocC \
                  --fallback-bundle-identifier org.swift.SwiftDocC \
                  --fallback-bundle-version 1.0.0 \
                  --transform-for-static-hosting \
                  --output-dir doc-html
```

Run a local http server:

```
$ cd doc-html
$ python3 -m http.server 8080

Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/)
```

Visit: `http://10.211.55.32:8080/tutorials/slothcreator`

More Information: [Distributing Documentation to Other Developers](https://www.swift.org/documentation/docc/distributing-documentation-to-other-developers#Host-a-Documentation-Archive-on-Your-Website)

## How to Install

```bash
sudo apt-get update
sudo apt-get install swift-toolchain
```

If you don't want to install recommends: `git`, `pkg-config`, `tzdata`, `gnupg2`:

[swift package manager](https://github.com/apple/swift-package-manager) required dependencies: `git`, `pkg-config`.

```bash
sudo apt-get --no-install-recommends install swift-toolchain
```

If you want to install old version: `5.5.3`:

```bash
sudo apt-get install swift-toolchain=5.5.3-1
```

## How to upgrade to latest version

Update swift-toolchain to latest version:

```bash
sudo apt-get update
sudo apt-get upgrade swift-toolchain
```
