module infinity.resources.TLK;

import std.stdio;

private enum int TLK_HEADER_SIZE = 18;
private enum int TLK_ENTRY_SIZE = 26;

private union TLKHeader
{
    ubyte[TLK_HEADER_SIZE] buffer;
    align(1) struct
    {
        char[4] sig;
        char[4] ver;
        ushort languageId;
        uint entriesCount;
        uint stringsOffset;
    }
}

private union TLKEntry
{
    ubyte[TLK_ENTRY_SIZE] buffer;
    align(1) struct
    {
        ushort info;
        char[8] resourceName;
        uint volume;
        uint pitch;
        uint stringOffset;
        uint stringLength;
    }
}

class TLK
{
    TLKHeader header;
    TLKEntry[] entries;
    string strings;

    this(ref File stream)
    {
        stream.rawRead(this.header.buffer);

        this.entries.length = this.header.entriesCount;
        foreach (ref entry; this.entries)
            stream.rawRead(entry.buffer);

        assert(stream.tell == this.header.stringsOffset);
        uint len = cast(uint) (stream.size - stream.tell);
        this.strings = cast(string) stream.rawRead(new ubyte[len]);
    }

    string getString(uint n)
    {
        TLKEntry* entry = &this.entries[n];
        uint start = entry.stringOffset;
        return this.strings[start .. start + entry.stringLength];
    }
}
