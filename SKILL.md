# CG Product Video Workflow

## Align the intent before you build

- Ask what the video must show and what it must never show, and write the answer down as a short brief before you generate anything.

- Name the protagonist of the video in one sentence, such as the objective lens, and keep every segment about that protagonist.

- Offer a plan with the segment breakdown, the duration of each segment and the total duration, and start building only after the user picks it.

- Do the stills first and the video second, and show the stills for approval before you spend time on video generation.

- Keep reference images authoritative over text prompts, and say so in the prompt when a reference image and the text disagree.

## Build logo bearing CG stills

- Pass the product reference image and the original logo file together to `media.generate_image`, and instruct it to print the logo on the product itself.

- Instruct it to keep the logo colors, lettering and graphics exactly as supplied, with no redrawing, no recoloring and no added text.

- Generate one still per product shot, usually the opening shot and the closing shot, and check each still by reading it back.

- Reject a still whose logo is distorted, misspelled or redrawn, and regenerate it rather than repairing it in post.

- Never use a corner watermark, a hard cut black card or a post production overlay as a substitute for a logo that belongs on the product.

## Animate the segments with a locked camera

- Pass the approved still as the first frame to `media.generate_video`, with the same product reference.

- Lock the camera to a tripod and allow only a very slow push of about 5 percent, with no orbit, no rotation and no angle change.

- Instruct the generator to keep every object in the same shape, size and position for the whole clip, and to keep the logo on the product unchanged.

- Extract one frame per second from each generated clip and compare the first and last frames before you accept it.

- Regenerate a segment whose subject morphs, grows or changes shape, and name the exact defect when you report it.

## Narrate and subtitle

- Write the narration fresh for this video, one short sentence per beat, and keep the total narration shorter than the video so no sentence is rushed.

- Record it with `/opt/hatch/bin/tts speak`, using one voice for the whole video, and keep the voice, speed and language the same across every line.

- Place each line at its segment start, and burn subtitles that match the narration word for word.

- Leave the closing brand line as audio only when a logo is on screen at the same time, so the subtitle does not cover it.

- Add low volume background music under the narration and fade it out in the last two seconds.

## Assemble with ffmpeg

- Scale and crop every segment to the same frame size and frame rate, and stretch a segment only with frame interpolation, never by duplicating frames.

- Use `setpts` to stretch a 10 second clip to its target length, then `minterpolate` with `mi_mode=blend` to smooth it, because the motion compensated mode is too slow for routine use.

- Keep the segment boundaries fixed so the narration and subtitle timings stay valid across versions.

- Add a short closing tail on a plain background with the original logo fading in.

- Mark the video as concept CG on screen throughout when the footage is generated rather than photographed.

## Verify before you deliver

- Check the final file with `ffprobe` for duration, frame size, frame rate, video codec and audio channels, and decode it fully with `ffmpeg` to null.

- Run scene detection at a threshold of 0.12 and confirm the only changes are the planned segment cuts, with no cluster inside a segment.

- Extract frames at the logo moments and at one frame every five seconds, and read them back to confirm the logo, the product and the subtitles.

- Report the defects you found in plain words, and say which parts are AI generated illustration rather than measured fact.

- Deliver only a fully checked file, with its duration and size, and ask once whether it played fully on the user's phone.

## Publish the workflow

- Save the prompts, the segment plan, the narration text and the assembly script with the finished video, so the same workflow can run again with new details.

- Put the CG stills and the segment frames in a `renders` folder, and the skill files at the top level of the published folder.

- Upload text files and images to GitHub only after the user names the repository and branch, and confirm the upload by reading the files back from the repository.

## Available connectors

- [GitHub](/opt/hatch/connectors/github/CONNECTOR.md) for publishing the skill and the CG renders to the user's repository.

- Use `muse.connector_search` to find other connectors and `muse.skill_search` to find related skills.

- If nothing here fits, look on the web for a maintained API or MCP server and set it up with [Custom Connectors and MCPs](/opt/muse/skills/custom-connector-setup/SKILL.md), or build a custom connector.

## Alternatives for better results

- Use a still photo with slow push or pull motion when no verified video fits a segment, and say that the photo is a fallback rather than generated footage.

- Shorten a segment or split it in two when one generated clip cannot hold its subject steady for the full length.

- Ask one focused question when the logo placement and the product realism trade off against each other, rather than rebuilding the whole video.
