# UAVs & Recon

## UAVs

| UAV | Classnames | Notes |
| --- | --- | --- |
| **AR-2i Darter 2** / **AR-2i Tayran 2** | `ITC_Land_B_UAV_AR2i`, `ITC_Land_O_UAV_AR2i`, `ITC_Land_I_UAV_AR2i` | Packable, camera with ITC readouts |
| **AR-2e Darter** / **AR-2e Trayan** | `ITC_Land_B_UAV_AR2e`, `ITC_Land_O_UAV_AR2e`, `ITC_Land_I_UAV_AR2e` | Packable |
| **MQ-4I Greyhawk** | `ITC_Land_B_UAV_MQ4i` | Camera with ITC readouts, laser designator for the [ROVER tablet](#rover-tablet) |
| **K40i Ababil-3** | `ITC_Land_O_UAV_K40i`, `ITC_Land_I_UAV_K40i` | Camera with ITC readouts |
| **UCAVi Sentinel 2** | `ITC_Land_B_UAV_UCAVi` | Camera with ITC readouts |

The ITC camera readouts show the view direction in degrees and mils, the grid and altitude of the point under the crosshair and of the UAV, its speed, the camera magnification and the time.

### Sending a target to the FDC

In the ITC optics of a UAV, the GLTD or the Strider, **Send target to FDC** (++ctrl+shift+t++, under Configure → Controls → Configure Addons → ITC Land Systems Redux) sends the target over the datalink to every friendly FDC: the lased spot while the laser is on, else the point under the crosshair. It arrives in their BCS [Location Stores](bcs.md#location-stores) as **TGT01**, **TGT02**, … with a ping and a hint, ready as the known point of a fire mission. An FDC receives targets once it has opened the BCS. Corrections during adjust fire still go by voice.

## Packable equipment

Small UAVs and the remote laser designator are carried as an item and set up where you need them, through the ACE interaction menu:

- **Unpack**: self interaction → **Equipment** → **Unpack** → the item. After a 5 second progress bar the UAV or designator stands next to you, ready to connect with a UAV terminal.
- **Repack**: interaction on the deployed UAV or designator (within 3 m) → **Repack UAV** / **Repack GLTD**. You get the item back.

| Packed item | Unpacks to |
| --- | --- |
| `ITC_Land_B_AR2i_Packed`, `ITC_Land_O_AR2i_Packed`, `ITC_Land_I_AR2i_Packed` | AR-2i Darter 2 / Tayran 2 |
| `ITC_Land_B_AR2e_Packed`, `ITC_Land_O_AR2e_Packed`, `ITC_Land_I_AR2e_Packed` | AR-2e Darter / Trayan |
| `ITC_Land_B_UAV_Packed`, `ITC_Land_O_UAV_Packed`, `ITC_Land_I_UAV_Packed` | Vanilla AR-2 Darter / Tayran |
| `ITC_Land_B_AL6_Packed` | AL-6 Pelican [NATO] |
| `ITC_Land_B_RemoteGLTD_Packed`, `ITC_Land_BW_RemoteGLTD_Packed` | **Remote GLTD [NATO]** (`ITC_Land_B_RemoteGLTD`), **Remote GLTD (Green) [NATO]** (`ITC_Land_BW_RemoteGLTD`) |

The vanilla AR-2 Darter/Tayran and every AL-6 Pelican can be repacked as well.

The **UAV Bag** (`ITC_Land_b_uav_backpack`, `ITC_Land_o_uav_backpack`, `ITC_Land_i_uav_backpack`) and **UAV Bag (AL-6)** (`ITC_Land_b_uav06_backpack`, `ITC_Land_o_uav06_backpack`, `ITC_Land_i_uav06_backpack`) are backpacks to carry packed UAVs in.

## ROVER tablet

The **Rover LAD Tablet** (`itc_land_tablet_rover`) shows the video feed of an aircraft that is lasing a target, like a forward air controller's ROVER terminal.

1. Carry the tablet and open it: self interaction → **Equipment** → **Open Rover LAD**.
2. Pick the transmitting aircraft. An aircraft only transmits while its **laser designator is on**; otherwise the tablet shows **NO CONNECTION**.
3. Switch the view between **DTV**, **NVG**, **WHOT** and **BHOT**, and **ZOOM** in.

The tablet shows your own grid and the aircraft's altitude, speed and direction, the grid and altitude of the lased target, and the time.

## Strider RV

| Vehicle | Classname |
| --- | --- |
| **Strider RV** | `itc_land_I_StriderRV` |
| **Strider RV HMG** | `itc_land_I_StriderRV_HMG` |
| **Strider RV GMG** | `itc_land_I_StriderRV_GMG` |

Strider variants with a commander optic that shows the view direction in degrees and mils, and the grid and altitude of the vehicle and of the point under the crosshair.
