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
# - `version :latest` + `sha256 :no_check`: l'app è a rilascio continuo e si
#   auto-aggiorna via Sparkle, quindi non manteniamo un hash per ogni versione.
# - `auto_updates true`: dice a Homebrew che è Sparkle a gestire gli update
#   (brew non prova a "rimpiazzarla" a ogni upgrade).
cask "notchtop" do
  version :latest
  sha256 :no_check

  url "https://notchontop.vercel.app/downloads/NotchTOP.dmg"
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
