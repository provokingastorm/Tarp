//==============================================
//Pod Racer PRPodInfoComponent class for the Pod Racer Online game
//
//This is the PodInfo - Carries all the numbers for the developers to fiddle with in editor
//Data moves over to vehicle from here/editor values
//Author Greg "Ghost142" Mladucky
//Build 8/3/2010
//==============================================

class PRPodInfo extends Info
	placeable;

var() const editconst PRPodInfoComponent Component;

/** Total Number of laps for the race*/
var(RaceInfo) int TotalLaps;

/** Race Starting Time */
var(RaceInfo) float RaceStartTime;

/** Sebubla's pod info */
var(Pod_Sebubla) float S_traction;
var(Pod_Sebubla) float S_turning;
var(Pod_Sebubla) float S_acceleration;
var(Pod_Sebubla) float S_breakPower;
var(Pod_Sebubla) float S_engineCoolDown;
var(Pod_Sebubla) float S_repairCost;
var(Pod_Sebubla) float S_FullAirSpeed;

/** Aldar Beedo's pod info */
var(Pod_Aldar_Beedo) float AB_traction;
var(Pod_Aldar_Beedo) float AB_turning;
var(Pod_Aldar_Beedo) float AB_acceleration;
var(Pod_Aldar_Beedo) float AB_breakPower;
var(Pod_Aldar_Beedo) float AB_engineCoolDown;
var(Pod_Aldar_Beedo) float AB_repairCost;
var(Pod_Aldar_Beedo) float AB_FullAirSpeed;

/** Anakin Skywalker's pod info */
var(Pod_Anakin_Skywalker) float AS_traction;
var(Pod_Anakin_Skywalker) float AS_turning;
var(Pod_Anakin_Skywalker) float AS_acceleration;
var(Pod_Anakin_Skywalker) float AS_breakPower;
var(Pod_Anakin_Skywalker) float AS_engineCoolDown;
var(Pod_Anakin_Skywalker) float AS_repairCost;
var(Pod_Anakin_Skywalker) float AS_FullAirSpeed;

/** Ben Quadinaro's pod info */
var(Pod_Ben_Quadinaro) float BQ_traction;
var(Pod_Ben_Quadinaro) float BQ_turning;
var(Pod_Ben_Quadinaro) float BQ_acceleration;
var(Pod_Ben_Quadinaro) float BQ_breakPower;
var(Pod_Ben_Quadinaro) float BQ_engineCoolDown;
var(Pod_Ben_Quadinaro) float BQ_repairCost;
var(Pod_Ben_Quadinaro) float BQ_FullAirSpeed;

/** Boles Roor's pod info */
var(Pod_Boles_Roor) float BR_traction;
var(Pod_Boles_Roor) float BR_turning;
var(Pod_Boles_Roor) float BR_acceleration;
var(Pod_Boles_Roor) float BR_breakPower;
var(Pod_Boles_Roor) float BR_engineCoolDown;
var(Pod_Boles_Roor) float BR_repairCost;
var(Pod_Boles_Roor) float BR_FullAirSpeed;

/** Boozie Baranta's pod info */
var(Pod_Boozie_Baranta) float BB_traction;
var(Pod_Boozie_Baranta) float BB_turning;
var(Pod_Boozie_Baranta) float BB_acceleration;
var(Pod_Boozie_Baranta) float BB_breakPower;
var(Pod_Boozie_Baranta) float BB_engineCoolDown;
var(Pod_Boozie_Baranta) float BB_repairCost;
var(Pod_Boozie_Baranta) float BB_FullAirSpeed;

/** "Bullseye" Navior's pod info */
var(Pod_Bullseye_Navior) float BN_traction;
var(Pod_Bullseye_Navior) float BN_turning;
var(Pod_Bullseye_Navior) float BN_acceleration;
var(Pod_Bullseye_Navior) float BN_breakPower;
var(Pod_Bullseye_Navior) float BN_engineCoolDown;
var(Pod_Bullseye_Navior) float BN_repairCost;
var(Pod_Bullseye_Navior) float BN_FullAirSpeed;

/** Ark "Bumpy" Roose's pod info */
var(Pod_Ark_Roose) float AR_traction;
var(Pod_Ark_Roose) float AR_turning;
var(Pod_Ark_Roose) float AR_acceleration;
var(Pod_Ark_Roose) float AR_breakPower;
var(Pod_Ark_Roose) float AR_engineCoolDown;
var(Pod_Ark_Roose) float AR_repairCost;
var(Pod_Ark_Roose) float AR_FullAirSpeed;

/** Clegg Holdfast's pod info */
var(Pod_Clegg_Holdfast) float CH_traction;
var(Pod_Clegg_Holdfast) float CH_turning;
var(Pod_Clegg_Holdfast) float CH_acceleration;
var(Pod_Clegg_Holdfast) float CH_breakPower;
var(Pod_Clegg_Holdfast) float CH_engineCoolDown;
var(Pod_Clegg_Holdfast) float CH_repairCost;
var(Pod_Clegg_Holdfast) float CH_FullAirSpeed;

/** Dud Bolt's pod info */
var(Pod_Dud_Bolt) float DB_traction;
var(Pod_Dud_Bolt) float DB_turning;
var(Pod_Dud_Bolt) float DB_acceleration;
var(Pod_Dud_Bolt) float DB_breakPower;
var(Pod_Dud_Bolt) float DB_engineCoolDown;
var(Pod_Dud_Bolt) float DB_repairCost;
var(Pod_Dud_Bolt) float DB_FullAirSpeed;

/** Ebe Endocott's pod info */
var(Pod_Ebe_Endocott) float EE_traction;
var(Pod_Ebe_Endocott) float EE_turning;
var(Pod_Ebe_Endocott) float EE_acceleration;
var(Pod_Ebe_Endocott) float EE_breakPower;
var(Pod_Ebe_Endocott) float EE_engineCoolDown;
var(Pod_Ebe_Endocott) float EE_repairCost;
var(Pod_Ebe_Endocott) float EE_FullAirSpeed;

/** Elan Mak's pod info */
var(Pod_Elan_Mak) float EM_traction;
var(Pod_Elan_Mak) float EM_turning;
var(Pod_Elan_Mak) float EM_acceleration;
var(Pod_Elan_Mak) float EM_breakPower;
var(Pod_Elan_Mak) float EM_engineCoolDown;
var(Pod_Elan_Mak) float EM_repairCost;
var(Pod_Elan_Mak) float EM_FullAirSpeed;

/** Fud Sang's pod info */
var(Pod_Fud_Sang) float FS_traction;
var(Pod_Fud_Sang) float FS_turning;
var(Pod_Fud_Sang) float FS_acceleration;
var(Pod_Fud_Sang) float FS_breakPower;
var(Pod_Fud_Sang) float FS_engineCoolDown;
var(Pod_Fud_Sang) float FS_repairCost;
var(Pod_Fud_Sang) float FS_FullAirSpeed;

/** Gasgano's pod info */
var(Pod_Gasgano) float G_traction;
var(Pod_Gasgano) float G_turning;
var(Pod_Gasgano) float G_acceleration;
var(Pod_Gasgano) float G_breakPower;
var(Pod_Gasgano) float G_engineCoolDown;
var(Pod_Gasgano) float G_repairCost;
var(Pod_Gasgano) float G_FullAirSpeed;

/** Mars Guo's pod info */
var(Pod_Mars_Guo) float MG_traction;
var(Pod_Mars_Guo) float MG_turning;
var(Pod_Mars_Guo) float MG_acceleration;
var(Pod_Mars_Guo) float MG_breakPower;
var(Pod_Mars_Guo) float MG_engineCoolDown;
var(Pod_Mars_Guo) float MG_repairCost;
var(Pod_Mars_Guo) float MG_FullAirSpeed;

/** Mawhonic's pod info */
var(Pod_Mawhonic) float M_traction;
var(Pod_Mawhonic) float M_turning;
var(Pod_Mawhonic) float M_acceleration;
var(Pod_Mawhonic) float M_breakPower;
var(Pod_Mawhonic) float M_engineCoolDown;
var(Pod_Mawhonic) float M_repairCost;
var(Pod_Mawhonic) float M_FullAirSpeed;

/** Neva Kee's pod info */
var(Pod_Neva_Kee) float NK_traction;
var(Pod_Neva_Kee) float NK_turning;
var(Pod_Neva_Kee) float NK_acceleration;
var(Pod_Neva_Kee) float NK_breakPower;
var(Pod_Neva_Kee) float NK_engineCoolDown;
var(Pod_Neva_Kee) float NK_repairCost;
var(Pod_Neva_Kee) float NK_FullAirSpeed;

/** Ody Mandrell's pod info */
var(Pod_Ody_Mandrell) float OM_traction;
var(Pod_Ody_Mandrell) float OM_turning;
var(Pod_Ody_Mandrell) float OM_acceleration;
var(Pod_Ody_Mandrell) float OM_breakPower;
var(Pod_Ody_Mandrell) float OM_engineCoolDown;
var(Pod_Ody_Mandrell) float OM_repairCost;
var(Pod_Ody_Mandrell) float OM_FullAirSpeed;

/** Ratts Tyrell's pod info */
var(Pod_Ratts_Tyrell) float RT_traction;
var(Pod_Ratts_Tyrell) float RT_turning;
var(Pod_Ratts_Tyrell) float RT_acceleration;
var(Pod_Ratts_Tyrell) float RT_breakPower;
var(Pod_Ratts_Tyrell) float RT_engineCoolDown;
var(Pod_Ratts_Tyrell) float RT_repairCost;
var(Pod_Ratts_Tyrell) float RT_FullAirSpeed;

/** Slide Paramita's pod info */
var(Pod_Slide_Paramita) float SP_traction;
var(Pod_Slide_Paramita) float SP_turning;
var(Pod_Slide_Paramita) float SP_acceleration;
var(Pod_Slide_Paramita) float SP_breakPower;
var(Pod_Slide_Paramita) float SP_engineCoolDown;
var(Pod_Slide_Paramita) float SP_repairCost;
var(Pod_Slide_Paramita) float SP_FullAirSpeed;

/** Teemto Pagalie's pod info */
var(Pod_Teemto_Pagalies) float TP_traction;
var(Pod_Teemto_Pagalies) float TP_turning;
var(Pod_Teemto_Pagalies) float TP_acceleration;
var(Pod_Teemto_Pagalies) float TP_breakPower;
var(Pod_Teemto_Pagalies) float TP_engineCoolDown;
var(Pod_Teemto_Pagalies) float TP_repairCost;
var(Pod_Teemto_Pagalies) float TP_FullAirSpeed;

/** Toy Dampner's pod info */
var(Pod_Toy_Dampner) float TD_traction;
var(Pod_Toy_Dampner) float TD_turning;
var(Pod_Toy_Dampner) float TD_acceleration;
var(Pod_Toy_Dampner) float TD_breakPower;
var(Pod_Toy_Dampner) float TD_engineCoolDown;
var(Pod_Toy_Dampner) float TD_repairCost;
var(Pod_Toy_Dampner) float TD_FullAirSpeed;

/** Wan Sandage's pod info */
var(Pod_Wan_Sandage) float WS_traction;
var(Pod_Wan_Sandage) float WS_turning;
var(Pod_Wan_Sandage) float WS_acceleration;
var(Pod_Wan_Sandage) float WS_breakPower;
var(Pod_Wan_Sandage) float WS_engineCoolDown;
var(Pod_Wan_Sandage) float WS_repairCost;
var(Pod_Wan_Sandage) float WS_FullAirSpeed;

/** Base Pod info */
var(Pod_BasePod) float BP_traction;
var(Pod_BasePod) float BP_turning;
var(Pod_BasePod) float BP_acceleration;
var(Pod_BasePod) float BP_breakPower;
var(Pod_BasePod) float BP_engineCoolDown;
var(Pod_BasePod) float BP_repairCost;
var(Pod_BasePod) float BP_FullAirSpeed;

defaultproperties
{
	TickGroup=TG_DuringAsyncWork

	Begin Object Class=PRPodInfoComponent Name=PRPodInfoComponent0
	End Object
	Component=PRPodInfoComponent0
	Components.Add(PRPodInfoComponent0)

	bStatic=FALSE
	bNoDelete=true
	DrawScale=10

	TotalLaps = 3
	RaceStartTime = 3.0
}
