#!/bin/bash
# "Memory Used" zgodnie z Activity Monitor / Stats:
#   (active + inactive + speculative + wired + compressed - purgeable - external) * pagesize
# Poprzednia wersja pomijała inactive, speculative, external i purgeable, przez co
# zaniżała wynik względem Stats (często o 10-15 p.p.).
RAM_INFO=$(vm_stat)
PAGE_SIZE=$(sysctl -n hw.pagesize)

# vm_stat podaje liczby stron z kropką na końcu (np. "109288."); usuwamy ją przez tr.
field() { echo "$RAM_INFO" | awk "/$1/ {print \$$2}" | tr -d '.'; }

PAGES_ACTIVE=$(field 'Pages active' 3)
PAGES_INACTIVE=$(field 'Pages inactive' 3)
PAGES_SPECULATIVE=$(field 'Pages speculative' 3)
PAGES_WIRED=$(field 'Pages wired down' 4)
PAGES_COMPRESSED=$(field 'Pages occupied by compressor' 5)
PAGES_PURGEABLE=$(field 'Pages purgeable' 3)
PAGES_EXTERNAL=$(field 'File-backed pages' 3)

PAGES_ACTIVE=${PAGES_ACTIVE:-0}
PAGES_INACTIVE=${PAGES_INACTIVE:-0}
PAGES_SPECULATIVE=${PAGES_SPECULATIVE:-0}
PAGES_WIRED=${PAGES_WIRED:-0}
PAGES_COMPRESSED=${PAGES_COMPRESSED:-0}
PAGES_PURGEABLE=${PAGES_PURGEABLE:-0}
PAGES_EXTERNAL=${PAGES_EXTERNAL:-0}
PAGE_SIZE=${PAGE_SIZE:-4096}

TOTAL_MEM=$(sysctl -n hw.memsize)

USED=$(( (PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_WIRED + PAGES_COMPRESSED - PAGES_PURGEABLE - PAGES_EXTERNAL) * PAGE_SIZE ))
PERCENTAGE=$(( 100 * USED / TOTAL_MEM ))

sketchybar --set "$NAME" label="${PERCENTAGE}%"
