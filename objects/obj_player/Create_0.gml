self.vx = 0;
self.vy = 0;
self.lastFireTime = [];
self.lastDamageTime = -1;
self.lastHealth = self.health;
self.flashColour = c_black;
self.flashEnd = 0;
self.flashAlphaDivide = 1;
self.deathTime = -1;
self.lastMaxHpPowerup = 0;
self.maxHealth = 3 + global.powerups[Powerups.maxhp];
self.health = self.maxHealth;

for (var i = 0; i < Weapons.count; i++) {
	array_push(self.lastFireTime, 0);
}

self.alarm[4] = 5;