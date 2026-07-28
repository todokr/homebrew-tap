class Wt < Formula
  desc "git worktree switcher with Claude Code history preview"
  homepage "https://github.com/todokr/wt"
  version "0.3.0"

  depends_on "fzf"

  on_macos do
    on_arm do
      url "https://github.com/todokr/wt/releases/download/v#{version}/wt-aarch64-apple-darwin"
      sha256 "1f33f5a14f12255fbfc87a291196ad015800d8930176cf90dce46ba7d0c4c7ec"

      def install
        bin.install "wt-aarch64-apple-darwin" => "wt"
      end
    end
    on_intel do
      url "https://github.com/todokr/wt/releases/download/v#{version}/wt-x86_64-apple-darwin"
      sha256 "0c1affe4900379069afe6b72c36ac9b1df8a81e1d2db118aee5120ec55142ebe"

      def install
        bin.install "wt-x86_64-apple-darwin" => "wt"
      end
    end
  end

  on_linux do
    url "https://github.com/todokr/wt/releases/download/v#{version}/wt-x86_64-unknown-linux-gnu"
    sha256 "c7b0d012b93d622ac1b6e475c65b161b8e2795872a2fe9fad075c8f5a9774c99"

    def install
      bin.install "wt-x86_64-unknown-linux-gnu" => "wt"
    end
  end

  def caveats
    <<~CAVEATS
      cd 連携を有効にするには、シェル設定に以下を追記してください:
        eval "$(wt init zsh)"   # bash なら zsh を bash に置換

      Claude Code の会話履歴プレビューを使うには、~/.claude/projects/ に
      Claude Code のセッション履歴 (.jsonl) が存在している必要があります。
    CAVEATS
  end

  test do
    # wt init zsh は git repo に依存しないため brew test で使いやすい
    assert_match "wt シェル統合", shell_output("#{bin}/wt init zsh")
  end
end
