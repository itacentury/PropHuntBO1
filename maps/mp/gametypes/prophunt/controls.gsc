#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\setup;

monitorButtons() {
	self endon("disconnect");

	for (;;) {
		if (!level.propHuntStarted) {
			if (self isHost()) {
				if (self adsButtonPressed() && self actionSlotTwoButtonPressed()) {
					self setupGameDvars();
					self startPropHunt();
					iPrintLn("Prop Hunt has ^2started!");
					level.propHuntStarted = true;

					self.startPropHuntText destroy();

					wait 0.12;
				}
			}
		} else {
			if (self.propTeam == "prop") {
				//monitorButtons for props
			} else if (self.propTeam == "hunter") {
				//monitorButtons for hunter
			}
		}
		wait 0.05;
	}
}