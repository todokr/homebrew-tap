class Wt < Formula
  desc "git worktree switcher with Claude Code history preview"
  homepage "https://github.com/todokr/wt"
  version "0.3.2"

  depends_on "fzf"

  on_macos do
    on_arm do
      url "https://github.com/todokr/wt/releases/download/v#{version}/wt-aarch64-apple-darwin"
      sha256 "a4ef1315b994c25235b0f482f7c2aefc7bcec800779563a11952c9dc1931cab6"

      def install
        bin.install "wt-aarch64-apple-darwin" => "wt"
      end
    end
    on_intel do
      url "https://github.com/todokr/wt/releases/download/v#{version}/wt-x86_64-apple-darwin"
      sha256 "045b6b5dc0e04e69521677ddc7db23482411664bf373c8cfcfa2a49692186855"

      def install
        bin.install "wt-x86_64-apple-darwin" => "wt"
      end
    end
  end

  on_linux do
    url "https://github.com/todokr/wt/releases/download/v#{version}/wt-x86_64-unknown-linux-gnu"
    sha256 "999dee5884e8711a8b3325332e13572f705a1b7c3580c3731b935d4e11501e76"

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
