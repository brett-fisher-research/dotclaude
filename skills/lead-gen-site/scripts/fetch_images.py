#!/usr/bin/env python3
"""
Unsplash image fetcher for lead-gen-site skill.
Called by Claude Code as a subprocess — the API key never enters Claude's context.

Usage:
  python fetch_images.py "roofing,contractor,roof" "coffee,cafe,interior" "team,workers"

Returns JSON to stdout:
  [
    { "query": "roofing,contractor,roof", "url": "https://images.unsplash.com/...", "credit": "Photo by Jane Doe on Unsplash" },
    ...
  ]

Setup:
  1. pip install requests python-dotenv
  2. Create a .env file in your project root (or home dir) with:
       UNSPLASH_ACCESS_KEY=your_access_key_here
"""

import sys
import json
import os

def load_env():
    """Try to load .env using python-dotenv, fail silently if not installed."""
    try:
        from dotenv import load_dotenv
        if os.path.exists(".env"):
            load_dotenv(".env")
    except ImportError:
        pass  # Fall back to environment variables already set in shell

def fetch_image(query: str, access_key: str) -> dict:
    """Fetch a single random photo from Unsplash matching the query."""
    import requests

    url = "https://api.unsplash.com/photos/random"
    headers = {"Authorization": f"Client-ID {access_key}"}
    params = {
        "query": query,
        "orientation": "landscape",
        "content_filter": "high",
    }

    resp = requests.get(url, headers=headers, params=params, timeout=10)
    resp.raise_for_status()
    data = resp.json()

    # Extract the regular-size URL and photographer credit
    image_url = data["urls"]["regular"]  # ~1080px wide, good for web
    photographer = data["user"]["name"]
    profile_link = data["user"]["links"]["html"]

    return {
        "query": query,
        "url": image_url,
        "credit": f"Photo by {photographer} on Unsplash",
        "credit_url": f"{profile_link}?utm_source=lead_gen_site&utm_medium=referral",
    }

def main():
    load_env()

    access_key = os.environ.get("UNSPLASH_ACCESS_KEY")
    if not access_key:
        print(json.dumps({
            "error": "UNSPLASH_ACCESS_KEY not found. Set it in your .env file or shell environment."
        }))
        sys.exit(1)

    queries = sys.argv[1:]
    if not queries:
        print(json.dumps({"error": "No queries provided. Pass keyword strings as arguments."}))
        sys.exit(1)

    if len(queries) > 5:
        print(json.dumps({"error": "Max 5 queries allowed per site to stay within rate limits."}))
        sys.exit(1)

    results = []
    errors = []

    for query in queries:
        try:
            result = fetch_image(query, access_key)
            results.append(result)
        except Exception as e:
            errors.append({"query": query, "error": str(e)})

    output = {"images": results}
    if errors:
        output["errors"] = errors

    print(json.dumps(output, indent=2))

if __name__ == "__main__":
    main()