class PRHUD extends HUD;

function DrawGameHud()
{

    Canvas.SetPos(Canvas.ClipX/2,Canvas.ClipY/2);
    Canvas.SetDrawColor(255,255,255,255);
    Canvas.Font = class'Engine'.static.GetMediumFont();
    //Canvas.DrawTextCentered("Hello World");

    //if ( !PlayerOwner.IsDead() && !UTPlayerOwner.IsInState('Spectating'))
    //{
    //    DrawBar("Health",PlayerOwner.Pawn.Health, PlayerOwner.Pawn.HealthMax,20,20,200,80,80);         
	//	//DrawBar("Heat",UTWeapon(PawnOwner.Weapon).AmmoCount, UTWeapon(PawnOwner.Weapon).MaxAmmoCount ,20,40,80,80,200);     
	//}
}

function DrawBar(String  Title, float Value, float MaxValue,int X, int Y, int R, int G, int B)
{

    local int PosX,NbCases,i;

    PosX = X; // Where we should draw the next rectangle
    NbCases = 10 * Value / MaxValue; // Number of active rectangles to draw
    i=0; // Number of rectangles already drawn

    /* Displays active rectangles */
    while(i < NbCases && i < 10)
    {
        Canvas.SetPos(PosX,Y);
        Canvas.SetDrawColor(R,G,B,200);
        Canvas.DrawRect(8,12);

        PosX += 10;
        i++;

    }

    /* Displays desactived rectangles */
    while(i < 10)
    {
        Canvas.SetPos(PosX,Y);
        Canvas.SetDrawColor(255,255,255,80);
        Canvas.DrawRect(8,12);

        PosX += 10;
        i++;

    }

    /* Displays a title */
    Canvas.SetPos(PosX + 5,Y);
    Canvas.SetDrawColor(R,G,B,200);
    Canvas.Font = class'Engine'.static.GetSmallFont();
    Canvas.DrawText(Title);
} 

defaultproperties
{
} 