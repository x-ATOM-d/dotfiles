# tmux — skróty klawiszowe (ATOM)

Konfiguracja: `~/.config/tmux/tmux.conf` (XDG, pod kontrolą wersji przez symlink do `~/.dotfiles`).
Wszystkie skróty poniżej zostały odczytane bezpośrednio z działającego serwera tmux
(`tmux list-keys`) — nie są zgadywane.

Prefix to **Ctrl-a** (oryginalne Ctrl-b zostało odpięte).
Zapis skrótów: `prefix` = Ctrl-a, a po nim kolejny klawisz.
Przykład: `prefix + |` znaczy: wciśnij Ctrl-a, puść, wciśnij `|`.

---

## 1. Sesje i okna (najczęściej używane)

| Skrót            | Działanie                                  |
|------------------|--------------------------------------------|
| `prefix + c`     | Nowe okno (window)                         |
| `prefix + n`     | Następne okno                              |
| `prefix + p`     | Poprzednie okno                            |
| `prefix + 1–9`   | Skok do okna o numerze 1–9 (base-index 1)  |
| `prefix + 0`     | Brak efektu — okno 0 nie istnieje przy base-index 1 |
| `prefix + ,`     | Zmień nazwę bieżącego okna                 |
| `prefix + &`     | Zamknij okno (z potwierdzeniem)            |
| `prefix + w`     | Drzewo okien (wybór z listy)               |
| `prefix + s`     | Drzewo sesji (wybór z listy)               |
| `prefix + d`     | Odłącz klienta (detach) — sesja zostaje   |
| `prefix + $`     | Zmień nazwę sesji                          |
| `prefix + L`     | Przełącz na ostatnio używaną sesję klienta |
| `prefix + (` / `)` | Przełącz między sesjami (poprz./nast.)   |

## 2. Panele (splitowanie i nawigacja)

| Skrót            | Działanie                                          |
|------------------|----------------------------------------------------|
| `prefix + |`     | Podziel panel poziomo (horyzontalnie, lewo-prawo)  |
| `prefix + -`     | Podziel panel pionowo (wertykalnie, góra-dół)      |
| `prefix + h`     | Skocz do panelu po lewej (vimowo)                  |
| `prefix + j`     | Skocz do panelu poniżej                            |
| `prefix + k`     | Skocz do panelu powyżej                            |
| `prefix + l`     | Skocz do panelu po prawej                          |
| `prefix + o`     | Następny panel (cyklicznie)                        |
| `prefix + q`     | Pokaż numery paneli (naciśnij nr, by wybrać)       |
| `prefix + z`     | Zoom/odzoom panelu (pełny ekran)                   |
| `prefix + x`     | Zamknij panel (z potwierdzeniem)                  |
| `prefix + ;`     | Ostatnio używany panel                             |
| `prefix + !`     | Wyrwij panel do nowego okna                        |
| `prefix + {` / `}` | Zamień panel z górnym/dolnym sąsiadem            |

## 3. Zmiana rozmiaru paneli

| Skrót              | Działanie                     |
|--------------------|-------------------------------|
| `prefix + C-h`     | Zwiększ panel w lewo o 5      |
| `prefix + C-j`     | Zwiększ panel w dół o 5       |
| `prefix + C-k`     | Zwiększ panel w górę o 5      |
| `prefix + C-l`     | Zwiększ panel w prawo o 5     |
| `prefix + M-Up/Down/Left/Right` | Zmień rozmiar o 5 (Alt+strzałki) |
| `prefix + C-Up/Down/Left/Right` | Zmień rozmiar o 1 (Ctrl+strzałki) |

## 4. Kopiowanie i schowki (tryb vi)

| Skrót            | Działanie                                           |
|------------------|-----------------------------------------------------|
| `prefix + [`     | Wejdź w tryb kopiowania (copy-mode)                 |
| `prefix + ]`     | Wklej ze schowka (paste-buffer)                     |
| `prefix + PPage` | Tryb kopiowania (scroll w górę)                     |
| `v` (w copy-mode)| Rozpocznij zaznaczanie (jak w vimie)               |
| `y` (w copy-mode)| Skopiuj zaznaczenie i wyjdź (copy-selection)        |
| `prefix + =`     | Wybierz bufor ze schowka (choose-buffer)            |
| `prefix + #`     | Lista buforów                                       |

W trybie copy-mode działają też strzałki, `/` i `?` (szukaj), `g`/`G` (góra/dół historii).

## 5. Układy (layouts)

| Skrót            | Działanie                                  |
|------------------|--------------------------------------------|
| `prefix + Space` | Przełączaj między gotowymi układami       |
| `prefix + M-1`   | even-horizontal                            |
| `prefix + M-2`   | even-vertical                              |
| `prefix + M-3`   | main-horizontal                            |
| `prefix + M-4`   | main-vertical                              |
| `prefix + M-5`   | tiled                                      |
| `prefix + E`     | Wymuś ponowne rozmieszczenie (select-layout -E) |

## 6. Wtyczki (TPM) i przywracanie sesji

| Skrót            | Działanie                                                      |
|------------------|----------------------------------------------------------------|
| `prefix + I`     | Zainstaluj / pobierz wtyczki (po edycji listy `@plugin`)       |
| `prefix + U`     | Zaktualizuj wtyczki                                            |
| `prefix + M-u`   | Wyczyść nieużywane wtyczki                                     |
| `prefix + S`     | **Zapisz sesję ręcznie** (tmux-resurrect)                      |
| `prefix + R`     | **Przywróć sesję ręcznie** (tmux-resurrect)                    |

Auto-zapis: co 15 min (tmux-continuum, `@continuum-save-interval '15'`).
Auto-przywracanie: włączone (`@continuum-restore 'on'`) — po otwarciu terminala po
rebecie sesje wskakują z powrotem same (działa przy podpięciu klienta).

## 7. Konfiguracja i pomoc

| Skrót            | Działanie                                           |
|------------------|-----------------------------------------------------|
| `prefix + r`     | Przeładuj config (`~/.config/tmux/tmux.conf`)       |
| `prefix + ?`     | Pokaż wszystkie skróty (list-keys)                  |
| `prefix + t`     | Tryb zegara (clock-mode)                            |
| `prefix + i`     | Pokaż info o panelu (display-message)              |
| `prefix + C`     | Tryb dostosowywania skrótów (customize-mode)        |
| `prefix + :`     | Wpisz komendę tmux bezpośrednio (command-prompt)    |
| `prefix + ~`     | Pokaż komunikaty serwera (show-messages)            |

## 8. Mysz (włączona: `set -g mouse on`)

- Scroll kółkiem w panelu → przewijanie historii (wchodzi w copy-mode).
- Kliknięcie panelu → zaznacz go.
- Przeciąganie krawędzi → zmiana rozmiaru panelu.
- Prawy przycisk → menu kontekstowe (podział, zamknięcie, zoom itd.).

---

## 1b. Szybki skok do okien z poziomu WezTerm (`Cmd+0–9`)

W samym tmuxie skok wymaga prefixa (`prefix + cyfra`). WezTerm przechwytuje
klawisz `Cmd` i sam wysyła do tmux gotową sekwencję (`Ctrl-a` + cyfra), więc
nie musisz łapać prefixa klawiaturą — wystarczy kciuk na `Cmd`.

Konfiguracja siedzi w `~/.wezterm.lua` (sekcja `config.keys`):

| Skrót          | Działanie (wysyłane do tmux)              | Skok do okna |
|----------------|-------------------------------------------|--------------|
| `Cmd+1` … `Cmd+9` | `Ctrl-a` + `1` … `Ctrl-a` + `9`        | 1 – 9        |
| `Cmd+0`        | `Ctrl-a` + `1` + `0`                      | 10           |

Dlaczego `Cmd+0` → okno 10, a nie 0? Bo przy `base-index 1` nie ma okna 0;
`Cmd+0` wysyła dwucyfrowe "10", więc trafia na dziesiąte okno.

Uwaga: te wiazania działają zawsze (WezTerm nie sprawdza, czy jesteś w tmuxie).
Poza tmuxem `Cmd+3` wpisałoby w powłokę literę `a3`. Przy stałym używaniu tmuxa
to nie przeszkadza.

Aktywacja: `Ctrl+Shift+R` w WezTerm (reload config) lub restart terminala.

---

## Pliki

- `~/.config/tmux/tmux.conf` — aktywny config (to plik, którego tmux szuka w XDG).
- `~/.tmux/plugins/` — wtyczki (TPM, resurrect, continuum).
- `~/.tmux/resurrect/` — zrzuty sesji do przywrócenia.
- `~/.tmux.conf.bak.20260803` — archiwum starego, usuniętego `~/.tmux.conf`.
- `~/.config/tmux/tmux.conf.sh.bak.20260803` — archiwum starego, uszkodzonego szkieletu.

## Szybki start

1. Otwórz terminal → tmux startuje i (po rebecie) sam przywraca sesje.
2. `prefix + c` nowe okno, `prefix + |` / `prefix + -` podział paneli.
3. `prefix + h/j/k/l` nawigacja między panelami.
4. `prefix + r` po zmianie configu; `prefix + I` po dodaniu wtyczki.
5. Przed zamknięciem systemu: `prefix + S` (ręczny zapis dla pewności).
