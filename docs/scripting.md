# Mission Makers & Modders

What to keep in mind when you place ITC systems in a mission, and the config to give your own vehicles and ammunition ITC features.

!!! note "Beta"
    The config described here is what the mod reads today. It is not a frozen API yet and may change before 1.0.

## Placing systems

- **Crew**: the CIWS, SAM sites, VLS and COBRA radars are crewed by UAV AI. Place them with their crew (the default in the editor and Zeus), otherwise they do nothing.
- **Radar**: the Praetorian 2 switches its radar on as soon as it is created, whether by the editor, Zeus or a script. Other radar vehicles start with the radar off until their AI turns it on.
- **VLS**: AI gunners of the ITC launchers never launch on their own. Fire them from the gunner seat, the [VLS interface](systems/air-defence.md#vls-interface) or by script, for example `_vls fireAtTarget [objNull, (_vls weaponsTurret [0]) select 0]` (without a target set in the interface the missile flies unguided).
- **COBRA**: a radar only detects while it stands still. Turn it towards the expected threat; it covers 23° to each side.
- **Settings**: the server-wide [settings](usage.md#settings) can be set per mission in `cba_settings.sqf`, for example `force itc_land_cobra_range = 15000;`.

## COBRA sirens

Place **COBRA Siren** or **COBRA Siren 2** objects, they work without setup. Any other object can be turned into a siren on the server, in its init field or a server script:

```sqf
if (isServer) then {
    // object, sound class (CfgSounds), audible distance in m, seconds between repeats
    [this, "alarm", 250, 1.75] call itc_land_cobra_fnc_sirenInit;
};
```

A siren sounds when a predicted impact is within 500 m of it.

## CIWS interceptable ammunition

The CIWS engage every round whose ammunition is of one of these classes or derived from them:

```cpp
class itc_land_ciws {
    interceptable[] = {
        "Sh_155mm_AMOS",            // artillery shells
        "Sh_82mm_AMOS_guided",      // guided mortar rounds
        "Missile_AGM_02_F",
        "LaserBombCore",
        "BombCore",
        "itc_land_230mm_he",        // ITC 230 mm rockets
        "Missile_AGM_01_F",
        "ammo_Missile_AntiRadiationBase",
        "ammo_Missile_CruiseBase",
        "ammo_Bomb_SDB"
    };
};
```

A mod can add its own ammunition base classes to this list with a config patch. Ammunition can set which decoy the CIWS track with `itc_land_ciws_target`: `"itc_land_shell"` (the default, a radar target) or `"itc_land_missile"` (a radar and IR target, used for missiles).

In a mission, the list is the variable `itc_land_ciws_interceptable` on every machine. Add to it once the mission runs, for example in `init.sqf`:

```sqf
[{ itc_land_ciws_interceptable pushBackUnique "My_Rocket_Ammo_Base"; }, [], 1] call CBA_fnc_waitAndExecute;
```

## Active protection

A vehicle gets an [APS](systems/aps.md) from its config: an `itc_land_aps` class with one subclass per launcher module, and the init event handler that reads it.

```cpp
class CfgVehicles {
    class MyTank_base;
    class MyTank: MyTank_base {
        class EventHandlers: EventHandlers {
            class itc_land_aps {
                init = "call itc_land_aps_fnc_vehicleInit";
            };
        };
        class itc_land_aps {
            class TROPHY_L {
                displayName = "Trophy Left";
                position[] = {-1, 0, 1.5};  // model coordinates of the launcher
                turret[] = {0};             // turns with this turret; leave out to fix it to the hull
                direction = -90;            // facing relative to the turret/hull, degrees
                traverse = 93;              // covers this many degrees to each side of its facing
                elevate = 40;               // and this many degrees up and down
                range = 15;                 // m, engages when the projectile is this close
                munitions = 10;             // shots
                pk = 0.8;                   // kill chance per shot
                reloadTime = 0.1;           // s between shots
                trigger = 1;                // 1 = detonate the round, 0 = replace it with a penetrator
            };
        };
    };
};
```

The vehicle class must declare `class EventHandlers: EventHandlers` so it keeps the event handlers of its parent and of CBA; without the init handler the vehicle has no APS. A config class alone (without the event handler), presets and a script API are planned.

## Artillery vehicles

ITC's fire control, ammunition handler and mounted tablet read an `itc_land` class in the vehicle config:

```cpp
class itc_land {
    tabletInterfaces[] = {"spg"};
    mountedTablet = "itc_land_tablet_spg";   // or "itc_land_tablet_mlrs"
    loaderType = 1;                          // ammunition handler: 0 manual, 1 semi-automatic, 2 automatic
};
```

Add the **Open Mounted Tablet** and **Open Ammo Handling Interface** ACE self actions to the vehicle (see the ITC vehicles, for example `itc_land_veh_sholef`), and set the gunner's `turretInfoType` to an ITC sight such as `ITC_Land_RscIGS_SPH`.

### Ammunition

Every round-and-charge combination is a one-round magazine. The magazines carry the data for the fire control and the ammunition handler:

| Key | Meaning |
| --- | --- |
| `itc_land_btabListFile` | Path to the ballistic table list of the round (one table per charge, low and high angle). Generate the tables with `addons\ballistics\tables\calcBallistics.sqf` and no air friction: the fire control reads the charge's muzzle velocity and elevation range from them and computes the exact trajectory. A table starting at 45° or more gives high-angle solutions |
| `itc_land_charge_format` | Format of the charge magazines, for example `"itc_land_g155hex_chg%1"` |
| `itc_land_maxChargeIndex` | Highest charge |
| `itc_land_CountInAH` | `1` for the base magazine counted by the ammunition handler, `0` for the charge magazines |
| `itc_land_fuze` | Fuze class from `ITC_Land_CfgFuzes` (`mof35_mod0` all modes, `mof35_mod1` time, `mof35_mod2` point detonate, proximity and delay, `mof35_mod3` time for cargo rounds) |
| `itc_land_guidance[]` | Guidance: `{"laser_coded", function}`, `{"gps_inertial", function}` or `{"laser_coded_2"}` |
| `itc_land_submunition` | Object or ammunition released by the fuze |
| `itc_land_heightModifier`, `itc_land_timeModifier` | Corrections to the computed impact height and time of flight |

### Battery types

The [BCS](systems/bcs.md) offers the battery types under `itc_land_ballistics >> batteryTypes`:

```cpp
class itc_land_ballistics {
    class batteryTypes {
        class G155 {
            displayName = "G155 155mm Howitzer";
            type = "cannon";                  // or "rocket"
            ammunition[] = {"itc_land_g155hex", "itc_land_g155smo"};
            weaponClass = "itc_land_155mm_howitzer";
        };
    };
};
```

## Packable equipment

A vehicle can be packed into an item and unpacked again:

- The vehicle sets `itc_land_PacksTo = "My_Packed_Item";` and gets an ACE action that calls `[_target, _player] call itc_land_packable_fnc_pack`.
- The item inherits from `itc_land_packableItem`, sets `itc_land_unPacksTo = "My_Vehicle";` and gets an ACE self action under `ACE_Equipment >> ITC_Land_Unpack` that calls `["My_Packed_Item", _player] call itc_land_packable_fnc_unpack`.

## Debugging

| Variable | Effect |
| --- | --- |
| `itc_land_aps_debug` | Logs every tracked rocket and missile, every APS shot (kill or miss) and why a module did not fire to the RPT (`[ITC APS]`) |
| `itc_land_ciws_debug` | Logs the shell decoys, the CIWS sensor state every 3 s and whether each shell was intercepted or landed to the RPT (`[ITC CIWS]`) |

Set them with `missionNamespace setVariable ["itc_land_aps_debug", true, true];`.
