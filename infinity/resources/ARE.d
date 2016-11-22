module infinity.resources.ARE;

import std.stdio;

private enum int ARE_HEADER_SIZE = 284;

private union AREHeader
{
    ubyte[ARE_HEADER_SIZE] buffer;
    align(1) struct
    {
        char[4] sig;
        char[4] ver;
        char[8] wed;
        uint lastSaved;
        uint flag;
        char[8] northArea;
        uint northFlags;
        char[8] eastArea;
        uint eastFlags;
        char[8] southArea;
        uint southFlags;
        char[8] westArea;
        uint westFlags;
        ushort type;
        ushort rainProbability;
        ushort snowProbability;
        ushort fogProbability;
        ushort lightningProbability;
        ushort windSpeed;
        uint actorsOffset;
        ushort actorsCount;
        ushort regionsCount;
        uint regionsOffset;
        uint spawnsOffset;
        uint spawnsCount;
        uint entrancesOffset;
        uint entrancesCount;
        uint containersOffset;
        ushort containersCount;
        ushort itemsCount;
        uint itemsOffset;
        uint verticesOffset;
        ushort verticesCount;
        ushort ambientsCount;
        uint ambientsOffset;
        uint variablesOffset;
        uint variablesCount;
        ushort tileFlagsOffset;
        ushort tileFlagsCount;
        char[8] script;
        uint exploredSize;
        uint exploredOffset;
        uint doorsCount;
        uint doorsOffset;
        uint animationsCount;
        uint animationsOffset;
        uint tilesCount;
        uint tilesOffset;
        uint songsOffset;
        uint interruptionsOffset;
        uint automapOffset;
        uint automapCount;
        uint trapsOffset;
        uint trapsCount;
    }
}

class ARE
{
    AREHeader header;

    this(ref File stream)
    {
        stream.rawRead(this.header.buffer);
        // TODO: the rest of the owl
    }
}
