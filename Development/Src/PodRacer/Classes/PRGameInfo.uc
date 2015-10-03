class PRGameInfo extends UTGame;

`include(PodRacer\Classes\PodRacerGlobals.uci);

// Number of Laps to win the race
var int TotalLaps; // TODO TARP: Add a mutator override 

var array<PRPlayerController> AllPods;
var PRPlayerController PlayerPlaces[PR_MAX_PLAYERS];
var const array<EPodStartPosition> StartPositionMap;

var PRPlayerStart RaceStarts[PR_MAX_PLAYERS];
var privatewrite bool bAllPodStartsFound;

var bool bGetStartPositions;

var() RaceDirector RDirector;

event PreBeginPlay()
{
	super.PreBeginPlay();

	RDirector = Spawn(class'RaceDirector', self);
	RDirector.LapCount = 3;
}

/**
 *  This is called before gameplay has occured.
 *  
 *  getRaceInfo() is called to find all gameplay
 *  related info needed for the race
 */
event PostBeginPlay() 
{
	super.PostBeginPlay();

	GetRaceInfo();
}

/**
 * Goes to PRPodInfo to find the level's race info
 */
function GetRaceInfo()
{
	local PRPodInfo P;
	local PRPodInfo PInfo;

	foreach AllActors( class 'PRPodInfo', PInfo )
	{
		P = PInfo;
		break;
	}
	
	if(P != none && P.TotalLaps > 0)
	{	
		TotalLaps = P.TotalLaps;
	}
	else
	{
		TotalLaps = 3;
	}
}   


/**
 * Checks the player's laps to find the winner
 * Also finds if the 3rd place player has crossed the finish line
 * and sets a timer to count down (6 seconds) until the race is over allowing
 * a small amount of time to pass for other players to finish up - Needs to have 
 * a 2 player game else if() added if not playing with 3 people - right now game doesn't end without 3 players
 * @param Laps - Number of laps completed by the playerController
 */
function CheckLapNumbers(int Laps, PRPlayerController P)
{	
	local PRPlayerController PlayerWinner;
	local int i;

	`log("Check Lap Numbers and total laps needed: " $ TotalLaps);
	if(Laps == TotalLaps)
	{
		if(P != none)
		{
			PlayerWinner = PlayerPlaces[0];
			for(i=0; i<16;i++)
			{
				`Log("Player " $ PlayerPlaces[i] $ " took " $ i+1 $ " place.");
			}
			EndGame(PlayerWinner.PlayerReplicationInfo, "timelimit");
		}
		
	}
	else
	{
		//GPM-Do Nothing, the race isn't over yet//
	}
}

/**
 * Function called when a player pawn is created - Overrided to allow our pawns to be spawned in vehicles
 * @param NewPlayer - used for passing the player's controller from pawn to pawn
 */
function RestartPlayer(Controller NewPlayer)
{
	local PRPlayerController P;
	local PRPlayerReplicationInfo PRI;
	local EPodStartPosition SpawnPosition;

	super.RestartPlayer(NewPlayer);
	
	P = PRPlayerController(NewPlayer);
	PRI = PRPlayerReplicationInfo(P.PlayerReplicationInfo);
	
	if(PRI != None && PRI.StartingPosition >= 0 && PRI.StartingPosition < PSP_Max)
	{
		SpawnPosition = StartPositionMap[PRI.StartingPosition];
		SpawnPlayerPod(P, SpawnPosition);
	}
}

/**
 * Function taken from unreal GameInfo code - Slightly altered
 * Returns a pawn of the default pawn class
 *
 * @param	NewPlayer - Controller for whom this pawn is spawned
 * @param	StartSpot - PlayerStart at which to spawn pawn
 *
 * @return	pawn
 */
function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local Pawn ResultPawn;
	
    ResultPawn = super.SpawnDefaultPawnFor(NewPlayer, StartSpot);
    //SpawnPlayerPod(StartSpot, NewPlayer, PSP_First);
    
    return ResultPawn;
}

function SpawnPlayerPod(PRPlayerController NewPlayer, EPodStartPosition StartPosition)
{
	local PRPlayerStart PRStart;
	local UTVehicle SpawnedPod;

	foreach AllActors(class'PRPlayerStart', PRStart)
	{
		if(PRStart.StartPosition == StartPosition)
		{
			`log("PETE LOG: Spawning manta at" @ PRStart);
			SpawnedPod = Spawn(class'PRVehicle_BasePod_Content', self,, PRStart.Location, PRStart.Rotation);

			if(NewPlayer.Pawn != None)
			{
				SpawnedPod.DriverEnter(NewPlayer.Pawn);		
			}
			break;
		}
	}
}

/** 
 *  Finds the closest pathnode to the players last death location
 *  @param PlayerDeathLoc - Used as a vector storing the last know location of the pod before it died
 */
function PathNode FindClosestPathNode(Vector PlayerDeathLoc)
{
	local float Dist;
	local float BestDist;
	local PathNode BestStart;
	local PathNode P;

	foreach WorldInfo.AllNavigationPoints(class'PathNode', P)
	{
		Dist = VSize(P.Location - PlayerDeathLoc);
		if(BestDist != 0.f)
		{
			if(Dist < BestDist)
			{
				BestStart = P;
				BestDist = Dist;
			}
		}
		else
		{
			// Choose the first distance calculation
			BestStart = P;
			BestDist = Dist;			
		}
	}

	`log("Best Player Start Is: " $ BestStart);

	return BestStart;
}

function PRPlayerStart FindPodStartingSpot(PRPlayerController PRPC)
{
	local PRPlayerStart BestStart;
	local PRPlayerStart P;

	foreach WorldInfo.AllActors(class'PRPlayerStart', P)
	{
		`log("Found a pod racer start spot " $ P);
		BestStart = P;
	}

	`log("Best Player Start Is: " $ BestStart);

	return BestStart;
}

/**
* Return the 'best' player start for this player to start from.  PlayerStarts are rated by RatePlayerStart().
* @param Player is the controller for whom we are choosing a playerstart
* @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
* @param IncomingName specifies the tag of a teleporter to use as the Playerstart
* @returns NavigationPoint chosen as player start (usually a PlayerStart)
 */
/*function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string IncomingName )
{
	local PlayerStart StartPoint, BackupStart;

	foreach AllActors(class'PlayerStart', StartPoint)
	{
		if(BackupStart == none)
		{
			BackupStart = StartPoint;
		}

		if(PRPlayerStart(StartPoint) == none)
		{
			return StartPoint;
		}
	}

	return BackupStart;
}*/

defaultproperties
{
	Acronym="PR"

	MapPrefixes.Empty
	MapPrefixes(0)="PR"
	MapPrefixes(1)="PRO"

	PlayerReplicationInfoClass=class'PRPlayerReplicationInfo'
	PlayerControllerClass=class'PRPlayerController'
	DefaultPawnClass=class'PRPawn'

	TotalLaps = 3

	//bGetStartPositions=true

	bUseClassicHUD=true // Disables UT's scaleform HUD
	HudType=class'PodRacer.PRHud'

	StartPositionMap(0)=PSP_First
	StartPositionMap(1)=PSP_Second
	StartPositionMap(2)=PSP_Third
	StartPositionMap(3)=PSP_Fourth
	StartPositionMap(4)=PSP_Fifth
	StartPositionMap(5)=PSP_Sixth
	StartPositionMap(6)=PSP_Seventh
	StartPositionMap(7)=PSP_Eigth
}
