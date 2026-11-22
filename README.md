# CG Product Video Workflow

A reusable workflow for building a short CG product video, proven on the Intane Optics EP01 semiconductor inspection video (60 s, 720x1280, 24 fps).

## What is in here

- `SKILL.md` / `skill.yaml` — the workflow as a Muse skill: align intent, build logo-bearing CG stills, animate with a locked camera, narrate and subtitle, assemble with ffmpeg, verify before delivery.
- `references/assemble-template.sh` — the ffmpeg assembly script template (segments, interpolation stretch, narration delays, subtitles, logo tail). Replace the `<...>` placeholders with the project paths.
- `renders/` — CG renders from the EP01 build:
  - `ep01-lens-logo-shot01.png` — opening shot: objective lens with the Intane logo printed on its silver barrel, over the bare die on the stage.
  - `ep01-lens-logo-shot05.png` — closing shot: side profile of the same lens with the logo on the barrel.
  - `segment-at-5s.jpg`, `segment-at-16s.jpg`, `segment-at-29s.jpg`, `segment-at-43s.jpg`, `segment-at-53s.jpg` — one frame from each of the five segments of the finished video.
- `ep01-60s-narrated-v3.mp4` — the finished 60.0 s video (720x1280, 24 fps, ~7.8 MB) with male narration, subtitles and background music.

## Key rules

- The logo is part of the CG product itself, printed on the lens barrel from the original logo file. It is never redrawn by AI, never a corner watermark and never a post-production overlay.
- Camera stays locked on a tripod with only about a 5% slow push, so the product does not morph between frames.
- Stretches use frame interpolation (`minterpolate`, blend mode), never frame duplication.
- Every version is verified before delivery: full decode, scene detection (only planned segment cuts), and frame-by-frame checks of the logo.
