class PRPlayerController extends UTPlayerController;

// Player's Vehicle Choice in Numerial form
var int PodNumber;

var PRCheckpointVolume OldCheckpoint;

//N umber of laps the player completed...
var int NumberofCompletedLaps;

// Player's death Location - passed to the GameInfo to find the closest pathnode respawn point
var Vector PlayerDeathLoc;


function InitPlayerReplicationInfo()
{
	local PRPlayerReplicationInfo PRI;

	Super.InitPlayerReplicationInfo();

	PRI = PRPlayerReplicationInfo(PlayerReplicationInfo);
	if(PRI != none)
	{
		PRI.StartingPosition = -1;
	}
}


/**
 * Player Checkpoint system
 * @param NewCheckpoint is the checkpoint volume that the pawn just hit
 */
function HitCheckpoint(PRCheckpointVolume NewCheckpoint)
{
	
	if(NewCheckpoint.bStartingLine && OldCheckpoint == none)
	{
		//  - Checks to see if this is the starting line/begining of the race
		`log("New Checkpoint Number: " $ NewCheckpoint.CheckpointNumber);
		`log("Ready, Set, GO!!!!");

		// -Its the begining so set laps to 0 just in case
		NumberofCompletedLaps=0;
		OldCheckpoint=NewCheckpoint;
		
	}
	else if(NewCheckpoint.bStartingLine && OldCheckpoint.bBridgeToStart && OldCheckpoint != none)
	{
		//  - Checks if players completed a lap - Player must have just hit a bridge to start inorder to complete a lap!!
		`log("Old Checkpoint Number: " $ OldCheckpoint.CheckpointNumber);
		`log("new Checkpoint Number: " $ NewCheckpoint.CheckpointNumber);
		

		NumberofCompletedLaps += 1;
		OldCheckpoint=NewCheckpoint;

		// -Checks Game Info to find out if the game has finished!!!
		PRGameInfo(WorldInfo.Game).CheckLapNumbers(NumberofCompletedLaps, self);

		`log("You have completed " $ NumberofCompletedLaps $ " laps!");
		
		
	}
	else if(!NewCheckpoint.bStartingLine && !NewCheckpoint.bBridgeToStart && NewCheckpoint.CheckpointNumber > OldCheckpoint.CheckpointNumber && NewCheckpoint.CheckpointNumber < (OldCheckpoint.CheckpointNumber + 15) && OldCheckpoint != none)
	{
		//  - Checks to see if its just a normal checkpoint
		`log("Old Checkpoint Number: " $ OldCheckpoint.CheckpointNumber);
		`log("New Checkpoint Number: " $ NewCheckpoint.CheckpointNumber);
		`log("YOU HIT A CHECKPOINT!!!!");

		OldCheckpoint=NewCheckpoint;
	
	}
	else if(!OldCheckpoint.bStartingLine && NewCheckpoint.bBridgeToStart && NewCheckpoint.CheckpointNumber > OldCheckpoint.CheckpointNumber && NewCheckpoint.CheckpointNumber < (OldCheckpoint.CheckpointNumber + 15) && OldCheckpoint != none)
	{
		//  - Checks if checkpoint is the bridge to the starting point
		`log("Old Checkpoint Number: " $ OldCheckpoint.CheckpointNumber);
		`log("New Checkpoint Number: " $ NewCheckpoint.CheckpointNumber);
		`log("YOU HIT THE CHECKPOINT START BRIDGE!!!!");

		OldCheckpoint=NewCheckpoint;
		
	}
	else
	{
		// -Do nothing//
		`log("WRONG WAY!");
	}
}

/**
 * LastHitLoc is passed from PRVehicle_BasePod_Content from event Died and stored here in the PlayerController
 * @param lastHitLoc - Player's death Loc
 */
function FindLastHit(vector lastHitLoc)
{
	PlayerDeathLoc = lastHitLoc;
}

// -Moves player to PlayerStartingLine state
exec function EnterStartingLine()
{
	GotoState('PlayerStartingLine');
}


// -Moves player to Racing state - PlayerDriving state for now...
function EnterRacingState()
{
	GotoState('PlayerDriving');
}

State PlayerStartingLine
{
	//  - Ignores StartFire and alt fire so players cannot fire their weapons
	//They also have no movement in this state so they cannot do anything but wait
	ignores StartFire,StartAltFire;

}

State PlayerRacing // -might need to base this off PLAYERDRIVING state...
{
	//Place PLAYERDRIVING state code here and make changes if needed or base new state off of it	
}

State PlayerRepairing // -Should extend PLAYERRACING state or PLAYERDRIVING state...
{
	//  - Repair state here
}

/** State Dead
 *   -  WIP: Still need to create a working timer for a delay in the respawn, delay in podracer looks like its only a 
 * second or two but its there...
 */
State Dead
{
	reliable server function ServerReStartPlayer()
	{
		if ( WorldInfo.NetMode == NM_Client )
			return;

		// If we're still attached to a Pawn, leave it
		if ( Pawn != None )
		{
			UnPossess();
		}

		WorldInfo.Game.RestartPlayer( Self );
	}
}


defaultproperties
{
}
