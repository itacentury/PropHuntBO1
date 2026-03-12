#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\ui;
#include maps\mp\gametypes\prophunt\utils;
#include maps\mp\gametypes\prophunt\controls;

/*
TODO:
Import all models from map editor
Remove too small models, as they are too unfair
Get game logic right
Import text and shader methods
Change team names to "Props" and "Hunter"
Game lengh 10 minutes
Add UAV for Hunter for the last minute
Players who join the game after prophunt already started are frozen, given an info message, then killed and then set to spectator mode 
*/

main() {
	level.currentGametype = getDvar("g_gametype");
	level.propHuntStarted = false;

	level.minZoom = 125;
    level.maxZoom = 525;
    level.zoomChangeRate = 3;

	maps\mp\gametypes\Props\props::onPrecacheGameModels();
	level thread onPlayerConnect();
}

onPlayerConnect() {
	for (;;) {
		level waittill("connecting", player);

		player.propTeam = undefined; //"Prop" "Hunter" "Spectator"

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned() {
	self endon("disconnect");

	firstSpawn = true;

	for (;;) {
		self waittill("spawned_player");

		if (firstSpawn) {
			if (level.currentGametype == "tdm") {
				self iPrintLn("Welcome to Prop Hunt: Black Ops Edition!");
				self freezeControls(false);

				if (self isHost()) {
					if (!level.propHuntStarted) {
						self startPropHuntText();
					}
				} else {
					//if player joins the game and prophunt already started, he becomes a spectator until the next game
					if (level.propHuntStarted) {
						if (isAlive(self)) {
							self.propTeam = "spectator";
							self changeMyTeam("spectator");
							self suicide();
						}
					}
				}

				self monitorButtons();
			} else {
				self iPrintLn("Only TDM is supported. Please restart with the TDM gametype.");
			}

			firstSpawn = false;
		}
	}
}
