//==============================================
//Pod Racer Checkpoint class for the Pod Racer Online game
//
//This is the checkpoint volume to find who touches the checkpoint and passes
//the data over to the PRPlayerController
//Author Greg "Ghost142" Mladucky
//Build 8/3/2010
//==============================================

class PRCheckpointVolume extends Volume
	placeable;

//GPM - Init Varibles//
var() int CheckpointNumber;
var() bool bStartingLine;
var() bool bBridgeToStart;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// match bProjTarget to weapons (zero extent) collision setting
	if (BrushComponent != None)
	{
		bProjTarget = BrushComponent.BlockZeroExtent;
	}
}

simulated function bool StopsProjectile(Projectile P)
{
	return false;
}

defaultproperties
{
	bColored=true
	BrushColor=(R=100,G=255,B=100,A=255)

	//GPM-Set Starting and Bridge To false
	bStartingLine=false
	bBridgeToStart=false

	bCollideActors=true
	bProjTarget=true
	SupportedEvents.Empty
	SupportedEvents(0)=class'SeqEvent_Touch'
	SupportedEvents(1)=class'SeqEvent_TakeDamage'
}