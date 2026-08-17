-- Obejście buga w SbarLua: właściwość "script" (string) potrafi nie przejść
-- poprawnie przez item:set({...}), mimo że np. update_freq (liczba) przechodzi bez
-- problemu (widoczne w `sketchybar --query <item>` jako "script": ""). Zamiast tego
-- wołamy bezpośrednio binarkę sketchybar przez sbar.exec, tak jak zrobiłby to
-- klasyczny bash-owy config - to na pewno działa.

local sbar = require("sketchybar")

local helpers = {}

-- item_name: string, script_path: string (pełna ścieżka), freq: number (sekundy)
function helpers.set_script(item_name, script_path, freq)
  sbar.exec(string.format(
    "sketchybar --set '%s' script='%s' update_freq=%d",
    item_name, script_path, freq
  ))
end

-- Akcje kliknięcia wykonujemy natywnie po stronie SketchyBara. Dzięki temu
-- pozostają dostępne również wtedy, gdy proces Lua jest właśnie restartowany
-- podczas reloadu konfiguracji.
function helpers.set_click_script(item_name, script_path)
  sbar.exec(string.format(
    "sketchybar --set '%s' click_script='%s'",
    item_name, script_path
  ))
end

function helpers.subscribe(item_name, event_name)
  sbar.exec(string.format(
    "sketchybar --subscribe '%s' '%s'",
    item_name, event_name
  ))
end

return helpers
