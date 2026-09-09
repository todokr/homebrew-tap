class LlmVegas < Formula
  desc "Slot machine that spins itself when Claude burns output tokens"
  homepage "https://github.com/todokr/llm-vegas"
  url "https://github.com/todokr/llm-vegas/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6f14b8ce10758798487c34362b2323550917425638500939046f2616bdc9ad99"
  license "EPL-2.0"

  depends_on "node" => :build
  depends_on :macos

  def install
    system "npm", "ci"
    system "npm", "run", "build"
    # electron は実行時に要るので、開発依存だけを落とす
    system "npm", "prune", "--omit=dev"

    libexec.install Dir["*"]

    # electron のバイナリを直接叩く。実行時に node は要らない
    (bin/"llm-vegas").write <<~SH
      #!/bin/bash
      exec "#{libexec}/node_modules/electron/dist/Electron.app/Contents/MacOS/Electron" \\
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
    assert_predicate libexec/"node_modules/electron/dist/Electron.app/Contents/MacOS/Electron", :executable?
  end
end
