#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\prop;
#include maps\mp\gametypes\prophunt\hunter;
#include maps\mp\gametypes\prophunt\assets;

setupPropHuntDvars() {
	scorelimit = (level.players.size - 1) * 100;
    if (scorelimit == 0) {
        scorelimit = 100;
    }

    setDvar("scr_tdm_scorelimit", int(scorelimit));
    self setClientDvar("cg_objectiveText", maps\mp\gametypes\_globallogic_ui::getObjectiveScoreText(self.pers["team"]), int(scorelimit));

	level.allow_teamchange = "0";
	setDvar("scr_disable_cac", 1);
	setDvar("g_allow_teamchange", 0);
	setDvar("ui_allow_teamchange", 0);

	setDvar("g_TeamName_Allies", "Prop");
    setDvar("g_TeamName_Axis", "Hunter");
	setDvar("ls_gametype", "PROP HUNT");
	setDvar("ui_gametype", "PROP HUNT");
	setDvar("ui_customModeEditName", "PROP HUNT");
}

resetPropHuntDvars() {
    if (level.prophuntDvarsReset) {
        return;
    }

    setDvar("scr_tdm_scorelimit", level.originalScoreLimit);
    for (i = 0; i < level.players.size; i++) {
        player = level.players[i];
        player setClientDvar("cg_objectiveText", maps\mp\gametypes\_globallogic_ui::getObjectiveScoreText(player.pers["team"]), level.originalScoreLimit);
    }

	level.allow_teamchange = "1";
	setDvar("scr_disable_cac", 0);
	setDvar("g_allow_teamchange", 1);
	setDvar("ui_allow_teamchange", 1);

    level.prophuntDvarsReset = true;
}

startPropHunt() {
	playerNumber = level.players.size;
	hunterNumber = randomInt(playerNumber - 1);
	hunter = level.players[hunterNumber];
	hunter.propTeam = "hunter";
	level.hunterPlayer = hunter;

	//testing
	getHostPlayer().propTeam = "prop";

	for (i = 0; i < level.players.size; i++) {
		player = level.players[i];

		if (!isDefined(player.propTeam)) {
			player.propTeam = "prop";
		}

		if (player.propTeam == "prop") {
			player propLogic();
		} else if (player.propTeam == "hunter") {
			player hunterLogic();
		}
	}
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
