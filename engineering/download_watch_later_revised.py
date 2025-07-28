#!/usr/bin/python3

import json
import subprocess
import os

# === CONFIG ===
json_path = 'full_playlist.json'
progress_file = 'downloaded_ids.txt'
cookies_file = 'cookies.txt'
yt_dlp_path = 'yt-dlp'
audio_format = 'mp3'
output_template = '%(uploader)s/%(title)s.%(ext)s'

# === LOAD JSON ===
with open(json_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

videos = data.get('entries', [])
print(f"Found {len(videos)} videos in playlist.")

# === LOAD PROGRESS FILE ===
downloaded = set()
if os.path.exists(progress_file):
    with open(progress_file, 'r', encoding='utf-8') as f:
        downloaded = set(line.strip() for line in f if line.strip())

# === MAIN DOWNLOAD LOOP ===
for video in videos:
    video_id = video['id']
    title = video.get('title', '[No title]')
    url = f'https://www.youtube.com/watch?v={video_id}'

    if video_id in downloaded:
        print(f"[✓] Already downloaded: {title}")
        continue

    print(f"[▶] Downloading: {title}")

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

