#!/bin/bash
set -e
cd <project-dir>
F=files
W=hidden_files/ep01-60s/work
S1=$(ls $F/media-generation-ep01-shot01c-10s-*.mp4)
S2=$(ls $F/media-generation-ep01-shot02b-10s-*.mp4)
S3=$(ls $F/media-generation-ep01-shot03b-10s-*.mp4)
S4=$(ls $F/media-generation-ep01-shot04-10s-*.mp4)
S5=$(ls $F/media-generation-ep01-shot05c-10s-*.mp4)
LOGO=<original-logo-png>
MUSIC=<background-music.mp3>
OUT=$W/ep01-60s-v3-novoice.mp4
MI="minterpolate=fps=24:mi_mode=blend"
ffmpeg -y -loglevel error \
 -i "$S1" -i "$S2" -i "$S3" -i "$S4" -i "$S5" \
 -loop 1 -t 4 -i "$LOGO" \
 -filter_complex "\
[0:v]scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,fps=24,setpts=PTS-STARTPTS,format=yuv420p[v0]; \
[1:v]setpts=1.2*PTS,$MI,scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,fps=24,format=yuv420p[v1]; \
[2:v]setpts=1.4*PTS,$MI,scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,fps=24,format=yuv420p[v2]; \
[3:v]setpts=1.4*PTS,$MI,scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,fps=24,format=yuv420p[v3]; \
[4:v]trim=0:6,setpts=PTS-STARTPTS,scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280,fps=24,format=yuv420p[v4]; \
color=c=0xe9e9e9:s=720x1280:r=24:d=4[bg]; \
[5:v]scale=560:-1,format=rgba,fade=t=in:st=0:d=1:alpha=1[lg]; \
[bg][lg]overlay=(W-w)/2:(H-h)/2,format=yuv420p[v5]; \
[v0][v1][v2][v3][v4][v5]concat=n=6:v=1:a=0[vout]" \
 -map "[vout]" -c:v libx264 -crf 20 -preset veryfast -movflags +faststart -an "$OUT"
echo "video-only v3 done"
ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUT"
# Pass 2: audio + logo-on-lens + subtitles
ffmpeg -y -loglevel error \
 -i "$OUT" \
 -i "$MUSIC" \
 -i "$W/n01.mp3" -i "$W/n02.mp3" -i "$W/n03.mp3" -i "$W/n04.mp3" -i "$W/n05.mp3" -i "$W/n06.mp3" -i "$W/n07.mp3" -i "$W/n08.mp3" -i "$W/n09.mp3" \
 -filter_complex "\
[1:a]atrim=0:60,asetpts=PTS-STARTPTS,volume=0.22,afade=t=out:st=58:d=2[music]; \
[2:a]adelay=300|300[a1]; [3:a]adelay=2900|2900[a2]; [4:a]adelay=10300|10300[a3]; [5:a]adelay=12500|12500[a4]; [6:a]adelay=22300|22300[a5]; [7:a]adelay=25400|25400[a6]; [8:a]adelay=36300|36300[a7]; [9:a]adelay=50300|50300[a8]; [10:a]adelay=56300|56300[a9]; \
[music][a1][a2][a3][a4][a5][a6][a7][a8][a9]amix=inputs=10:normalize=0:duration=first,volume=1.0[aout]; \
[0:v]drawtext=fontfile=/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc:text='概念CG · 非实拍':fontsize=18:fontcolor=white@0.85:borderw=1:bordercolor=black@0.6:x=520:y=16,subtitles='$W/ep01-60s.srt':fontsdir=/usr/share/fonts/opentype/noto:force_style='PlayResX=720,PlayResY=1280,FontName=Noto Sans CJK SC,FontSize=26,PrimaryColour=&HFFFFFF,OutlineColour=&H000000,BorderStyle=1,Outline=2,Shadow=0,MarginV=50,Alignment=2'[vout]" \
 -map "[vout]" -map "[aout]" -c:v libx264 -crf 20 -preset veryfast -c:a aac -b:a 128k -movflags +faststart -t 60 files/ep01-60s-narrated-v3.mp4
echo "final v3 done"
ffprobe -v error -show_entries format=duration,size -of default=noprint_wrappers=1 files/ep01-60s-narrated-v3.mp4
ls -lh files/ep01-60s-narrated-v3.mp4
