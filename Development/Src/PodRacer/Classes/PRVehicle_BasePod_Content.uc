class PRVehicle_BasePod_Content extends PRVehicle_BasePod;

//GPM-Toon Doom code below - Thanks for the help guys!!! - It gets called as the vehicle touches our PRCheckpointVolume and then
//calls our PRPlayerController code for HitCheckpoint
event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	local PRCheckpointVolume PRCheckpoint;
	local PRPlayerController PRPC;

	PRPC = PRPlayerController(Controller);
	PRCheckpoint = PRCheckpointVolume(Other);

	if(PRCheckpoint != None)
	{
		PRPC.HitCheckpoint(PRCheckpoint);
	}
	super.Touch(Other, OtherComp, HitLocation, HitNormal);
}


simulated function SetVehicleEffectParms(name TriggerName, ParticleSystemComponent PSC)
{
	if (TriggerName == 'MantaOnFire')
	{
		PSC.SetFloatParameter('smokeamount', 0.95);
		PSC.SetFloatParameter('fireamount', 0.95);
	}
	else
	{
		Super.SetVehicleEffectParms(TriggerName, PSC);
	}
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local PRPlayerController PRPC;

	PRPC = PRPlayerController(Controller);
	
	if(PRPC != none)
	{
		PRPC.FindLastHit(HitLocation);
	}

	VehicleEvent('MantaNormal');
	return Super.Died(Killer,DamageType,HitLocation);
}

simulated function DrivingStatusChanged()
{
	if ( !bDriving )
	{
		VehicleEvent('CrushStop');
	}
	Super.DrivingStatusChanged();
}

simulated function BlowupVehicle()
{
	if(WorldInfo.Netmode != NM_DEDICATEDSERVER && VehicleEffects[11].EffectRef != none)
	{
		VehicleEffects[11].EffectRef.SetHidden(true); // special case to get rid of the blades
	}
	super.BlowUpVehicle();
}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionHeight=40.0
		CollisionRadius=100.0
		Translation=(X=-40.0,Y=0.0,Z=40.0)
	End Object

	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'SebulbaTestRig01.SK_SebulbaTest01'
		//AnimTreeTemplate=AnimTree'SebulbaTestRig01.SK_SebulbaTest01_AniTree'
		PhysicsAsset=PhysicsAsset'SebulbaTestRig01.SK_SebulbaTest01_Physics'
		//MorphSets[0]=MorphTargetSet'VH_Manta.Mesh.VH_Manta_MorphTargets'
	End Object

	Seats(0)={( //GunClass=class'UTVWeap_MantaGun',
				//GunSocket=(Gun_Socket_01,Gun_Socket_02),
				TurretControls=(gun_rotate_lt,gun_rotate_rt),
				CameraTag=ViewSocket,
				CameraOffset=-512,
				SeatIconPos=(X=0.46,Y=0.45),
				DriverDamageMult=0.0,
				bSeatVisible=false,
				CameraBaseOffset=(X=-20,Y=0,Z=10),
				SeatOffset=(X=-30,Y=0,Z=-5),
				//WeaponEffects=((SocketName=Gun_Socket_01,Offset=(X=-35,Y=-3),Scale3D=(X=3.0,Y=6.0,Z=6.0)),(SocketName=Gun_Socket_02,Offset=(X=-35,Y=-3),Scale3D=(X=3.0,Y=6.0,Z=6.0)))
				)}

	// Initialize sound parameters.
	EngineStartOffsetSecs=0.5
	EngineStopOffsetSecs=1.0

	GroundEffectIndices=(12,13)
	WaterGroundEffect=ParticleSystem'Envy_Level_Effects_2.Vehicle_Water_Effects.PS_Manta_Water_Effects'

	IconCoords=(U=859,UL=36,V=0,VL=27)

	BigExplosionTemplates[0]=(Template=ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_SMALL_Far',MinDistance=350)
	BigExplosionTemplates[1]=(Template=ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_SMALL_Near')
	BigExplosionSocket=VH_Death
	ExplosionSound=SoundCue'A_Vehicle_Manta.SoundCues.A_Vehicle_Manta_Explode'

	TeamMaterials[0]=MaterialInstanceConstant'VH_Manta.Materials.MI_VH_Manta_Red'
	TeamMaterials[1]=MaterialInstanceConstant'VH_Manta.Materials.MI_VH_Manta_Blue'

	SpawnMaterialLists[0]=(Materials=(MaterialInterface'VH_Manta.Materials.MI_VH_Manta_Spawn_Red'))
	SpawnMaterialLists[1]=(Materials=(MaterialInterface'VH_Manta.Materials.MI_VH_Manta_Spawn_Blue'))

	DrivingPhysicalMaterial=PhysicalMaterial'VH_Manta.physmat_mantadriving'
	DefaultPhysicalMaterial=PhysicalMaterial'VH_Manta.physmat_manta'

	BurnOutMaterial[0]=MaterialInterface'VH_Manta.Materials.MITV_VH_Manta_Red_BO'
	BurnOutMaterial[1]=MaterialInterface'VH_Manta.Materials.MITV_VH_Manta_Blue_BO'

	DamageMorphTargets(0)=(InfluenceBone=Damage_LtCanard,MorphNodeName=MorphNodeW_Front,LinkedMorphNodeName=none,Health=70,DamagePropNames=(Damage2))
	DamageMorphTargets(1)=(InfluenceBone=Damage_RtRotor,MorphNodeName=MorphNodeW_Right,LinkedMorphNodeName=none,Health=70,DamagePropNames=(Damage3))
	DamageMorphTargets(2)=(InfluenceBone=Damage_LtRotor,MorphNodeName=MorphNodeW_Left,LinkedMorphNodeName=none,Health=70,DamagePropNames=(Damage3))
	DamageMorphTargets(3)=(InfluenceBone=Hatch,MorphNodeName=MorphNodeW_Rear,LinkedMorphNodeName=none,Health=70,DamagePropNames=(Damage1))

	DamageParamScaleLevels(0)=(DamageParamName=Damage1,Scale=1.0)
	DamageParamScaleLevels(1)=(DamageParamName=Damage2,Scale=1.5)
	DamageParamScaleLevels(2)=(DamageParamName=Damage3,Scale=1.5)

	HudCoords=(U=228,V=143,UL=-119,VL=106)

	bHasEnemyVehicleSound=true
	EnemyVehicleSound(0)=SoundNodeWave'A_Character_Reaper.BotStatus.A_BotStatus_Reaper_EnemyManta'
}