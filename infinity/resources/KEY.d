module infinity.resources.KEY;

import std.stdio;

private enum int KEY_HEADER_SIZE = 24;
private enum int KEY_ARCHIVE_SIZE = 12;
private enum int KEY_RESOURCE_SIZE = 14;

private union KEYHeader
{
    ubyte[KEY_HEADER_SIZE] buffer;
    align(1) struct
    {
        char[4] sig;
        char[4] ver;
        uint archivesCount;
        uint resourcesCount;
        uint archivesOffset;
        uint resourcesOffset;
    }
}

private union KEYArchive
{
    ubyte[KEY_ARCHIVE_SIZE] buffer;
    align(1) struct
    {
        uint fileLength;
        uint directoryOffset;
        ushort directoryLength;
        ushort location;
    }
}

private union KEYResource
{
    ubyte[KEY_RESOURCE_SIZE] buffer;
    align(1) struct
    {
        char[8] name;
        ushort type;
        uint location;
    }
}

class KEY
{
    KEYHeader header;
    KEYArchive[] archives;
    KEYResource[] resources;
    uint directoriesOffset;
    string directories;

    this(ref File stream)
    {
        stream.rawRead(this.header.buffer);

        assert(stream.tell == this.header.archivesOffset);
        this.archives.length = this.header.archivesCount;
        foreach (ref archive; this.archives)
            stream.rawRead(archive.buffer);

        this.directoriesOffset = cast(uint) stream.tell;
        uint len = (this.header.resourcesOffset - this.directoriesOffset);
        this.directories = cast(string) stream.rawRead(new ubyte[len]);

        assert(stream.tell == this.header.resourcesOffset);
        this.resources.length = this.header.resourcesCount;
        foreach (ref resource; this.resources)
            stream.rawRead(resource.buffer);
    }

    string getDirectory(uint n)
    {
        KEYArchive* archive = &this.archives[n];
        uint start = archive.directoryOffset - this.directoriesOffset;
        return this.directories[start .. start + archive.directoryLength];
    }
}
