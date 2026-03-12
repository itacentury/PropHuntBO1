#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\setup;

monitorButtons() {
	self endon("disconnect");

	for (;;) {
		if (level.propHuntStarted) {
            continue;
        }

        if (!self isHost()) {
            continue;
        }

        if (self adsButtonPressed() && self actionSlotTwoButtonPressed()) {
            self setupPropHuntDvars();
            self startPropHunt();
            iPrintLn("Prop Hunt has ^2started!");
            level.propHuntStarted = true;

            self.startPropHuntText destroy();

            wait 0.12;
        }

		wait 0.05;
	}
}

monitorPropButtons() {
	self endon("disconnect");
    self endon("killed_player");
    self endon("death");
    level endon("game_ended");

    usableModelsKeys = getArrayKeys(level.usableModels);
    self.pers["myProp"].angles = self.angles;
    self.thirdPersonRange = getDvarInt("cg_thirdPersonRange");
    self.rotateSpeed = 0;
    self.rotateMax = 45;

    for (;;) {
        if (self actionslotThreeButtonPressed() && isDefined(self.pers["myProp"])) {
            if (self.pers["mode"] == "normal") {
				self.pers["myProp"].indexKey = self.pers["myProp"].indexKey + 1;
				printLn("HNS INDEX: " + self.pers["myProp"].indexKey + "   MAX POS: " + level.MAX_USABLE_MODELS);
				if (self.pers["myProp"].indexKey >= level.MAX_USABLE_MODELS || self.pers["myProp"].indexKey < 0) {
					self.pers["myProp"].indexKey = 0;
				}

                model = level.usableModels[usableModelsKeys[self.pers["myProp"].indexKey]];
                self.currentModelText setText("Current model: " + model);
				self.pers["myProp"] setModel(model);
				self.pers["myProp"] notSolid();
			}
        }

        if (self actionSlotFourButtonPressed() && isDefined(self.pers["myProp"])) {
			if (self.pers["mode"] == "normal") {
				self.pers["myProp"].indexKey = self.pers["myProp"].indexKey - 1;
				printLn("HNS INDEX: " + self.pers["myProp"].indexKey + "   MAX POS: " + level.MAX_USABLE_MODELS);
				if (self.pers["myProp"].indexKey >= level.MAX_USABLE_MODELS || self.pers["myProp"].indexKey < 0) {
					self.pers["myProp"].indexKey = 0;
				}

                model = level.usableModels[usableModelsKeys[self.pers["myProp"].indexKey]];
                self.currentModelText setText("Current model: " + model);
				self.pers["myProp"] setModel(model);
				self.pers["myProp"] notSolid();
			}
        }

        while (self adsButtonPressed()) {
            self.rotateSpeed -= 1;
            if (self.rotateSpeed < (-1 * self.rotateMax)) {
                self.rotateSpeed = (-1 * self.rotateMax);
            }

            self.pers["myProp"] rotateYaw(self.rotateSpeed, 0.05);
            wait 0.05;
        }
        self.rotateSpeed = 0;

        while (self attackButtonPressed()) {
            self.rotateSpeed += 1;
            if (self.rotateSpeed > self.rotateMax) {
                self.rotateSpeed = self.rotateMax;
            }

            self.pers["myProp"] rotateYaw(self.rotateSpeed, 0.05);
            wait 0.05;
        }
        self.rotateSpeed = 0;

        while (self fragButtonPressed()) {
            self.thirdPersonRange -= level.zoomChangeRate;
            if (self.thirdPersonRange < level.minZoom) {
                self.thirdPersonRange = level.minZoom;
            }

            self setClientDvar("cg_thirdPersonRange", self.thirdPersonRange);
            wait 0.01;
        }

        while (self secondaryOffhandButtonPressed()) {
            self.thirdPersonRange += level.zoomChangeRate;
            if (self.thirdPersonRange > level.maxZoom) {
                self.thirdPersonRange = level.maxZoom;
            }

            self setClientDvar("cg_thirdPersonRange", self.thirdPersonRange);
            wait 0.01;
        }

        wait 0.05;
    }
}
