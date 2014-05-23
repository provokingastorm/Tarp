//==============================================
//Pod Racer Game Info class for the Pod Racer Online game
//
//Base Game File
//
//Author Greg "Ghost142" Mladucky
//Build 8/3/2010
//==============================================

class PRGameInfo extends UTDeathmatch;

`include(PodRacer\Classes\PodRacerGlobals.uci);

// Number of Laps to win the race
var int TotalLaps; // TODO TARP: Add a mutator override 

var array<PRPlayerController> AllPods;
var PRPlayerController PlayerPlaces[PR_MAX_PLAYERS];

var PRPlayerStart RaceStarts[PR_MAX_PLAYERS];
var privatewrite bool bAllPodStartsFound;

var bool bGetStartPositions;

// The pod that is spawned for the player
var UTVehicle SpawnedPod;

/**
 *  This is called before gameplay has occured.
 *  
 *  getRaceInfo() is called to find all gameplay
 *  related info needed for the race
 */
event PostBeginPlay() 
{
	local PRPlayerStart P;

	super.PostBeginPlay();

	foreach WorldInfo.AllActors(class'PRPlayerStart', P)
	{
		if(P.PodStartPosition < 1 || P.PodStartPosition > PR_MAX_PLAYERS)
		{
			`log("WARNING " $ `location $ ": Found an invalid starting position for pod player start, " $ P $ ", with position, " $ P.PodStartPosition);
			bAllPodStartsFound = false;
			continue;
		}

		if(RaceStarts[P.PodStartPosition-1] != none)
		{
			`log("WARNING " $ `location $ ": Found a duplicate pod player start, " $ P $ ", with position, " $ P.PodStartPosition);
			bAllPodStartsFound = false;
			continue;
		}

		RaceStarts[P.PodStartPosition-1] = P;
	}

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
	super.RestartPlayer(NewPlayer);
	SetPlayerPod(NewPlayer,SpawnedPod);
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
    local class<Pawn> DefaultPlayerClass;
    local Rotator StartRotation;
    local Pawn ResultPawn;
	

    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);

    // don't allow pawn to be spawned with any pitch or roll
    StartRotation.Yaw = StartSpot.Rotation.Yaw;

    ResultPawn = Spawn(DefaultPlayerClass,,,StartSpot.Location,StartRotation);
    if ( ResultPawn == None )
    {
        LogInternal("Couldn't spawn player of type "$DefaultPlayerClass$" at "$StartSpot);
    }
    
    SpawnPlayerPod(StartSpot, NewPlayer);
    
    return ResultPawn;
}

/**
 * Spawns the Player's pod directly above the player so it doesn't spawn inside him and kill him
 * @param PlayerSpawn - The point where the player pawn was just spawned
 */
function SpawnPlayerPod(NavigationPoint PlayerSpawn, Controller NewPlayer)
{
	local Vector SpawnLoc;
	local Rotator StartRotation;

	local PRPlayerController P;

	P = PRPlayerController(NewPlayer);
	
	 // don't allow pawn to be spawned with any pitch or roll
    StartRotation.Yaw = PlayerSpawn.Rotation.Yaw;

	SpawnLoc = PlayerSpawn.Location;
	
	// Spawn's the vehicle right above the player's spawn point, Change the number to whatever is needed
	SpawnLoc.Z = SpawnLoc.Z + 786;
	
	switch(P.PodNumber)
	{
	case 0:
		SpawnedPod = Spawn(class'PRVehicle_BasePod_Content',,,SpawnLoc,StartRotation);
		break;

	default:
		SpawnedPod = Spawn(class'PRVehicle_BasePod_Content',,,SpawnLoc,StartRotation);
		break;
	}
}

/** setPlayerPod()
 * GPM - Takes the new player controller from restart player and makes him enter the pod on his pawn spawning
 * @param Player - The controller which is trying to enter the pod
 * @param PlayerPod - The vehicle the player enters
 */
function SetPlayerPod(Controller Player, UTVehicle PlayerPod)
{
	if(PlayerPod != none)
	{
		PlayerPod.DriverEnter(Player.Pawn);		
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
function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string IncomingName )
{
	local NavigationPoint N, BestStart;
	local Teleporter Tel;
	local PRPlayerController P;

	P = PRPlayerController(Player);
	
	// allow GameRulesModifiers to override playerstart selection
	if (BaseMutator != None)
	{
		N = BaseMutator.FindPlayerStart(Player, InTeam, IncomingName);
		if (N != None)
		{
			return N;
		}
	}

	// if incoming start is specified, then just use it
	if(IncomingName != "")
	{
		ForEach WorldInfo.AllNavigationPoints( class 'Teleporter', Tel )
			if( string(Tel.Tag)~=incomingName )
				return Tel;
	}

	// always pick StartSpot at start of match
	if ( ShouldSpawnAtStartSpot(Player) &&
		(PlayerStart(Player.StartSpot) == None || RatePlayerStart(PlayerStart(Player.StartSpot), InTeam, Player) >= 0.0) )
	{
		return Player.StartSpot;
	}

	if(bGetStartPositions)
	{
		BestStart = ChoosePlayerStart(Player, InTeam);
	}
	else
	{
		BestStart = FindPodStartingSpot(P);
	}

	if(BestStart == None && Player == None)
	{
		// no playerstart found, so pick any NavigationPoint to keep player from failing to enter game
		`log("Warning - PATHS NOT DEFINED or NO PLAYERSTART with positive rating");
		ForEach AllActors( class 'NavigationPoint', N )
		{
			BestStart = N;
			break;
		}
	}
	return BestStart;
}

defaultproperties
{
	Acronym="PR"

	MapPrefixes.Empty
	MapPrefixes(0)="PR"
	MapPrefixes(1)="PRO"

	PlayerReplicationInfoClass=class'PRPlayerReplicationInfo'
	PlayerControllerClass=class'PRPlayerController'
	DefaultPawnClass=class'PRPawn'

	TotalLaps=3

	//bGetStartPositions=true

	bUseClassicHUD=true // Disables UT's scaleform HUD
	HudType=class'PodRacer.PRHud'
}
