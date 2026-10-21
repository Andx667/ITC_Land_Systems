// The launchers only fire on user input (gunner seat, launch dialog, scripts): AI never picks
// their fire modes (all range probabilities 0), so an AI gunner does not launch at targets it
// sees or receives over datalink. The probabilities live in the fire modes, not the weapon.
#define AI_NEVER_FIRES \
    minRangeProbab = 0; \
    midRangeProbab = 0; \
    maxRangeProbab = 0

class CfgWeapons {
    class MissileLauncher;
    class weapon_rim162Launcher: MissileLauncher {
        class LoalDistance;
    };
    class itc_land_mn230essm_launcher : weapon_rim162Launcher {
        weaponLockDelay = 0.1;
        magazines[] = {"itc_land_mn230essm_x18"};
        fireSpreadAngle = 3;
        enableAttack = 1;
        initSpeed = 0;
        lockAcquire = 1;
        minRange = 800;
        midRange = 3500;
        maxRange = 20000;
        AI_NEVER_FIRES;
        reloadTime=5;
        class LoalDistance: LoalDistance {
            AI_NEVER_FIRES;
        };
        class EventHandlers {
            class itc_land_veh_weapons {
                fired = "call BIS_fnc_effectFiredCruiseMissile;";
            };
        };
    };
    class weapon_VLSBase;
    class weapon_VLS_01: weapon_VLSBase {
        class Cruise;
    };
    class itc_land_mn230slam_launcher: weapon_VLS_01 {
        magazines[] = {"itc_land_mn230slam_x18"};
        AI_NEVER_FIRES;
        class Cruise: Cruise {
            AI_NEVER_FIRES;
        };
        class EventHandlers {
            class itc_land_veh_weapons {
                fired = QUOTE(call FUNC(fired););
            };
        };
    };
};
