module infinity.resources.ITM;

import std.stdio;

private enum int ITM_HEADER_SIZE = 114;
private enum int ITM_ABILITY_SIZE = 56;
private enum int ITM_EFFECT_SIZE = 48;

private union ITMHeader
{
    ubyte[ITM_HEADER_SIZE] buffer;
    align(1) struct
    {
        char[4] sig;
        char[4] ver;
        char[4] unidentifiedNameRef;
        char[4] identifiedNameRef;
        char[8] replacement;
        uint properties;
        ushort type;
        uint usability;
        ubyte[2] animation;
        ushort minLevel;
        ushort minStrength;
        ubyte minStrengthBonus;
        ubyte kitExclusions1;
        ubyte minIntelligence;
        ubyte kitExclusions2;
        ubyte minDexterity;
        ubyte kitExclusions3;
        ubyte minWisdon;
        ubyte kitExclusions4;
        ubyte minConstitution;
        ubyte weaponProficiency;
        ushort minCharisma;
        uint price;
        ushort stackAmount;
        char[8] inventoryIcon;
        ushort loreToId;
        char[8] groundIcon;
        uint weight;
        uint unidentifiedDescRef;
        uint identifiedDescRef;
        char[8] descriptionIcon;
        uint enchantment;
        uint abilitiesOffset;
        ushort abilitiesCount;
        uint effectsOffset;
        ushort effectsIndex;
        ushort effectsCount;
    }
}

private union ITMAbility
{
	ubyte[ITM_ABILITY_SIZE] buffer;
	align(1) struct
    {
		ubyte attackType;
		ubyte idRequired;
		ubyte useLocation;
		ubyte altDiceSize;
		char[8] useIcon;
		ubyte targetType;
		ubyte targetCount;
		ushort range;
		ubyte projectileType;
		ubyte altDiceCount;
		ubyte attackSpeed;
		ubyte altDamageBonus;
		ushort toHitBonus;
		ubyte diceSize;
		ubyte primaryType;
		ubyte diceCount;
		ubyte secondaryType;
		ushort damageBonus;
		ushort damageType;
		ushort effectsCount;
		ushort effectsIndex;
		ushort charges;
		ushort consumptionBehavior;
		uint properties;
		ushort projectileAnimation;
		ushort overhandRate;
		ushort backhandRate;
		ushort thrustRate;
		ushort isArrow;
		ushort isBolt;
		ushort isBullet;
	}
}

private union ITMEffect {
	ubyte[ITM_EFFECT_SIZE] buffer;
	align(1) struct
    {
		ushort type;
		ubyte targetType;
		ubyte power;
		uint param1;
		uint param2;
		ubyte timingMode;
		ubyte resistance;
		uint duration;
		ubyte probability1;
		ubyte probability2;
		char[8] resource;
		uint diceCount;
		uint diceSize;
		uint savingType;
		uint savingBonus;
		uint special;
	}
}

class ITM
{
    ITMHeader header;
    ITMAbility[] abilities;
    ITMEffect[] effects;

    this(ref File stream)
    {
        stream.rawRead(this.header.buffer);

        this.abilities.length = this.header.abilitiesCount;
        foreach (ref ability; this.abilities)
            stream.rawRead(ability.buffer);

        this.effects.length = this.header.effectsCount;
        foreach (ref effect; this.effects)
            stream.rawRead(effect.buffer);

        // TODO: ability effects
    }
}
