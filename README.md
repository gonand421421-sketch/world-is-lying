# THE WORLD IS LYING

A self-contained, ten-room Roblox psychological horror puzzle chapter. All geometry, lighting, UI, interactions, and gameplay scripts are generated from [TheWorldIsLyingGenerator.lua](TheWorldIsLyingGenerator.lua). No external models, textures, audio, packages, HTTP calls, or credentials are needed.

## Generate and play

1. Open a new Baseplate place in Roblox Studio. Use a separate place or save a backup first: the generator changes global lighting.
2. Stay in **Edit mode**. Open **View → Command Bar**.
3. Copy the **entire contents** of `TheWorldIsLyingGenerator.lua` into the Command Bar and execute it. Do not paste Markdown fences. Do not put the generator inside a runtime Script: creating script source is an Edit-mode operation.
4. Save the place, then press **Play**. Your character spawns in Room 01. Read the wall behind the entrance and use proximity prompts (E on keyboard; Roblox supplies touch/gamepad interaction).
5. Use Studio's **Test → Server & Clients** with at least two players to check multiplayer independently.

Re-running the generator replaces its `Workspace.TWIL` model, `ServerScriptService.TWIL_Server`, `ReplicatedStorage.TWIL_Remote`, `StarterPlayerScripts.TWIL_Client`, and its two named Lighting effects. Other scene objects remain. Existing spawn locations or custom character/controller scripts in an established place can interfere; the intended starting point is a fresh place. The generated experience does not require Script Injection or HTTP permissions.

The ten enclosed rooms have solid foundations, walls, ceilings, doors, signs, lamps, ribs, pipes, scattered papers, benches, and puzzle-specific props. Doors use an opening echo and a personal room transition, so another player's door progress never grants access to your next room. The statue is rendered separately for each player. Progress and checkpoints are authoritative on the server, with camera direction supplied by the client for the gaze puzzle. This is a playable chapter scaffold, not an anti-cheat system.

Checkpoints persist through character death **within the current server session**. They do not persist after leaving or server shutdown; no DataStore is used. Completing an ending ends that player's chapter for the session; stop/restart Play or rejoin to replay.

## Rooms and solutions — spoilers

| Room | Deception | Solution |
| --- | --- | --- |
| 01 — The Welcome | Doors promise safety | Choose **I DO NOT KNOW**, then use the central exit. False doors return you to the entrance. |
| 02 — The Floor Lies | Red seems dangerous | Follow the continuous red tiles beneath the pale ceiling marks, then activate the far switch. Wrong tiles reset your position. |
| 03 — Do Not Look Away | A still statue approaches | Keep the statue in view while going around it to the seal, break the seal, and leave. Stay several studs away. Turning away makes it move. |
| 04 — You Have Been Here | A repeating corridor | Read the low scratch sign. Choose **LEFT, RIGHT, LEFT**, returning to the entrance after each of the first two choices. Then take the central exit. A wrong turn resets the sequence. |
| 05 — Please Be Silent | Silence means movement | Stand still inside the pale square for seven seconds. The HUD shows the count. No microphone access is involved. |
| 06 — The Other Side | Reversed mirror symbols | The panel shows III, II, I; press **I, II, III** on the pedestals. A wrong press resets the sequence. |
| 07 — Nothing Is Missing | The floor disappears | Follow the continuous pale path to the far switch. Dark tiles alternate every 2.5 seconds and reset you when absent. The solid catch floor prevents void falls. |
| 08 — For Your Safety | Cameras claim to protect you | Wait for all eyes to go dark, then run across the monitored central region to the terminal. Cameras alternate four seconds watching / four seconds dark. Disconnect them, then leave. |
| 09 — The Witness | Contradictory records | Choose **1971**, the witness present when the building opened. |
| 10 — The World Is Lying | Your identity is the final lock | Read your file at the desk. Choose **REMEMBER** or **FORGET** for different mystery endings. The normal exit intentionally stays closed. |

The mirror uses a reflective material and a reversed inscription; it is **not** a live reflected image of the avatar. There is no audio track or voice monitoring. Atmosphere comes from lighting, architecture, text, timing, and the moving witness.

## Review and Studio validation

Repository review covers generated object names, room/action routing, checkpoint transitions, puzzle sequences, hazard regions, sign orientation, remote input checks, and player-state cleanup. A lightweight local construction fixture passed: ten enclosed room models, ten exit doors, 28 routed interaction prompts, and 56 floor tiles with connected safe paths. The generator parsed with a local Lua parser; both embedded scripts also parsed after substituting Luau’s `continue` keyword for parser compatibility. These checks do not execute Roblox APIs, validate native Luau compilation, or simulate gameplay. No Roblox engine or Studio is available in the authoring environment, so a complete playable-run claim cannot be made here.

Before publishing the game, run these checks in Studio:

- Generate in Edit mode, save, and Play. Confirm there are ten room models and no errors in Output. Generate a second time in Edit mode to check replacement without duplicate TWIL objects.
- Complete all ten solutions above. Verify failed doors, wrong floor routes, a wrong corridor choice, and a wrong mirror press reset the intended state. Check signs from the entrance and near each puzzle.
- In Room 03, watch the statue, then turn away; confirm it stops/moves accordingly. Approach from the side while maintaining gaze and reach the seal. Test first- and third-person camera views.
- In Room 05, verify walking and jumping interrupt stillness and that the count reaches seven while stationary.
- In Room 08, verify red-eye exposure returns the player and that the four-second dark crossing is achievable with default character movement.
- Reset your character after unlocking a room and after entering the next room. Verify the checkpoint and unlocked status. Leave/rejoin to confirm session-only progress is clear.
- With two clients, place them in different rooms and solve independently. Verify one player's statue, reset, door transition, and ending do not advance another. Verify players can pass through each other.
- Check prompts and HUD on desktop, mobile emulation, and gamepad. Test streaming if you enable it; this generator leaves the place's streaming settings unchanged. Test on target devices for lighting/readability and performance.
- Test both endings in separate play sessions. No teleport to another place occurs; the ending is a local narrative overlay.

Do not treat these Studio checks as already passed. Adjusting puzzle difficulty, device presentation, or Roblox-specific behavior after testing is a normal next development step.
