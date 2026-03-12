#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

changeMyTeam(assignment) {
	self.pers["team"] = assignment;
	self.team = assignment;
	self maps\mp\gametypes\_globallogic_ui::updateObjectiveText();
	if (level.teamBased) {
		self.sessionteam = assignment;
	} else {
		self.sessionteam = "none";
		self.ffateam = assignment;
	}

	if (!isAlive(self)) {
		self.statusicon = "hud_status_dead";
	}

	self notify("joined_team");
	level notify("joined_team");

	self setClientDvar("g_scriptMainMenu", game["menu_class_" + self.pers["team"]]);
}