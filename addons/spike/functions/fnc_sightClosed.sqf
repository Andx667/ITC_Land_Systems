#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Disables the color-correction and film-grain post-process effects and clears
 * the effect-active flag when the Spike LR seeker/camera view is closed.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call itc_land_spike_fnc_sightClosed
 *
 * Public: No
 */

"colorCorrections" ppEffectEnable false;
"filmGrain" ppEffectEnable false;
itc_land_spike_ppEffect = false;
