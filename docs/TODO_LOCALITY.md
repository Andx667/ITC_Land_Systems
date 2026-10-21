# Multiplayer / Locality TODO

Findings from a read-only audit of locality and multiplayer behavior. Items were found by
reading the code and have **not** all been verified in game; anything touching ownership
needs a two-player test (e.g. gunner and driver on different clients).

Related: [TODO_MODERNIZATION.md](TODO_MODERNIZATION.md).

## High
- [x] **1. Cobra: `time` mixed with `cba_missionTime`.** `processImpact` stores impact times from
      `cba_missionTime`; `scan` compares against `time`; `sirenTrigger` mixes both;
      `processOrigin`/`processEngagement` use `time`. `time` differs per client. Use
      `cba_missionTime` everywhere.
- [x] **2. (needs MP test) Cobra: shared global state, per-machine simulation.** Each COBRA's `vehicleInit` resets the
      shared `itc_land_cobra_*` missionNamespace vars (a second COBRA wipes the first); each
      scan loop consumes the shared shell list so the second never sees shells; `FiredBIS`/init
      run on every machine. Done: server-authoritative; one server scan over all COBRAs, results published via publicVariable, sirens played on every machine via a CBA global event.
- [x] **3. SAM-35 / `fuzeProxFOV` detonation is server-only.** The missile is deleted, then the
      detonation helper is only spawned `if (isServer)`; client-fired missiles just vanish. Drop the
      gate (`createVehicle` is global).
- [x] **4. (needs two-player test) SPH loader magazine changes need the vehicle's owner.** `removeMagazine`/`addMagazine` on
      `_vehicle` in `loadGun`, `firedEH`, `runSequence` run on the gunner's machine; silently do
      nothing when the driver/another client owns the vehicle. Route via `CBA_fnc_targetEvent`.

## Medium
- [x] **5. (needs two-player test) APS state mutated from the shooter's machine.** `attemptIntercept` decrements the target
      vehicle's ammo/last-fired and re-broadcasts the array; concurrent shooters race. Send an event
      to the vehicle's owner instead. Also guard `vehicleInit` (runs and broadcasts on every machine).
- [x] **6. Debug output left in.** 6x `systemChat` in APS, `player sideChat` in datalink
      `onClientConnect` removed. The 4 progress `hint`s in the `ballistics/formattedBTab.sqf` dev tool were left on purpose.
- [x] **7. Pack/unpack.** (Fixed; unpack was never affected, its callback always runs on the caller's machine.) `fnc_Pack` calls `deleteVehicle _item` then `getPos _item` (holder spawns
      at [0,0,0]); pack/unpack only act `if local`, so non-local objects finish the progress bar
      and do nothing.
- [x] **8. (needs test) Spike assumes the shooter is the local player.** `fired` uses `player`, camera and
      `ppEffect`; AI-fired Spike runs this on a machine with no player. Guard with `hasInterface` /
      `ace_player`.
- [x] **9. Datalink hygiene.** Server node registry is never cleaned on unit deletion or player
      disconnect; `registerEvent` stores handlers in a non-public var on the calling machine while RX
      goes to the object's current owner. Done: registry stores [object, connecting machine ID], RX goes there via CBA_fnc_ownerEvent; entries removed on EntityDeleted/PlayerDisconnected. Note: no live caller uses the datalink yet (all callers are commented out). Respawn still leaves the registration on the old body.

## Low
- [ ] **10. CIWS decoy per bullet.** Each tracked round creates a networked vehicle + crew.
- [ ] **11. CIWS Zeus hook runs once.** `allCurators` handlers added at postInit only, broadcast from
      every machine; later curators missed.
- [ ] **12. VLS launch data in two globals** (`itc_land_target_test`, `itc_land_target_IAtest`) while
      the same data is already per-vehicle (`itc_land_vls_targetPos`/`targetAngl`).
- [x] **13. APS elevation test** in `canIntercept` uses `&&` where `||` is needed (logic bug).

## Fix order
1. Items 1, 3, 6, 13, 7 (mechanical, low risk).
2. Items 4, 5, 8 (move work to owner machine; needs two-player test).
3. Item 2 (cobra redesign) and 9 (datalink cleanup).
4. Items 10-12 (optional polish).
