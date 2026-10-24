#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The BCS fire mission's method of engagement (the engagement page's NEXT): sheaf, round of the
 * active battery type, rounds per gun and fuze, then on to the solutions. Without a round the
 * mission stays as it was.
 *
 * Arguments:
 * 0: Fire mission <ARRAY>
 * 1: Sheaf: 0 Parallel, 1 Converged, 2 Linear, 3 Open, 4 Special <NUMBER>
 * 2: Quick sheaf, at right angles to the gun-target line (special sheaf) <BOOL>
 * 3: Sheaf direction, mils as typed (special sheaf) <STRING>
 * 4: Sheaf length (m) <NUMBER>
 * 5: Round index in the battery type's ammunition <NUMBER>
 * 6: Rounds per gun <NUMBER>
 * 7: Fuze mode <STRING>
 *
 * Return Value:
 * Engagement set <BOOL>
 *
 * Example:
 * [_mission, 0, false, "0", 0, 0, 3, "pd"] call itc_land_tablet_fnc_bcsSetEngagement
 *
 * Public: No
 */

params ["_mission", "_sheaf", "_quick", "_direction", "_length", "_ammoIndex", "_count", "_fuzeMode"];

private _batteryType = GVAR(bcs_bty_type) # 1;
private _magazine = if (_ammoIndex < 0) then {""} else {
    getArray (configFile >> "itc_land_ballistics" >> "batteryTypes" >> _batteryType >> "ammunition") param [_ammoIndex, ""]
};
if (_magazine == "") exitWith {false};

// the quick sheaf as the classic list's index: 0 On, 1 Off
_mission set [3, [
    _sheaf max 0, [1, 0] select _quick, [_direction, [_batteryType] call EFUNC(common,getMilSystem)] call EFUNC(common,parseMils), _length,
    _ammoIndex, _magazine, (floor _count) max 1, _fuzeMode
]];
_mission set [1, "solutionMission"];
true
