#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

showPropHuntWelcomeText() {
	self.startPropHuntText = createText("default", 1.5, "CENTER", "CENTER", 0, -50, 2, false, "");
	self.startPropHuntText setText("Press [{+speed_throw}] + [{+actionslot 2}] to start Prop Hunt!");
	self.startPropHuntText setColor(1, 1, 1, 1);

	self.exitPropHuntText = createText("default", 1.5, "CENTER", "CENTER", 0, -35, 2, false, "");
	self.exitPropHuntText setText("Press [{+melee}] to play normally.");
	self.exitPropHuntText setColor(1, 1, 1, 1);
}

destroyPropHuntWelcomeText() {
    self.startPropHuntText destroy();
    self.exitPropHuntText destroy();
}

propControlsText() {
	self.changeModelText = createText("default", 1, "LEFT", "CENTER", -425, -110, 2, false, "");
	self.changeModelText setText("Press [{+actionslot 3}] or [{+actionslot 4}] to change your model.");
	self.changeModelText setColor(1, 1, 1, 1);

	self.rotateModelText = createText("default", 1, "LEFT", "CENTER", -425, -90, 2, false, "");
	self.rotateModelText setText("Press [{+speed_throw}] or [{+attack}] to rotate your model.");
	self.rotateModelText setColor(1, 1, 1, 1);

	self.changeFOVText = createText("default", 1, "LEFT", "CENTER", -425, -70, 2, false, "");
	self.changeFOVText setText("Press [{+frag}] or [{+smoke}] to adjust your FOV.");
	self.changeFOVText setColor(1, 1, 1, 1);

	self.currentModelText = createText("default", 1, "LEFT", "CENTER", -425, -50, 2, false, "");
	self.currentModelText setColor(1, 1, 1, 1);
}

createText(font, fontScale, point, relative, xOffset, yOffset, sort, hideWhenInMenu, text) {
    textElem = createFontString(font, fontScale);
    textElem setText(text);
    textElem setPoint(point, relative, xOffset, yOffset);
    textElem.sort = sort;
    textElem.hideWhenInMenu = hideWhenInMenu;
    return textElem;
}

setColor(r, g, b, a) {
	self.color = (r, g, b);
	self.alpha = a;
}

createRectangle(align, relative, x, y, width, height, sort, shader) {
    barElemBG = newClientHudElem(self);
    barElemBG.elemType = "bar";
    barElemBG.width = width;
    barElemBG.height = height;
    barElemBG.align = align;
    barElemBG.relative = relative;
    barElemBG.xOffset = 0;
    barElemBG.yOffset = 0;
    barElemBG.children = [];
    barElemBG.sort = sort;
    barElemBG setParent(level.uiParent);
    barElemBG setShader(shader, width, height);
    barElemBG.hidden = false;
    barElemBG setPoint(align, relative, x, y);
    return barElemBG;
}
