# THE WORLD IS LYING — Solution guide

**Full spoilers.** Keep this document outside the player-facing experience. The generator creates all required clues inside the building; this guide is not required to play.

## Design contract

Difficulty comes from comparing evidence, considering alternatives, changing reference frames, and applying earlier rules. All ten puzzles work solo. No random answers, death loops, forced microphone input, timed floor races, or precision jumps are required. A failed deduction retains documents and receipts. Drafts remain until the player explicitly resets them; accepted corridor legs remain after wrong turns. The statue moves deliberately one latched bay at a time.

The intended first-time durations are **2–4 minutes for Rooms 01–05** and **4–7 minutes for Rooms 06–10**. These are design targets, not measured results or enforced timers. Early puzzles may prove shorter for experienced players; test with first-time players before claiming these targets are achieved. Do not add waiting periods merely to inflate completion time.

Every room has three deliberately requested hints, accessible from its hint terminal or the HUD. Requests advance one tier, then repeat tier three. There are no unsolicited timed hints, penalties for requesting help, or automatic puzzle solutions. Inspecting a document opens a readable panel and records it in the Notebook (N / on-screen button). Solving a room automatically archives its entire case file and receipt, preventing missed-document softlocks in Room 10. Hints are separate from evidence and never auto-open.

The central door unlocks after each room except Room 10, where the file and final choice replace the next-room transition. Progress, drafts, evidence, and hint tiers are individual per player. Character respawn retains session progress; leaving the server does not. Completed endings are final for that session.

## 01 — The Welcome

**Answer:** Choose **ASH**, then use the central exit. Receipt: **ASH**.

The reception ledger says exactly one plate is true:

| Assumed release | ASH: release is BRASS | BRASS: release is not BRASS | CHALK: release is not ASH | True plates |
| --- | --- | --- | --- | --- |
| ASH | False | True | False | 1 |
| BRASS | True | False | True | 2 |
| CHALK | False | True | True | 2 |

Only ASH satisfies the rule. The doors describe the release, not which plate is honest. The final hint points out that the first two plates are complements, forcing the third to be false. A wrong door explains the contradiction without teleporting or clearing evidence.

## 02 — The Floor Lies

**Answer:** Set row dials to **C, A, C, B**, then **COMMIT**. Receipt: **IVORY**.

Each ceiling record contains one symbol twice; that repeated symbol is the only load-bearing symbol in the corresponding floor row. Floor colors are irrelevant.

| Row | Ceiling record | Repeated symbol | Floor left-to-right | Selected column |
| --- | --- | --- | --- | --- |
| 1 | SUN MOON EYE MOON | MOON | SUN, EYE, MOON | C |
| 2 | EYE SUN MOON SUN | SUN | SUN, MOON, EYE | A |
| 3 | EYE MOON EYE SUN | EYE | MOON, SUN, EYE | C |
| 4 | MOON SUN EYE MOON | MOON | EYE, MOON, SUN | B |

Rows are explicitly numbered entrance-to-exit; columns are entrance-facing left-to-right. Hanging records have read prompts. The floor is physically supported throughout; the lock checks a plan, not the player's ability to follow narrow collision edges. Incorrect submissions identify inconsistent row numbers and retain the draft.

## 03 — Do Not Look Away

**Answer:** Place the statue at **bay II / EYE**, look at it, and use **ACCEPT BAY**. Receipt: **STILL**.

Bays run RING, EYE, TRIANGLE, SQUARE. The correction excludes endpoints and TRIANGLE, leaving EYE. The statue starts at IV. Use **AVERT / ADVANCE** while looking away to move IV → I, then I → II. Each deliberate pull moves one bay and latches indefinitely. Wait for the short movement animation to settle, turn back, and accept.

Controls remain near the entrance. AVERT faces the rear wall; ACCEPT is available while facing the statue. The gaze check uses a broad view cone. The statue does not chase or hurt the player. If a bay or observation condition is wrong, nothing resets. Studio must confirm prompt visibility from these viewing directions, especially on touch and gamepad.

## 04 — You Have Been Here

**Answer:** Observer **RIGHT, RIGHT, LEFT**. Receipt: **WEST**.

| Station | Observer faces | Next station lies | Correct relative turn |
| --- | --- | --- | --- |
| FURNACE | North | East | Right |
| CISTERN | South | West | Right |
| ARCHIVE | East | North | Left |

The controls explicitly refer to the observer drawn on the survey, not the avatar's heading. The route strip updates the current station and heading. Each accepted leg survives wrong choices; wrong choices return the player to the entrance without erasing accepted legs. The architecture repeats to create the loop, while the reference frame changes.

## 05 — Please Be Silent

**Answer:** **FAN OFF, SPEAKER OFF, MICROPHONE ON**; stand still in the broad pale area for **five seconds**. Receipt: **HUSH**.

The instrument measures mechanical vibration. Fan and speaker are active sources; the microphone is passive but necessary to certify the record. Turning all devices off is insufficient. Lamps are isolated. There is no real voice recording or microphone permission.

Movement interrupts only the current five-second sample. Device settings and evidence remain. The HUD reports whether a valid recording configuration is available and counts certified stillness. There is no deadline for starting the sample.

## 06 — The Other Side

**Answer:** Enter **SUN, EYE, MOON, KEY**, then **COMMIT**. Receipt: **EYE**.

The reflected strip is EYE, SUN, KEY, MOON. Reverse positions to obtain MOON, KEY, SUN, EYE. Then exchange EYE ↔ KEY and SUN ↔ MOON. This yields SUN, EYE, MOON, KEY. Applying both operations once is explicitly defined; reversing without substitution is insufficient.

The full draft appears in the HUD; COMMIT checks it as a whole. RESET edits only the draft. The mirror is reflective geometry with a symbolic inscription, not a real-time avatar reflection.

## 07 — Nothing Is Missing

**Answer:** **B, C, A, A**, then **COMMIT**. Receipt: **VOID**.

Select SUN and MOON to hold each archived exposure indefinitely. A stable tile belongs to both sets in its row:

| Row | SUN exposure | MOON exposure | Intersection |
| --- | --- | --- | --- |
| 1 | A, B | B, C | B |
| 2 | B, C | A, C | C |
| 3 | A, C | A, B | A |
| 4 | A, B | A, C | A |

Floor images disappear personally when the exposure changes, but the collision support remains. Memory is useful, and the views can be revisited without limit. There is no timing window. The missing-entry document introduces the later rule: an absent entry is a literal **BLANK** position, not an omitted position.

## 08 — For Your Safety

**Answer:** **A ON, B ON, C OFF, D OFF**, then **COMMIT**. Receipt: **TRACE**.

Exactly two relays must be on. A and C differ; B equals A; C on forces D off.

- Suppose A is off. Then B is off and C is on; D must be off. Only one relay is powered, violating the budget.
- Thus A is on. B is on, C is off; the two-relay budget forces D off.

There is exactly one valid configuration. COMMIT reports current power count and whether the wiring is consistent, retaining settings. Camera eyes close for the solving player. The cameras watch continuously before authorization; red does not impose a sprint or damage window.

Preserve the retrieval audit for Room 10: **INTERROGATION → REFLECTION → FLOOR INSPECTION → ARCHIVE → CORRIDOR**, followed by one missing entry. Receipts belong to their issuing rooms, not to what the printed receipt word happens to resemble.

## 09 — The Witness

**Answer:** Classify **A = ROLE ERROR, B = DATE ERROR, C = VALID**, then **COMMIT**. Receipt: **SELF**.

- ADA is employed in 1971, but an engineer can sign only POWER logs, not ENTRY logs.
- MARA may sign MEMORY logs, but her employment begins in 1973, after the claimed 1971 record.
- IVO is a porter employed in 1971, so an ENTRY log in 1971 is valid.

The date intervals are inclusive. Each invalid record violates exactly one rule, so classifications are unambiguous. Completion opens the intake conceptually and reveals that the building requested the observer before it had rooms. The full personal origin file remains sealed until the final puzzle.

## 10 — The World Is Lying

**Answer:** Enter **ASH → EYE → IVORY → SELF → WEST → BLANK**, then **COMMIT**. Stand still for **five seconds** in the pale entrance area, **READ FILE**, then choose **REMEMBER** or **FORGET**.

The witness index maps surveillance terms to earlier rooms; the audit supplies order:

| Audit witness | Earlier evidence | Receipt |
| --- | --- | --- |
| INTERROGATION | Reception plate logic, Room 01 | ASH |
| REFLECTION | Glass impressions, Room 06 | EYE |
| FLOOR INSPECTION | Ceiling load records, Room 02 | IVORY |
| ARCHIVE | Staff and seal records, Room 09 | SELF |
| CORRIDOR | Observer survey loop, Room 04 | WEST |
| Missing entry | Room 07's conservation standard | BLANK |

The player must distinguish receipts from previous input solutions and distinguish the two floor rooms. The notebook contains every necessary source even if a clue was never inspected before leaving its room.

After accepting the six entries, the building asks for the silent-room protocol from Room 05. The recorder is already active and sources isolated; the player applies the learned stillness condition in a large safe area. An accepted audit is never erased by movement, death, or another COMMIT. Only an interrupted sample restarts.

The opened file identifies the player by display name and reveals that the building is an organ learning to imitate a mind. Every puzzle measured decisions rather than merely guarding a door. Its 1971 intake requested the player's decisions before their arrival. Both endings are available only after audit, certification, and reading:

- **REMEMBER:** the player keeps the receipts; outside windows turn toward them. The building has learned to recognize itself in other buildings.
- **FORGET:** something wearing the player's decisions walks outside while the receptionist welcomes the player again.

Neither choice is treated as a wrong answer. Both are unsettling consequences of a completed, logically valid puzzle.

## Validation and remaining playtest work

Run the local fixture from the repository root:

```bash
texlua tests/review_generator.lua
texlua tests/review_generator.lua forget
```

A standard Lua 5.3+ interpreter can also run it. The fixture constructs the object tree with lightweight substitutes, parses both embedded scripts unchanged, proves the selected logical constraints, and exercises all ten server flows, both ending branches, deliberately requested hints, wrong answers, retained corridor work, respawn, and player isolation. It is not Roblox and cannot establish engine compatibility or actual playability.

In Studio, generate in Edit mode, then test solo and with at least two clients. Verify all clue panels and prompts are reachable, both statue observation directions work, letters remain readable on mobile, the notebook scrolls, camera/door feedback is personal, and floor exposure changes never remove support. Reset characters during partial puzzles, during final certification, and after an ending. Run through both endings in separate sessions. Verify repeated generation leaves one set of TWIL objects.

Measure first-time room times, incorrect submissions, hint usage, and reasons for confusion. Adjust clue presentation before making controls more demanding. No completion-time measurements have been collected here.
