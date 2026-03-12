#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\ui;
#include maps\mp\gametypes\prophunt\utils;

propLogic() {
	self iPrintLnBold("You are a Prop! Choose your model and find a hiding spot!");

	self changeMyTeam("allies");
	self.pers["lives"] = 1;
	self.pers["mode"] = "normal";
	self disableWeapons();
    self allowAds(false);
	self setClientDvars("cg_thirdPerson", "1", "cg_thirdPersonAngle", "360", "cg_thirdPersonRange", "200");
	self propControlsText();
	self maps\mp\gametypes\Props\props::buildMode();
	self.inMapEditor = true;

	self clearPerks();
	//Ninja Pro
	self setPerk("specialty_quieter");
	self setPerk("specialty_loudenemies");
	//Lightweight Pro
	self setPerk("specialty_fallheight");
	self setPerk("specialty_movefaster");
	//No name from Ghost Perk
	self setPerk("specialty_noname");
}

resetOnDeath() {
	self waittill("death");

	self.inMapEditor = false;
	self enableWeapons();
	self allowAds(true);
	self setClientDvar("cg_thirdPerson", "0");
	self show();

	if (isDefined(self.pers["myProp"])) {
		self.pers["myProp"] delete();
	}

	self.changeModelText destroy();
	self.rotateModelText destroy();
	self.changeFOVText destroy();
	self.currentModelText destroy();

	//delete text
	//set spectator
}