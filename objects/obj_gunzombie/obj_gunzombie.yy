{
  "resourceType": "GMObject",
  "resourceVersion": "1.0",
  "name": "obj_gunzombie",
  "eventList": [
    {"resourceType":"GMEvent","resourceVersion":"1.0","name":"","collisionObjectId":null,"eventNum":0,"eventType":3,"isDnD":false,},
    {"resourceType":"GMEvent","resourceVersion":"1.0","name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnD":false,},
    {"resourceType":"GMEvent","resourceVersion":"1.0","name":"","collisionObjectId":null,"eventNum":2,"eventType":3,"isDnD":false,},
  ],
  "managed": true,
  "overriddenProperties": [
    {"resourceType":"GMOverriddenProperty","resourceVersion":"1.0","name":"","objectId":{"name":"obj_living","path":"objects/obj_living/obj_living.yy",},"propertyId":{"name":"health","path":"objects/obj_living/obj_living.yy",},"value":"5",},
  ],
  "parent": {
    "name": "Enemy",
    "path": "folders/Objects/Enemy.yy",
  },
  "parentObjectId": {
    "name": "obj_living",
    "path": "objects/obj_living/obj_living.yy",
  },
  "persistent": false,
  "physicsAngularDamping": 0.1,
  "physicsDensity": 0.5,
  "physicsFriction": 0.2,
  "physicsGroup": 1,
  "physicsKinematic": false,
  "physicsLinearDamping": 0.1,
  "physicsObject": false,
  "physicsRestitution": 0.1,
  "physicsSensor": false,
  "physicsShape": 1,
  "physicsShapePoints": [],
  "physicsStartAwake": true,
  "properties": [
    {"resourceType":"GMObjectProperty","resourceVersion":"1.0","name":"damage","filters":[],"listItems":[],"multiselect":false,"rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"value":"1","varType":0,},
    {"resourceType":"GMObjectProperty","resourceVersion":"1.0","name":"damageCooldown","filters":[],"listItems":[],"multiselect":false,"rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"value":"60","varType":0,},
  ],
  "solid": false,
  "spriteId": {
    "name": "spr_gun_zombie",
    "path": "sprites/spr_gun_zombie/spr_gun_zombie.yy",
  },
  "spriteMaskId": null,
  "visible": true,
}