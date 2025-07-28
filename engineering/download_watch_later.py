#!/usr/bin/python3

import os
import json
import subprocess
from pathlib import Path

# === CONFIGURATION ===
json_path = 'msfy_export_playlist_Watch later.json'
progress_file = 'downloaded_ids.txt'
cookies_file = 'cookies.txt'
yt_dlp_path = 'yt-dlp'  # Or full path if not in PATH
audio_format = 'mp3'
output_template = '%(uploader)s/%(title)s.%(ext)s'

# === LOAD PLAYLIST JSON ===
with open(json_path, 'r', encoding='utf-8') as f:
    playlist = json.load(f)

video_entries = playlist['videos']
print(f"Found {len(video_entries)} videos in playlist.")

# === LOAD OR INITIALIZE PROGRESS TRACKER ===
downloaded = set()
if os.path.exists(progress_file):
    with open(progress_file, 'r', encoding='utf-8') as f:
        downloaded = set(line.strip() for line in f if line.strip())

# === MAIN LOOP ===
for video in video_entries:
    video_id = video['id']
    title = video['titleLong']
    url = f'https://www.youtube.com/watch?v={video_id}'

    if video_id in downloaded:
        print(f"[✓] Already downloaded: {title}")
        continue

    print(f"[▶] Downloading: {title}")

    # Construct yt-dlp command
    cmd = [
        yt_dlp_path,
        '--cookies', cookies_file,
        '-f', 'bestaudio',
        url,
        '--extract-audio',
        '--audio-format', audio_format,
        '--audio-quality', '0',
        '--socket-timeout', '5',
        '--output', output_template
    ]

    try:
        subprocess.run(cmd, check=True)
        with open(progress_file, 'a', encoding='utf-8') as f:
            f.write(f'{video_id}\n')
        print(f"[✔] Downloaded: {title}")
    except subprocess.CalledProcessError:
        print(f"[✗] Failed to download: {title}")

