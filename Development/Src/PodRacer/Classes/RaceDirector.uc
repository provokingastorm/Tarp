class RaceDirector extends Actor;

var() int LapCount;

replication
{
	if (bNetDirty || bNetInitial)
		LapCount;
}

defaultproperties
{
	RemoteRole=ROLE_AutonomousProxy
	bAlwaysRelevant=true
}
