#!/usr/bin/env bash

placement_rows_ranked() {
  local assets=$1
  require_sqlite
  sqlite3 :memory: \
    "CREATE TABLE attachment(id TEXT, pool TEXT, leaf TEXT);" \
    ".separator \"\t\"" \
    ".import '/dev/stdin' attachment" \
    ".read '$assets/placement.sql'"
}

placement_tree() {
  local id pool leaf shown_leaf='' shown_pool=''
  while IFS=$'\t' read -r leaf pool id; do
    if [[ "$leaf" != "$shown_leaf" ]]; then
      printf '%s\n' "$leaf"
      shown_leaf=$leaf; shown_pool=''
    fi
    if [[ "$pool" != "$shown_pool" ]]; then
      printf '    volume pool %s\n' "$pool"
      shown_pool=$pool
    fi
    printf '        %s\n' "$id"
  done
}

volume_show() {
  local assets=$1 rows
  rows=$(placement_rows_ranked "$assets")
  [[ -n "$rows" ]] || die "no placement rows on stdin - pipe in the table Hetzner support sent you"
  printf '%s\n' "$rows" | placement_tree
}
