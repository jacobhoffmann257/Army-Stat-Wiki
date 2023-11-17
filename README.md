# Rails Template
Warhammer Unit search platform:

Let anyone view the rules for individual units, along with there stats and weapons profiles. Allow the user to navigate based on the faction and the role of the unit.

Pain Point:

It is often hard to search for the information for a needed unit

User Stories:

I want to be able to search for all units in a faction.

I want to be able to find all units of a specific type for a particular faction.

I want to be able to see all applicable rules for the unit in question.

I want to be able to see all weapons and weapons profiles for a particular unit.

I want to be able to see all abilities for a particular unit.

Domain Model:

faction:

name

banner

icon

picture

 

units:

name

base

cost

role

faction_id

keywords

picture

 

Models:

movement

toughness

save_value

inverable_save

wounds

leadership

objective_control

unit_id

 

Equipment:

model_id

weapon_id

 

Weapons:

name

range

 

Profiles:

weapon_id

attacks

skill

strength

armor_piercing

damage

 

Unit_abilites:

ability_id

unit_id

 

Abilities:

name

description

aura

type
