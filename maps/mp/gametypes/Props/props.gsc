/*
 __  __             ______    _ _ _             
|  \/  |           |  ____|  | (_) |            
| \  / | __ _ _ __ | |__   __| |_| |_ ___  _ __ 
| |\/| |/ _` | '_ \|  __| / _` | | __/ _ \| '__|
| |  | | (_| | |_) | |___| (_| | | || (_) | |   
|_|  |_|\__,_| .__/|______\__,_|_|\__\___/|_|   
             | |                                
             |_|     
			 
The MapEditor Project
Created by JariZ & Scripts18
Based on SparkyMcSparks' HideNSeek
Ported by Century
(c) JariZ.nl 2011
This a open-source project. for more information see LICENSE.TXT
*/

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\Props\assets;
#include maps\mp\gametypes\_globallogic_score;

buildMode() {
	self notify("me_buildmode");
    self notify("stop_ammo");

    if (isDefined(self.pers["myProp"])) {
        self.pers["myProp"] delete();
	}

    //modes
	if (self.pers["mode"] == "normal") {
		usableModelsKeys = getArrayKeys(level.usableModels);
		self.pers["myProp"] = spawn("script_model", self.origin);
		self.pers["myProp"].health = 10000;
		self.pers["myProp"].owner = self;
		self.pers["myProp"].angles = self.angles;
		self.pers["myProp"].indexKey = randomInt(level.MAX_USABLE_MODELS);
		self.pers["myProp"] setModel(level.usableModels[usableModelsKeys[self.pers["myProp"].indexKey]]);
        self.currentModelText setText("Current model: " + level.usableModels[usableModelsKeys[self.pers["myProp"].indexKey]]);
	}

    self hide();
    self.pers["myProp"] setCanDamage(true);
    self.pers["myProp"] thread detachOnDisconnect(self);
    self.pers["myProp"] thread attachModel(self);
    self thread monitorKeyPress();
}

attachModel(player) {
    player endon("disconnect");
    player endon("killed_player");
    player endon("death");
    self endon("death");

    for (;;) {
        if (self.origin != player.origin) {
            self moveTo(player.origin, 0.1);
        }

        wait 0.01;
    }
}

detachOnDisconnect(player) {
    player endon("death");
    player endon("killed_player");
	
    player waittill("disconnect");
	
    modelOrigin = self.origin;
    self delete();
}

onPrecacheGameModels() {
    precacheLevelModels();
    if (isDefined(level.availableModels) && level.availableModels.size > 0 ) {
        level.availableModels = array_randomize(level.availableModels);
        if (level.availableModels.size < level.MAX_USABLE_MODELS) {
            level.MAX_USABLE_MODELS = level.availableModels.size;
        }

        availableModelsKeys = getArrayKeys(level.availableModels);
        if (!isDefined(level.usableModels)) {
            level.usableModels = [];
        }

        for (x = 0; x < level.availableModels.size; x++) {
            precacheModel(level.availableModels[availableModelsKeys[x]]);
            level.usableModels[level.availableModels[availableModelsKeys[x]]] = level.availableModels[availableModelsKeys[x]];
            if (level.usableModels.size >= level.MAX_USABLE_MODELS) {
                return;
            }
        }
    }
	else {
		self iPrintLn("Error: Failed to load models. No models have been assigned.");
    }
}

precacheLevelModels() {
    if (isDefined(level.force_hns_models)) {
        [[level.force_hns_models]]();
        return;
    }

    switch (getDvar(#"mapname")) {
        case "mp_array":
            mpArrayPrecache();
            break;
        case "mp_berlinwall2":
            mpBerlinwall2Precache();
            break;
        case "mp_cairo":
            mpCairoPrecache();
            break;
        case "mp_cosmodrome":
            mpCosmodromePrecache();
            break;
        case "mp_cracked":
            mpCrackedPrecache();
            break;
        case "mp_crisis":
            mpCrisisPrecache();
            break;
        case "mp_discovery":
            mpDiscoveryPrecache();
            break;
        case "mp_duga":
            mpDugaPrecache();
            break;
        case "mp_firingrange":
            mpFiringrangePrecache();
            break;
        case "mp_gridlock":
            mpGridlockPrecache();
            break;
        case "mp_hanoi":
            mpHanoiPrecache();
            break;
        case "mp_havoc":
            mpHavocPrecache();
            break;
        case "mp_hotel":
            mpHotelPrecache();
            break;
        case "mp_kowloon":
            mpKowloonPrecache();
            break;
        case "mp_mountain":
            mpMountainPrecache();
            break;
        case "mp_nuked":
            mpNukedPrecache();
            break;
        case "mp_outskirts":
            mpOutskirtsPrecache();
            break;
        case "mp_radiation":
            mpRadiationPrecache();
            break;
        case "mp_russianbase":
            mpRussianbasePrecache();
            break;
        case "mp_stadium":
            mpStadiumPrecache();
            break;
        case "mp_villa":
            mpVillaPrecache();
            break;
        case "mp_zoo":
            mpZooPrecache();
            break;
        default:
            break;
    }
}

monitorKeyPress() {
	self endon("disconnect");
    self endon("killed_player");
    self endon("death");
	self endon("me_buildmode"); //kill when buildmode restarts
    level endon("game_ended");

    usableModelsKeys = getArrayKeys(level.usableModels);
    minZoom = 125;
    maxZoom = 525;
    zoomChangeRate = 5;
    self Hide();
    self.pers["myprop"].rotateYaw_attack = spawnStruct();
    self.pers["myprop"].rotateYaw_attack.value = 0;
    self.pers["myprop"].rotateYaw_attack.check = ::attackCheck;
    self.pers["myprop"].rotateYaw_attack.max = -50;
    self.pers["myprop"].rotateYaw_attack.change_rate = 1;
    self.pers["myprop"].rotateYaw_attack.reset_rate = 50;
    self.pers["myprop"].rotateYaw_ads = spawnStruct();
    self.pers["myprop"].rotateYaw_ads.value = 0;
    self.pers["myprop"].rotateYaw_ads.check = ::adsCheck;
    self.pers["myprop"].rotateYaw_ads.max = 50;
    self.pers["myprop"].rotateYaw_ads.change_rate = 1;
    self.pers["myprop"].rotateYaw_ads.reset_rate = 50;
    self.pers["myprop"].angles = self.angles;

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

        if (self actionSlotOneButtonPressed()) {
            if (getDvarInt("cg_thirdPersonRange") > level.minZoom) {
                self setClientDvar("cg_thirdPersonRange", getDvarInt("cg_thirdPersonRange") - level.zoomChangeRate);
            }
        }

        if (self actionSlotTwoButtonPressed()) {
            if (getDvarInt("cg_thirdPersonRange" ) < level.maxZoom) {
                self setClientDvar("cg_thirdPersonRange", getDvarInt("cg_thirdPersonRange") + level.zoomChangeRate);
            }
        }

        self buttonHeldCheck(self.pers["myProp"].rotateYaw_attack);
        self buttonHeldCheck(self.pers["myProp"].rotateYaw_ads);
        self.pers["myProp"] rotateYaw(self.pers["myProp"].rotateYaw_ads.value + self.pers["myProp"].rotateYaw_attack.value, 0.5);
        
        wait .05;
    }
}

buttonHeldCheck(struct) {
    self endon("disconnect");
    self endon("death");

	if ([[struct.check]]()) {
        if (struct.max > 0) {
            struct.value += struct.change_rate;
        } else {
            struct.value -= struct.change_rate;
        }
    } else if (struct.value != 0) {
        if (struct.value > 0) {
            struct.value -= struct.reset_rate;
        } else {
            struct.value += struct.reset_rate;
        }

        if (abs(struct.value) < struct.reset_rate) {
            struct.value = 0;
        }
    }

    if (struct.max > 0) {
        if (struct.value > struct.max) {
            struct.value = struct.max;
        }
    } else {
        if (struct.value < struct.max) {
            struct.value = struct.max;
        }
    }
}

adsCheck() {
    return self adsButtonPressed();
}

attackCheck() {
    return self attackButtonPressed();
}
