module infinity.resources.EFF;

import std.stdio;

private enum int EFF_HEADER_SIZE = 272;

private union EFFHeader
{
    ubyte[EFF_HEADER_SIZE] buffer;
    align(1) struct
    {
        ubyte[4] sig;
        ubyte[4] ver;
        ubyte[4] sig2;
        ubyte[4] ver2;
        uint type;
        uint targetType;
        uint power;
        uint param1;
        uint param2;
        uint timingMode;
        uint duration;
        ushort probability1;
        ushort probability2;
        char[8] resource;
        uint diceCount;
        uint diceSize;
        uint savingType;
        uint savingBonus;
    }
}

class EFF
{
    EFFHeader header;

    this(ref File stream)
    {
        stream.rawRead(this.header.buffer);
    }
}
