#!/bin/bash

purge_snapshots() {
  echo -e "\n  Purging snapshots for: $1"
  snapshots=$(zfs list -t snapshot -H -o name -S creation "$1" | grep ^"$1"@auto)
  if [ $? -ne 0 ]; then
    echo "Error: zfs list with grep failed" >&2
    exit 4
  fi
  if [[ -z "$snapshots" ]]; then
    echo -e "\n    No snapshots found for dataset"
    return 0
  fi
  echo -e "\n    Existing snapshots for $1:\n"
  echo "$snapshots"
  old_snapshots=$(echo "$snapshots" | tail -n +"$(($2 + 1))")
  if [[ -z "$old_snapshots" ]]; then
    echo -e "\n    Not enough old snapshots too purge"
    return 0
  fi
  echo -e "\n    Deleting the following old snapshots:\n"
  echo "$old_snapshots"
  echo "$old_snapshots" | xargs -n 1 zfs destroy -r
  if [ $? -ne 0 ]; then
    echo "Error: xargs zfs destroy failed" >&2
    exit 5
  fi
}

create_snapshots() {
  formatted_date="$(date +"%Y-%m-%d_%H-%M-%S")"
  while read -r dataset; do
    echo -e "\nCreating snapshot for: $dataset"
    snapshot_name="${dataset}@auto-${formatted_date}"
    zfs snapshot "$snapshot_name"
    if [ $? -ne 0 ]; then
      echo "Error: zfs snapshot failed" >&2
      exit 6
    fi
    echo -e "\n  Snapshot created: $snapshot_name"
    purge_snapshots "$dataset" "$2"
  done <<< "$1"
}

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 poolname retentioncount"
  exit 1
fi

if [[ -z "$1" ]]; then
  echo "poolname cannot be empty"
  exit 2
fi

if [[ "$2" -le 0 ]]; then
  echo "retentioncount must be a positive number"
  exit 3
fi

datasets=$(zfs list -H -o name -r "$1")
if [ $? -ne 0 ]; then
  echo "Error: zfs list failed" >&2
  exit 4
fi

echo -e "Datasets in pool $1:\n"
echo "$datasets"
create_snapshots "$datasets" "$2"
