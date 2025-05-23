used=$(vm_stat | awk '
  /Pages active/ {active=$3}
  /Pages wired down/ {wired=$4}
  /Pages speculative/ {speculative=$3}
  /Pages free/ {free=$3}
  END {
    used = active + wired + speculative
    total = used + free
    if (total > 0) {
      printf "%.0f", (used/total)*100
    } else {
      print "N/A"
    }
  }')
echo "${used}% RAM"
