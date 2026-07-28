class Wt < Formula
  desc "git worktree switcher with Claude Code history preview"
  homepage "https://github.com/todokr/wt"
  version "0.3.1"

  depends_on "fzf"

  on_macos do
    on_arm do
      url "https://github.com/todokr/wt/releases/download/v#{version}/wt-aarch64-apple-darwin"
      sha256 "ac8a134c1457c370b596be148e8b56e05ea927142ffae40f7840ea7ea0d0f7f8"

      def install
        bin.install "wt-aarch64-apple-darwin" => "wt"
      end
    end
    on_intel do
      url "https://github.com/todokr/wt/releases/download/v#{version}/wt-x86_64-apple-darwin"
      sha256 "e042897e6926da85c9918fad6830754dc30a3428c0345cd3803ccdfa13ca6bb1"

      def install
        bin.install "wt-x86_64-apple-darwin" => "wt"
      end
    end
  end

  on_linux do
    url "https://github.com/todokr/wt/releases/download/v#{version}/wt-x86_64-unknown-linux-gnu"
    sha256 "838e5b6f5608859d5f9eca42e90d104f29de0ff8fdf19318ccdb3b41fe4975c0"

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
