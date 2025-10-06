#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
log="logs/access.log"

total=$(wc -l < "$log" | tr -d ' ')
unique_ips=$(awk '{print $1}' "$log" | sort | uniq | wc -l | tr -d ' ')
top_ip=$(awk '{print $1}' "$log" | sort | uniq -c | awk '{printf "%s %s\n", $1, $2}' | sort -k1,1nr -k2,2 | head -n1 | awk '{print $2}')
num_4xx=$(awk '{s=$9} s ~ /^[4][0-9][0-9]$/ {c++} END{print c+0}' "$log")
num_5xx=$(awk '{s=$9} s ~ /^[5][0-9][0-9]$/ {c++} END{print c+0}' "$log")

top_endpoint=$(awk -v dq='"'"'" '{
  req=$0; m=index(req, dq); if (m==0) next;
  rest=substr(req, m+1); n=index(rest, dq); if (n==0) next;
  inside=substr(rest, 1, n-1); split(inside, parts, " ");
  path=parts[2]; split(path, pq, "?"); print pq[1];
}' "$log" | sort | uniq -c | awk '{printf "%s %s\n", $1, $2}' | sort -k1,1nr -k2,2 | head -n1 | awk '{print $2}')

{
  echo "total_requests=$total"
  echo "unique_ips=$unique_ips"
  echo "top_ip=$top_ip"
  echo "num_4xx=$num_4xx"
  echo "num_5xx=$num_5xx"
  echo "top_endpoint=$top_endpoint"
} > summary.txt
