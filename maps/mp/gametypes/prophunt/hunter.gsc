#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\ui;
#include maps\mp\gametypes\prophunt\utils;

hunterLogic() {
	self iPrintLnBold("You are a Hunter! Wait for the Props to hide, then find and eliminate them!");

	self enableInvulnerability();
	self changeMyTeam("axis");

	self clearPerks();
	self takeAllWeapons();
	//Sleight of Hand Pro
	self setPerk("specialty_fastreload");
	self setPerk("specialty_fastads");
	//Lightweight Pro
	self setPerk("specialty_fallheight");
	self setPerk("specialty_movefaster");
	//Scavenger
	self setPerk("specialty_scavenger");
	//Hardened Pro
	self setPerk("specialty_bulletpenetration");
	self setPerk("specialty_armorpiercing");
	self setPerk("specialty_bulletflinch");
	//Steady Aim Pro
	self setPerk("specialty_bulletaccuracy");
	self setPerk("specialty_sprintrecovery");
	self setPerk("specialty_fastmeleerecovery");
	//Marathon Pro
	self setPerk("specialty_longersprint");
	self setPerk("specialty_unlimitedsprint");

	self freezeControls(true);
	self.blindHunter = createRectangle("CENTER", "CENTER", 0, 0, 1920, 10000, 2, "black");

	for (i = 60; i > 0; i--) {
		self iPrintLn("Hunting begins in: " + i);
		wait 1;
	}

	self.blindHunter destroy();
	self freezeControls(false);
	primary = "mac11_mp";
	secondary = "asp_mp";
	self giveWeapon(primary);
	self giveWeapon(secondary);
	self switchToWeapon(primary);
}