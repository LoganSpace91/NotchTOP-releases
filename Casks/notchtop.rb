# Homebrew Cask per NotchTOP.
#
# Va pubblicato in un repo GitHub chiamato "homebrew-notchtop" (path: Casks/notchtop.rb),
# così gli utenti installano con:
#   brew tap loganspace91/notchtop
#   brew install --cask notchtop
#
# Perché risolve il problema Gatekeeper: `brew install --cask` scarica il DMG e
# TOGLIE la quarantena prima di copiare l'app in /Applications → niente blocco
# "Apple could not verify…" al primo avvio, anche senza notarizzazione.
#
# Note:
# - Versione e sha256 li riscrive scripts/release.sh a ogni release, e da lì
#   li pubblica anche nella repo dell'archivio (che è la tap). Non modificarli
#   a mano: l'hash deve essere quello del dmg davvero pubblicato.
# - L'url punta all'asset VERSIONATO della release, non al dmg "latest" del
#   sito: quello cambia sotto i piedi a ogni versione e farebbe fallire il
#   controllo dell'hash a tutti.
# - `auto_updates true`: dice a Homebrew che è Sparkle a gestire gli update
#   (brew non prova a "rimpiazzarla" a ogni upgrade).
cask "notchtop" do
  version "1.13.0"
  sha256 "30d67144d5d950c0b4ef2b7ea121fba69998faa94dbaa1ca68155030fc6c486f"

  url "https://github.com/LoganSpace91/NotchTOP-releases/releases/download/v#{version}/NotchTOP-#{version}.dmg",
      verified: "github.com/LoganSpace91/NotchTOP-releases/"
  name "NotchTOP"
  desc "Trasforma il notch del MacBook in un pannello interattivo"
  homepage "https://notchontop.vercel.app/"

  auto_updates true
  depends_on macos: :sonoma # macOS 14+

  app "NotchTOP.app"

  # Il modello di trascrizione (~460 MB) sta fuori dal .app e sopravviverebbe
  # alla disinstallazione. Si toglie la SUA cartella, non la radice FluidAudio:
  # quella è condivisa e ospiterebbe i modelli di altre app.
  # Le riunioni trascritte (Documenti → NotchTOP) NON si toccano: sono roba
  # dell'utente, non dati dell'app.
  zap trash: [
    "~/Library/Application Support/FluidAudio/Models/parakeet-tdt-0.6b-v3",
    "~/Library/Application Support/NotchTOP",
    "~/Library/Caches/com.notchtop.app",
    "~/Library/Preferences/com.notchtop.app.plist",
  ]
end
