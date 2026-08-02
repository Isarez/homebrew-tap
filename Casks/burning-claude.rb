cask "burning-claude" do
  version "1.0.0"
  sha256 "1bcccf9d2caae356a3464199d15dab52c6e75c9017ba2bb571bd0dd025a449f9"

  url "https://github.com/Isarez/burning-claude/releases/download/v#{version}/BurningClaude-#{version}.zip"
  name "Burning Claude"
  desc "Menu bar app that tracks Claude usage and rate limits across accounts"
  homepage "https://github.com/Isarez/burning-claude"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "BurningClaude.app"

  # Homebrew quits the running copy by bundle identifier before replacing it,
  # which is what the .pkg's preinstall script does on the other install route.
  uninstall quit: "com.local.burningclaude"

  # The pre-rename identifiers are listed too: an install that predates the
  # rename leaves state under both names, and `brew uninstall --zap` is the
  # only thing that will ever look for it.
  zap trash: [
    "~/Library/Application Support/BurningClaude",
    "~/Library/Application Support/ClaudeTokenMeter",
    "~/Library/Preferences/com.local.burningclaude.plist",
    "~/Library/Preferences/com.local.claudetokenmeter.plist",
  ]

  caveats <<~EOS
    Burning Claude is ad-hoc signed rather than notarized, so Gatekeeper will
    refuse to open it until the quarantine flag Homebrew sets is cleared:

      xattr -dr com.apple.quarantine "/Applications/BurningClaude.app"

    (Homebrew 6 removed the --no-quarantine flag, so this is the way.)

    Session keys are kept in the login keychain and are not removed by
    `brew uninstall --zap`. To delete them, search the Keychain Access app for
    "com.local.claudetokenmeter.sessionkey".
  EOS
end
