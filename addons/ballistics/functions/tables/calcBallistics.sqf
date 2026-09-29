/*
 * Author: ToadBall, Yax, VKing
 * Ballistic table generator. Numerically simulates a projectile's trajectory across a range of gun elevation angles for a given magazine,
 * taking height-offset "slices" of each trajectory. Creates pre-rendered ballistic data for use with ARTY.
 *
 * Arguments:
 * 0: Magazine classname (CfgMagazines) <STRING>
 * 1: Minimum gun elevation angle, degrees <NUMBER>
 * 2: Maximum gun elevation angle, degrees <NUMBER>
 * 3: Gun elevation angle step, degrees <NUMBER>
 * 4: Minimum height offset to slice at <NUMBER>
 * 5: Maximum height offset to slice at <NUMBER>
 * 6: Height step between slices <NUMBER>
 * 7: Muzzle velocity, m/s <NUMBER> (default: magazine's initSpeed)
 * 8: Air friction coefficient <NUMBER> (default: ammo's airFriction)
 *
 * Return Value:
 * [ballisticTable, minRange, maxRange], where ballisticTable is an array of [elevation, maxHeight, slices] rows <ARRAY>
 *
 * Example:
 * ["itc_Sh_82mm_HE", 45, 85, 1, -2000, 2000, 100] call itc_land_ballistics_fnc_calcBallistics
 *
 * Public: No
 */

#define MILPREC 17.7777777777778
#define DEG2MIL(deg)    (((deg*MILPREC)) min 6400)
#define MIL2DEG(mil)    mil/MILPREC

private ["_offsetTable", "_offsetIdx", "_useElevation", "_addTab", "_offsetEntry"];

private _magazine = _this select 0;
private _emin = _this select 1;
private _emax = _this select 2;
private _estep = _this select 3;
private _hmin = _this select 4;
private _hmax = _this select 5;
private _hstep = _this select 6;
private _muzzle_velocity = _this select 7;
private _airFriction = _this select 8;

private _ammo = getText(configFile >> "CfgMagazines" >> _magazine >> "ammo");
if((count _this) < 8) then {
    _muzzle_velocity = getNumber(configFile >> "CfgMagazines" >> _magazine >> "initSpeed");
};
itc_land_ballistics_debugMV = _muzzle_velocity;
if((count _this) < 9) then {
    _airFriction = getNumber(configFile >> "CfgAmmo" >> _ammo >> "airFriction");
};
itc_land_ballistics_debugAF = _airFriction;

// Grab offset table if it exists. Offsets are used for calculating rocket artillery trajectories.
// The number of entries in the offset table must match the number of entries in the generated ballistic table,
// based on the elevation step value.


private _grav = -9.80665;                      // Gravity constant.
private _fps = 60;                             // Frames per second for calculation.
   
// Stops
private _minrange = 99999999;
private _maxrange = 0;

// Initialize resultant set of data
private _btab = [];
private _elevation = 0;

for [{_elevation=_emin},{_elevation<=_emax},{_elevation=_elevation+_estep}] do {
        // Initial params
        private _x = 0;
        private _y = 0.1;
        private _ymax = 0;
        private _xmax = 0;
        private _vel = _muzzle_velocity;
        private _fc = 0;
        

        _useElevation = _elevation;
        
        // Set t0 parameters
        private _vx = _vel * cos(_useElevation);
        private _vy = _vel * sin(_useElevation);
        private _frame = 1 / _fps;
        
        private _slices = [];
        private _agate = _hmax;
        
        while {_y >= _hmin} do
        {
            // Calculate next velocity frame
            _vx = _vx + (_vx * _vel * _airFriction * _frame);
            _vy = _vy + (_vy * _vel * _airFriction * _frame);
            _vy = _vy + (_grav * _frame);
            _vel = sqrt(_vx*_vx + _vy*_vy);
            private _elev = asin (_vy / _vel);
            // Increment positions
            _y = _y + (_vy * _frame);
            _x = _x + (_vx * _frame);

            // Record max altitude and range
            if (_y > _ymax) then
            {
                _ymax = _y;
            };
            if (_x > _xmax) then
            {
                _xmax = _x;
            };
            
            // Take slices
            
            if ((_y < _agate) && (_vy < 0) && (_agate >= _hmin)) then
            {
                while {_agate > _y} do {_agate = _agate - _hstep;};
                _slices pushBack [_x,_y,_fc * _frame,_vel,_elev];
            };
            
            // Increment frame count.
            _fc = _fc + 1;
        };
        _xmax = _x;
        
        if (_xmax < _minrange) then
        {
                _minrange = _xmax;
        };
        if (_xmax > _maxrange) then
        {
                _maxrange = _xmax;
        };
        
        // Order slices lowest to highest
        private _rSlices = [];
        for [{private _a = count(_slices)-1;},{_a >= 0},{_a = _a - 1}] do
        {
            _rSlices pushBack (_slices select _a);
        };
 
        // Put calculated rocket decay points into table if offsets are used.
        _addTab = [_elevation, _ymax, _rSlices];
        _btab pushBack _addTab;
};
[_btab, _minrange, _maxrange]
