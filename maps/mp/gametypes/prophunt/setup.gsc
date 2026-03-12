#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\prop;
#include maps\mp\gametypes\prophunt\hunter;

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
