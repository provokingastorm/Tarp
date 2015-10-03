/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
class PRVehicleFactory_BasePod extends UTVehicleFactory;

DefaultProperties
{
	Begin Object Name=SVehicleMesh
		SkeletalMesh=SkeletalMesh'VH_Manta.Mesh.SK_VH_Manta'
		Translation=(X=0.0,Y=0.0,Z=-70.0)
	End Object

	Components.Remove(Sprite)

	Begin Object Name=CollisionCylinder
		CollisionHeight=+40.0
		CollisionRadius=+100.0
	End Object

	VehicleClass = "PRVehicle_BasePod_Content"
	VehicleClassPath="PodRacer.PRVehicle_BasePod_Content"
}
