/*
 * Author: ToadBall, Yax
 * Builds the list of UFC guidance option definitions (id, default value, display label,
 * control type, and a validation-check code block) available for VLS guidance setup.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Guidance option definitions <Array>
 *
 * Example:
 * [] call itc_land_vls_fnc_getGuidanceOptions
 *
 * Public: No
 */

private _optionsList = [];

//_optionsList pushBack ["terFollow","OFF","TER FOLLOW","cycle",["ON","OFF"]];
_optionsList pushBack ["impAng","60","IMP ANG","UFC",{(_this > 40 && _this < 70)}];

_optionsList
