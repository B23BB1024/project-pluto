import os
from pathlib import Path

def read_summary():
    p = Path("/app") / "summary.txt"
    assert p.exists(), "summary.txt must be created in /app"
    kv = dict(line.split("=", 1) for line in p.read_text().strip().splitlines() if "=" in line)
    return kv

def test_total_requests():
    kv = read_summary()
    assert kv.get("total_requests") == "10"

def test_unique_ips():
    kv = read_summary()
    assert kv.get("unique_ips") == "5"

def test_top_ip():
    kv = read_summary()
    assert kv.get("top_ip") == "192.168.0.1"

def test_status_buckets():
    kv = read_summary()
    assert kv.get("num_4xx") == "2"
    assert kv.get("num_5xx") == "1"

def test_top_endpoint():
    kv = read_summary()
    assert kv.get("top_endpoint") == "/index.html"

def test_keys_present():
    kv = read_summary()
    expected = {"total_requests","unique_ips","top_ip","num_4xx","num_5xx","top_endpoint"}
    assert expected.issubset(kv.keys())
