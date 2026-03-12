#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\ui;
#include maps\mp\gametypes\prophunt\utils;
#include maps\mp\gametypes\prophunt\controls;

propLogic() {
	self iPrintLnBold("You are a Prop! Choose your model and find a hiding spot!");

	self changeMyTeam("allies");
	self disableWeapons();
    self allowAds(false);
	self setClientDvar("cg_thirdPerson", "1");
	self setClientDvar("cg_thirdPersonAngle", "360");
	self setClientDvar("cg_thirdPersonRange", "200");
	self propControlsText();
	
	if (isDefined(self.pers["myProp"])) {
        self.pers["myProp"] delete();
	}

    usableModelsKeys = getArrayKeys(level.usableModels);
    self.pers["myProp"] = spawn("script_model", self.origin);
    self.pers["myProp"].health = 10000;
    self.pers["myProp"].owner = self;
    self.pers["myProp"].angles = self.angles;
    self.pers["myProp"].indexKey = randomInt(level.MAX_USABLE_MODELS);
    self.pers["myProp"] setModel(level.usableModels[usableModelsKeys[self.pers["myProp"].indexKey]]);
    self.currentModelText setText("Current model: " + level.usableModels[usableModelsKeys[self.pers["myProp"].indexKey]]);

    self hide();
    self.pers["myProp"] setCanDamage(true);
    self thread detachOnDisconnect();
    self thread attachModel();

	self clearPerks();
	//Ninja Pro
	self setPerk("specialty_quieter");
	self setPerk("specialty_loudenemies");
	// No fall damage
	self setPerk("specialty_fallheight");
	//No visible nametag
	self setPerk("specialty_noname");

    self thread monitorPropButtons();
}

resetOnDeath() {
	self waittill("death");

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