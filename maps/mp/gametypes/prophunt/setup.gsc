#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include maps\mp\gametypes\prophunt\prop;
#include maps\mp\gametypes\prophunt\hunter;

setupGameDvars() {
	scorelimit = (level.players.size - 1) * 100;
	if (scorelimit > 0) {
		setDvar("scr_tdm_scorelimit", int(scorelimit));
		self setClientDvar("cg_objectiveText", maps\mp\gametypes\_globallogic_ui::getObjectiveScoreText(self.pers["team"]), int(scorelimit));
	}

	level.allow_teamchange = "0";
	setDvar("scr_disable_cac", 1);
	setDvar("g_allow_teamchange", 0);
	setDvar("ui_allow_teamchange", 0);

	setDvar("scr_tdm_numlives", 1);
	setDvar("scr_numLives", 1);
	setDvar("scr_player_numlives", 1);

	setDvar("g_TeamName_Allies", "Prop");
    setDvar("g_TeamName_Axis", "Hunter");
	setDvar("ls_gametype", "PROP HUNT");
	setDvar("ui_gametype", "PROP HUNT");
	setDvar("ui_customModeEditName", "PROP HUNT");
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
