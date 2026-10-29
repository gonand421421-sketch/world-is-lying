# THE WORLD IS LYING

A self-contained ten-room Roblox psychological horror puzzle chapter. The **hard-but-fair edition** uses evidence, logic, observation, memory, and deliberate experimentation. There are no random solutions, floor races, camera sprint windows, or precision jumps.

- [Complete generator](TheWorldIsLyingGenerator.lua)
- [Separate solution guide — full spoilers](SOLUTION_GUIDE.md)
- [Local construction and server-logic review fixture](tests/review_generator.lua)

## Generate in Roblox Studio

1. Open a fresh Baseplate place and save a backup.
2. Stay in **Edit mode**, open **View → Command Bar**, and paste the entire contents of `TheWorldIsLyingGenerator.lua`. Execute it once. Do not include Markdown fences or place the generator in a runtime Script.
3. Save the place and press **Play**. Read the reception ledger and use Roblox's proximity prompts to inspect evidence and operate controls.
4. Use the **Notebook** button or **N** to reread evidence and receipts. Use **REQUEST NEXT HINT** or a room's hint terminal only when desired; each room has three tiers.
5. Test solo, then use Studio's **Server & Clients** mode with two players before publishing.

No external assets, packages, HTTP calls, credentials, manual building, voice access, or DataStores are needed. Generated geometry includes ten enclosed rooms, lighting, architectural details, doors, signs, puzzle props, and safe foundations. Room 10 combines earlier evidence into a final audit, followed by a disturbing personal origin file and two ending choices.

Each player has independent inputs, requested hints, receipts, floor exposures, statue state, camera feedback, and checkpoints. Players can pass through each other. Doors animate an opening echo and transfer only the qualifying player to the next enclosed room. Character death retains session progress, including accepted work; leaving the server resets it. Endings complete the current session's chapter; rejoin or restart Play to replay.

Completing a room archives its entire case file automatically, so the finale cannot be blocked by a missed document. Incorrect deductions retain the draft. RESET clears only the current draft. The five-second stillness samples have no deadline and use broad standing areas. Statue controls advance one latched bay per deliberate unobserved lever pull; there is no chase.

## Replacement behavior and limits

Re-running in Edit mode replaces `Workspace.TWIL`, `ServerScriptService.TWIL_Server`, `ReplicatedStorage.TWIL_Remote`, `ReplicatedStorage.TWIL_Config`, `StarterPlayerScripts.TWIL_Client`, and the named TWIL lighting effects. It also configures global lighting. It leaves unrelated scene objects intact. Existing spawn points, custom cameras, character controllers, or scripts can interfere, so begin with a fresh place. This edition replaces the previous generator's puzzle scripts and layout; live server progress is not migrated between editions.

The mirror uses a reversed symbolic inscription and reflective material, not a live avatar reflection. No audio track is generated. The client reports camera direction for the statue's observation condition; the server checks room, proximity, input, and solution state. The configuration is replicated for presentation, so this is not an anti-cheat implementation. Streaming settings are left unchanged and require Studio testing if enabled.

The target first-time room durations are **2–4 minutes early (01–05)** and **4–7 minutes later (06–10)**. These are design goals, not measured results. No forced waiting periods inflate those targets.

## Review evidence

From the repository root:

```bash
texlua tests/review_generator.lua
texlua tests/review_generator.lua forget
```

The local fixture passed ten-room construction, 110 routed prompts, logical solution checks, a complete server-logic path through each ending, hint limits, wrong inputs, retained work, session respawn, finale gates, and separate player progress. The generator and both embedded scripts parse unchanged with the local Lua parser.

**Roblox Studio has not been run here.** The fixture uses lightweight substitutes and does not verify Roblox APIs, engine physics, real camera visibility, prompt reach/line of sight, mobile/gamepad presentation, streaming, native Luau compilation, network behavior, or completion times. See the solution guide for the full Studio checklist. Do not publish as playtested until those checks are complete.
