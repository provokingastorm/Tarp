class PRVehicle_BasePod extends UTVehicle;

/** Suspension height when Pod is being driven around normally */
var(Movement) protected float FullWheelSuspensionTravel;

/** controls how fast to interpolate between various suspension heights */
var(Movement) protected float SuspensionTravelAdjustSpeed;

/** Suspension stiffness when Pod is being driven around normally */
var(Movement) protected float FullWheelSuspensionStiffness;

/** Adjustment for bone offset when changing suspension */
var  protected float BoneOffsetZAdjust;

/** max speed */
var(Movement) float FullAirSpeed;

//////////////////////////////////////////////////////////
//  INHERITED UNREAL FUNCTIONS
//////////////////////////////////////////////////////////

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	// pbennett - Removing sounds for now because ungodly loud
	//EngineSound.SoundCue = SoundCue'A_Vehicle_Manta_UT3g.SoundCues.A_Vehicle_Manta_EngineLoop';
}

simulated function bool CanBeBaseForPawn(Pawn APawn)
{
	return bCanBeBaseForPawns && !bDriving;
}

/** DriverEnter()
Make Pawn P the new driver of this vehicle
*/
function bool DriverEnter(Pawn P)
{
	local Pawn BasedPawn;

	if ( super.DriverEnter(P) )
	{
		ForEach BasedActors(class'Pawn', BasedPawn)
		{
			if(BasedPawn != Driver)
			{
				BasedPawn.JumpOffPawn();
			}
		}
		return true;
	}
	return false;
}

//GPM-Keep to see if I need to know how to over ride buttons, etc.
/*
simulated function bool OverrideBeginFire(byte FireModeNum)
{
	if (FireModeNum == 1)
	{
		bPressingAltFire = true;
		return true;
	}

	return false;
}

simulated function bool OverrideEndFire(byte FireModeNum)
{
	if (FireModeNum == 1)
	{
		bPressingAltFire = false;
		return true;
	}

	return false;
}
*/

simulated event RigidBodyCollision( PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent,
				const out CollisionImpactData RigidCollisionData, int ContactIndex )
{
	// only process rigid body collision if not hitting ground
	if ( Abs(RigidCollisionData.ContactInfos[0].ContactNormal.Z) < WalkableFloorZ )
	{
		super.RigidBodyCollision(HitComponent, OtherComponent, RigidCollisionData, ContactIndex);
	}
}

simulated function bool ShouldClamp()
{
	return false;
}

function bool FindAutoExit(Pawn ExitingDriver)
{
	`log("Don't Let The Player Exit The Pod");
	return false;
}

//////////////////////////////////////////////////////////
//  TARP FUNCTIONS
//////////////////////////////////////////////////////////

defaultproperties
{
	bNoZSmoothing=false
	CollisionDamageMult=0.0008

	Health=200
	MeleeRange=-100.0
	ExitRadius=160.0
	bTakeWaterDamageWhileDriving=false

	COMOffset=(x=0.0,y=0.0,z=0.0)
	UprightLiftStrength=80.0 //GPM - was 30.0
	UprightTorqueStrength=80.0 //GPM- was 30.0
	bCanFlip=false
	FullWheelSuspensionTravel=145
	FullWheelSuspensionStiffness=20.0
	SuspensionTravelAdjustSpeed=100
	BoneOffsetZAdjust=45.0
	CustomGravityScaling=2.0 //GPM - Was 0.8

	AccelRate = 2.0 //GPM-Does NOTHING
	MaxSpeed=25000.000000  //GPM - Added this code from base vehicle code, wasnt allowing faster movement - look back in previous code to find defaults
	AirSpeed=8000.0 //was - 1800.0
	GroundSpeed=8000.0 //was - 1500.0
	FullAirSpeed=8000.0 //was - 1800.0
	bCanCarryFlag=false
	bFollowLookDir=True
	bTurnInPlace=True
	bScriptedRise=True
	bCanStrafe=False
	SpawnRadius=256.0
	MomentumMult=0.25//GPM- was 3.2

	bStayUpright=true
	StayUprightRollResistAngle=5.0 //GPM-Was 5.0
	StayUprightPitchResistAngle=5.0 //GPM-Was 5.0
	StayUprightStiffness=450
	StayUprightDamping=2

	Begin Object Class=UDKVehicleSimHover Name=SimObject
		WheelSuspensionStiffness=20.0
		WheelSuspensionDamping=1.0
		WheelSuspensionBias=0.0
		MaxThrustForce=200 //GPM-was 325
		MaxReverseForce=250.0
		LongDamping=0.3
		DirectionChangeForce=375.0
		LatDamping=0.3
		MaxRiseForce=200.0 //GPM-was 0.0
		UpDamping=0.0
		TurnTorqueFactor=2500.0
		TurnTorqueMax=1000.0
		TurnDamping=0.25
		MaxYawRate=100000.0
		PitchTorqueFactor=200.0
		PitchTorqueMax=18.0
		PitchDamping=0.1
		RollTorqueTurnFactor=1000.0
		RollTorqueMax=500.0
		RollDamping=0.2
		MaxRandForce=20.0
		RandForceInterval=0.4
		bAllowZThrust=true
	End Object
	SimObj=SimObject
	Components.Add(SimObject)

	Begin Object Class=UTHoverWheel Name=RThruster
		BoneName="engineRight"
		BoneOffset=(X=0.0,Y=0.0,Z=-32.0)
		WheelRadius=256
		SuspensionTravel=24
		bPoweredWheel=true
		LongSlipFactor=0.0
		LatSlipFactor=0.0
		HandbrakeLongSlipFactor=0.0
		HandbrakeLatSlipFactor=0.0
		SteerFactor=1.0
		bHoverWheel=true
	End Object
	Wheels(0)=RThruster

	Begin Object Class=UTHoverWheel Name=LThruster
		BoneName="engineLeft"
		BoneOffset=(X=0.0,Y=0.0,Z=-32.0)
		WheelRadius=256
		SuspensionTravel=24
		bPoweredWheel=true
		LongSlipFactor=0.0
		LatSlipFactor=0.0
		HandbrakeLongSlipFactor=0.0
		HandbrakeLatSlipFactor=0.0
		SteerFactor=1.0
		bHoverWheel=true
	End Object
	Wheels(1)=LThruster

	
	Begin Object Class=UTHoverWheel Name=FThruster
		BoneName="carrige"
		BoneOffset=(X=0.0,Y=0.0,Z=-128.0)
		WheelRadius=256
		SuspensionTravel=24
		bPoweredWheel=false
		LongSlipFactor=0.0
		LatSlipFactor=0.0
		HandbrakeLongSlipFactor=0.0
		HandbrakeLatSlipFactor=0.0
		SteerFactor=1.0
		bHoverWheel=true
	End Object
	Wheels(2)=FThruster

	
	bAttachDriver=true
	bDriverIsVisible=false

	bHomingTarget=true

	BaseEyeheight=110
	Eyeheight=110

	DefaultFOV=90
	CameraLag=0.02
	bCanBeBaseForPawns=true
	bEjectKilledBodies=true

	HornIndex=0
}
