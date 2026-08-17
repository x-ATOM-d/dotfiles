-- Ikony Nerd Font (Font Awesome). Wymagają JetBrainsMono Nerd Font (lub innej Nerd Font).
local icons = {
  ram      = "\u{f2db}", -- 
  disk     = "\u{f0a0}", -- disk
  mic      = "\u{f130}", -- microphone
  camera   = "\u{f030}", -- camera
  previous = "\u{f048}",
  play     = "\u{f04b}",
  next     = "\u{f051}",
  pause    = "\u{f04c}",
  battery  = {
    _100     = "\u{f240}", -- 
    _75      = "\u{f241}", -- 
    _50      = "\u{f242}", -- 
    _25      = "\u{f243}", -- 
    _0       = "\u{f244}", -- 
    charging = "\u{f0e7}", -- 
  },
  volume = {
    _100  = "\u{f028}", -- 
    _66   = "\u{f027}", -- 
    _33   = "\u{f026}", -- 
    _0    = "\u{f026}", -- 
    muted = "\u{f6a9}", -- 
  },
  weather  = "\u{f0c2}", -- 
  music    = "\u{f001}", -- 
  calendar = "\u{f133}", -- 
  clock    = "\u{f017}", -- 
  wifi     = "\u{f1eb}", -- wifi symbol
  brew     = "\u{f0fc}", -- beer mug (Homebrew)
}

return icons
