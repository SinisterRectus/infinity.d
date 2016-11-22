module infinity.resources.SPL;

import std.stdio;

private enum int SPL_HEADER_SIZE = 114;
private enum int SPL_ABILITY_SIZE = 40;
private enum int SPL_EFFECT_SIZE = 48;

private union SPLHeader
{
    ubyte[SPL_HEADER_SIZE] buffer;
    align(1) struct
    {
        char[4] sig;
		char[4] ver;
		char[4] unidentifiedNameRef;
		char[4] identifiedNameRef;
		char[8] completionSound;
		uint properties;
		ushort type;
		uint usability;
		ubyte[2] animation;
		ubyte minLevel;
		ubyte primaryType;
		ubyte minStrength;
		ubyte secondaryType;
		ubyte minStrengthBonus;
		ubyte kitExclusions1;
		ubyte minIntelligence;
		ubyte kitExclusions2;
		ubyte minDexterity;
		ubyte kitExclusions3;
		ubyte minWisdon;
		ubyte kitExclusions4;
		ushort minConstitution;
		ushort minCharisma;
		uint level;
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

private union SPLAbility
{
	ubyte[SPL_ABILITY_SIZE] buffer;
	align(1) struct
    {
        byte attackType;
        byte friendlyAbility;
        ushort useLocation;
        char[8] useIcon;
        byte targetType;
        byte targetCount;
        ushort range;
        ushort level;
        ushort castingTime;
        ushort timesPerDay;
        ushort diceSize;
        ushort diceCount;
        ushort enchanted;
        ushort damageType;
        ushort effectsCount;
        ushort effectsIndex;
        ushort charges;
        ushort consumptionBehavior;
        ushort projectile;
    }
}

private union SPLEffect {
	ubyte[SPL_EFFECT_SIZE] buffer;
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

class SPL
{
    SPLHeader header;
    SPLAbility[] abilities;
    SPLEffect[] effects;

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
