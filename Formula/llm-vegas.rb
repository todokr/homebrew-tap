class LlmVegas < Formula
  desc "Slot machine that spins itself when Claude burns output tokens"
  homepage "https://github.com/todokr/llm-vegas"
  url "https://github.com/todokr/llm-vegas/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "0ca203037d9563076596c171c410d99c08806788d9e48f6e542dff60eaeecf90"
  license "EPL-2.0"

  # llm-vegas の package-lock.json が固定している electron と一致させること
  ELECTRON_VERSION = "33.4.11"

  depends_on "node" => :build
  depends_on :macos

  on_arm do
    resource "electron" do
      url "https://github.com/electron/electron/releases/download/v33.4.11/electron-v33.4.11-darwin-arm64.zip"
      sha256 "9c763751c280b20ec93cecdc7f369bed876fc6728863a9ba5d7435096401f048"
    end
  end

  on_intel do
    resource "electron" do
      url "https://github.com/electron/electron/releases/download/v33.4.11/electron-v33.4.11-darwin-x64.zip"
      sha256 "67f3b851e7583309e7bbe3e3e819b1e1c6033ab57207d838bc4ed4982ccef456"
    end
  end

  def install
    ENV["ELECTRON_SKIP_BINARY_DOWNLOAD"] = "1"
    system "npm", "ci"
    system "npm", "run", "build"

    # 実行時に要るのはビルド済みの dist と package.json だけ。
    # electron API は Electron のランタイムに組み込まれている
    libexec.install "dist", "package.json"

    # Homebrew は keg 内のあらゆる Mach-O を再リンクして署名し直すため
    # (keg_relocate.rb の mach_o_files)、Electron.app を展開したまま置くと
    # 署名が壊れて起動できなくなる。zip のまま置き、初回起動時に展開する。
    cp resource("electron").cached_download, libexec/"electron.zip"

    (bin/"llm-vegas").write <<~SH
      #!/bin/bash
      set -euo pipefail

      runtime="${HOME}/Library/Application Support/LLM Vegas/runtime/#{ELECTRON_VERSION}"
      app="${runtime}/Electron.app/Contents/MacOS/Electron"

      if [ ! -x "${app}" ]; then
        echo "Unpacking the Electron runtime (first run only)..." >&2
        rm -rf "${runtime}"
        mkdir -p "${runtime}"
        # ditto なら署名と拡張属性を保ったまま展開できる
        /usr/bin/ditto -x -k "#{libexec}/electron.zip" "${runtime}"
      fi

      exec "${app}" "#{libexec}" "$@"
    SH
    chmod 0755, bin/"llm-vegas"
  end

  def caveats
    <<~CAVEATS
      画面右上に筐体が常駐します。終了は筐体の ✕ ボタンです。

        llm-vegas            # 起動
        llm-vegas &          # ターミナルを離す場合

      初回起動時だけ Electron ランタイムを
      ~/Library/Application Support/LLM Vegas/runtime に展開します。

      Claude Code が ~/.claude/projects に transcript を書いている必要があります。
    CAVEATS
  end

  test do
    assert_predicate libexec/"dist/main/index.js", :exist?
    assert_predicate libexec/"electron.zip", :exist?
  end
end
