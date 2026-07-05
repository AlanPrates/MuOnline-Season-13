#include <cstdio>
#include <cstring>
#include <windows.h>

const BYTE g_XorKey[3] = {0xAB, 0xFC, 0xCF};
const BYTE g_Header[4] = {0xFC, 0xCF, 0xF3, 0xD1};
// Entry magic: 6 bytes at start of each entry
const BYTE g_EntryMagic[6] = {0x21, 0x1D, 0x07, 0x38, 0x5E, 0x6E};

struct ServerDef {
    WORD code;          // Server code (used in header AND before URL)
    const char* name;   // Display name (null-terminated)
    const BYTE* prePad; // Preamble bytes BEFORE this entry (not including header)
    int prePadLen;      // Length of preamble
    int padLen;         // Min padding after name (original = 19)
    int extraBeforeUrl; // Extra bytes between server code and 0x0011 flag
};

int main() {
    // Preamble data from original file (before first entry)
    BYTE globalPrePad[] = {
        0x30,0x32,0x52,0x09,0x57,0x33,0x64,0x57,0x33,0x64,0x57,0x33,
        0x64,0x57,0x33,0x64,0x57,0x33,0x64,0x57,0x33,0x64,0x57,0x33,
        0x64,0x57,0x33,0x64,0x57,0x33,0x64,0x55,0x33,0x75,0x57,0x44,
        0x13,0x20,0x1D,0x1C,0x23,0x56,0x05,0x3A,0x57,0x01
    };

    // Inter-entry preamble for entries 2+ (from original pattern)
    BYTE interPrePadTemplate2[] = {
        0x4D,0x33,0x3C,0x7A,0x67,0x01,0x36,0x5E,0x64,
        0x57,0x33,0x64,0x57,0x33,0x64,0x57,0x33,0x64,0x57,0x33,0x64,
        0x57,0x33,0x64,0x57,0x33,0x64,0x57,0x33,0x64,0x57,0x33,0x64,
        0x57,0x32,0x76,0x54,0x22,0x64,0x20,0x44,0x13,0x79,0x4B,0x10,
        0x32,0x52,0x09,0x33,0x56,0x12,0x79,0x50,0x0B,0x3A,0x39,0x10,
        0x64,0x0F,0x1E,0x30,0x32,0x52,0x09
    };

    const char* url = "www.muserver.com\n";

    // First entry has NO preamble (starts right after global prePad)
    ServerDef servers[] = {
        {19, "Servidor-CS",     nullptr, 0, 19, 0},
        {40, "Servidor-Free", interPrePadTemplate2, sizeof(interPrePadTemplate2), 19, 0},
        {41, "Servidor-Vip",  interPrePadTemplate2, sizeof(interPrePadTemplate2), 19, 0},
    };
    int count = sizeof(servers) / sizeof(servers[0]);

    // Calculate total size: header + global preamble + entries + final padding
    int totalSize = 4 + sizeof(globalPrePad); // header + global preamble
    for (int i = 0; i < count; i++) {
        int nameLen = strlen(servers[i].name) + 1; // include null
        int urlLen = strlen(url);
        // entry = prePad + header(8) + name + pad + code(2) + extraBeforeUrl + flag(2) + url
        totalSize += servers[i].prePadLen;   // preamble before this entry
        totalSize += 8;                       // entry header
        totalSize += nameLen;                 // name
        totalSize += servers[i].padLen;       // padding after name
        totalSize += 2;                       // server code before url
        totalSize += servers[i].extraBeforeUrl;
        totalSize += 2;                       // flag 0x0011
        totalSize += urlLen;                  // url
    }

    BYTE* buf = new BYTE[totalSize];
    memset(buf, 0, totalSize);

    int offset = 0;
    // Header
    memcpy(&buf[offset], g_Header, 4);
    offset += 4;

    // Global preamble
    memcpy(&buf[offset], globalPrePad, sizeof(globalPrePad));
    offset += sizeof(globalPrePad);

    // Entries
    for (int i = 0; i < count; i++) {
        // Entry preamble (nullptr for first entry - starts right after global prePad)
        if (servers[i].prePad != nullptr) {
            memcpy(&buf[offset], servers[i].prePad, servers[i].prePadLen);
            offset += servers[i].prePadLen;
        }

        // Entry header: 6 magic bytes + 2 server code
        memcpy(&buf[offset], g_EntryMagic, 6);
        offset += 6;
        *(WORD*)&buf[offset] = servers[i].code;
        offset += 2;

        // Entry name (null-terminated)
        int nameLen = strlen(servers[i].name) + 1;
        memcpy(&buf[offset], servers[i].name, nameLen);
        offset += nameLen;

        // Padding after name
        offset += servers[i].padLen;

        // Server code before URL
        *(WORD*)&buf[offset] = servers[i].code;
        offset += 2;

        // Extra byte(s) before flag
        offset += servers[i].extraBeforeUrl;

        // Flag 0x0011
        *(WORD*)&buf[offset] = 0x0011;
        offset += 2;

        // URL
        int urlLen = strlen(url);
        memcpy(&buf[offset], url, urlLen);
        offset += urlLen;
    }

    // Encrypt (XOR from offset 4 to end)
    for (int i = 4; i < totalSize; i++) {
        buf[i] ^= g_XorKey[(i - 4) % 3];
    }

    // Write
    FILE* f = fopen("serverlist.bmd", "wb");
    if (f) {
        fwrite(buf, 1, totalSize, f);
        fclose(f);
        printf("Created serverlist.bmd (%d bytes, %d servers)\n", totalSize, count);
        for (int i = 0; i < count; i++) {
            printf("  Code %d: \"%s\"\n", servers[i].code, servers[i].name);
        }
    } else {
        printf("ERROR: Failed to write serverlist.bmd\n");
        delete[] buf;
        return 1;
    }

    delete[] buf;
    return 0;
}
