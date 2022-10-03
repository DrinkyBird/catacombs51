self.path = path_add();
self.seenPlayer = false;
self.lastFireTime = 0;
self.health *= max(1, global.level / 4);
self.weapon = Weapons.pistol;