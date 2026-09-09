class LlmVegas < Formula
  desc "Slot machine that spins itself when Claude burns output tokens"
  homepage "https://github.com/todokr/llm-vegas"
  url "https://github.com/todokr/llm-vegas/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6f14b8ce10758798487c34362b2323550917425638500939046f2616bdc9ad99"
  license "EPL-2.0"

  depends_on "node" => :build
  depends_on :macos

  # Electron 本体は npm の postinstall に任せない。
  # Homebrew のビルドサンドボックス内では展開が途中で壊れるため、
  # Homebrew の resource として取得する。
  # バージョンは llm-vegas の package-lock.json と一致させること。
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

    # 実行時に必要なのはビルド済みの dist と package.json だけ。
    # electron API は Electron のランタイムに組み込まれている
    libexec.install "dist", "package.json"
    (libexec/"electron").install resource("electron")

    (bin/"llm-vegas").write <<~SH
      #!/bin/bash
      exec "#{libexec}/electron/Electron.app/Contents/MacOS/Electron" \\
        "#{libexec}" "$@"
    SH
    chmod 0755, bin/"llm-vegas"
  end

  def caveats
    <<~CAVEATS
      画面右上に筐体が常駐します。終了は筐体の ✕ ボタンです。

        llm-vegas            # 起動
        llm-vegas &          # ターミナルを離す場合

      Claude Code が ~/.claude/projects に transcript を書いている必要があります。
    CAVEATS
  end

  test do
    assert_predicate libexec/"dist/main/index.js", :exist?
    assert_predicate libexec/"electron/Electron.app/Contents/Frameworks", :directory?
    assert_predicate libexec/"electron/Electron.app/Contents/MacOS/Electron", :executable?
  end
end
