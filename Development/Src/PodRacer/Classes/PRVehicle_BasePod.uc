class PRVehicle_BasePod extends UTVehicle;

/** Suspension height when Pod is being driven around normally */
var(Movement) protected float FullWheelSuspensionTravel;

/** controls how fast to interpolate between various suspension heights */
var(Movement) protected float SuspensionTravelAdjustSpeed;

/** Suspension stiffness when Pod is being driven around normally */
var(Movement) protected float FullWheelSuspensionStiffness;

/** Suspension stiffness when manta is crouching */
var(Movement) protected float CrouchedWheelSuspensionStiffness;

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
	// Don't Let The Player Exit The Pod
	return false;
}

event Tick(Float DeltaSeconds)
{
	local bool bAdjustSuspension;
	local float DesiredSuspensionTravel, ClampedDeltaSeconds;
	local int i;
	
	super.Tick(DeltaSeconds);

	if ( bDeadVehicle )
	{
		return;
	}
	
	AirSpeed = FullAirSpeed;
	if ( bDriving )
	{
		DesiredSuspensionTravel = FullWheelSuspensionTravel;

		ClampedDeltaSeconds = FMin(DeltaSeconds, 0.1);
		for ( i=0; i<Wheels.Length; i++ )
		{
			bAdjustSuspension = false;

			if ( Wheels[i].SuspensionTravel > DesiredSuspensionTravel )
			{
				// instant crouch
				bAdjustSuspension = true;
				Wheels[i].SuspensionTravel = DesiredSuspensionTravel;
				SimObj.WheelSuspensionStiffness = CrouchedWheelSuspensionStiffness;
			}
			else if ( Wheels[i].SuspensionTravel < DesiredSuspensionTravel )
			{
				// slow rise
				bAdjustSuspension = true;
				Wheels[i].SuspensionTravel = FMin(DesiredSuspensionTravel, Wheels[i].SuspensionTravel + SuspensionTravelAdjustSpeed*ClampedDeltaSeconds);
				SimObj.WheelSuspensionStiffness = FullWheelSuspensionStiffness;
			}
			if ( bAdjustSuspension )
			{
				Wheels[i].BoneOffset.Z = -1.0 * (Wheels[i].SuspensionTravel + Wheels[i].WheelRadius + BoneOffsetZAdjust);
				bUpdateWheelShapes = true; 
			}
		}
	}
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
	CrouchedWheelSuspensionStiffness=40.0
	SuspensionTravelAdjustSpeed=100
	BoneOffsetZAdjust=45.0
	CustomGravityScaling=2.0 //GPM - Was 0.8

	AirSpeed=8000.0 //was - 1800.0
	GroundSpeed=8000.0 //was - 1500.0
	FullAirSpeed=8000.0 //was - 1800.0
	bCanCarryFlag=false
	bFollowLookDir=false // PSB - was True
	bTurnInPlace=False // PSB - was True
	bScriptedRise=True
	bCanStrafe=False
	SpawnRadius=256.0
	MomentumMult=0.25//GPM- was 3.2

	bStayUpright=true
	StayUprightRollResistAngle=5.0
	StayUprightPitchResistAngle=5.0
	StayUprightStiffness=450
	StayUprightDamping=2//GPM - was 20

	AccelRate = 2.0 //GPM-Does NOTHING
	MaxSpeed=25000.000000  //GPM - Added this code from base vehicle code, wasnt allowing faster movement - look back in previous code to find defaults

	/*Begin Object Class=UDKVehicleSimCar Name=SimObject
		WheelSuspensionStiffness=100.0
		WheelSuspensionDamping=3.0
		WheelSuspensionBias=0.1
		ChassisTorqueScale=0.0
		MaxBrakeTorque=5.0
		StopThreshold=100

		MaxSteerAngleCurve=(Points=((InVal=0,OutVal=45),(InVal=600.0,OutVal=15.0),(InVal=1100.0,OutVal=10.0),(InVal=1300.0,OutVal=6.0),(InVal=1600.0,OutVal=1.0)))
		SteerSpeed=110

		LSDFactor=0.0
		TorqueVSpeedCurve=(Points=((InVal=-600.0,OutVal=0.0),(InVal=-300.0,OutVal=80.0),(InVal=0.0,OutVal=130.0),(InVal=950.0,OutVal=130.0),(InVal=1050.0,OutVal=10.0),(InVal=1150.0,OutVal=0.0)))
		EngineRPMCurve=(Points=((InVal=-500.0,OutVal=2500.0),(InVal=0.0,OutVal=500.0),(InVal=549.0,OutVal=3500.0),(InVal=550.0,OutVal=1000.0),(InVal=849.0,OutVal=4500.0),(InVal=850.0,OutVal=1500.0),(InVal=1100.0,OutVal=5000.0)))
		EngineBrakeFactor=0.025
		ThrottleSpeed=0.2
		WheelInertia=0.2
		NumWheelsForFullSteering=4
		SteeringReductionFactor=0.0
		SteeringReductionMinSpeed=1100.0
		SteeringReductionSpeed=1400.0
		bAutoHandbrake=true
		bClampedFrictionModel=true
		FrontalCollisionGripFactor=0.18
		ConsoleHardTurnGripFactor=1.0
		HardTurnMotorTorque=0.7

		SpeedBasedTurnDamping=20.0
		AirControlTurnTorque=40.0
		InAirUprightMaxTorque=15.0
		InAirUprightTorqueFactor=-30.0

		// Longitudinal tire model based on 10% slip ratio peak
		WheelLongExtremumSlip=0.1
		WheelLongExtremumValue=1.0
		WheelLongAsymptoteSlip=2.0
		WheelLongAsymptoteValue=0.6

		// Lateral tire model based on slip angle (radians)
   		WheelLatExtremumSlip=0.35     // 20 degrees
		WheelLatExtremumValue=0.9
		WheelLatAsymptoteSlip=1.4     // 80 degrees
		WheelLatAsymptoteValue=0.9

		bAutoDrive=false
		AutoDriveSteer=0.3
	End Object*/
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