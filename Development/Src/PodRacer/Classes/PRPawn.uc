class PRPawn extends UTPawn;

//GPM - Code has been transfered to PRVehicle_PodBase_Content so the pod now hits checkpoints

/*
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
*/

DefaultProperties
{
GroundSpeed = 4000
}
