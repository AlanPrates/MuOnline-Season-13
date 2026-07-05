#include <cstdio>
#include <cstring>
#include <windows.h>

const BYTE g_XorKey[3] = {0xAB, 0xFC, 0xCF};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: patch_names.exe <input.bmd> [output.bmd]\n");
        return 1;
    }
    const char* inPath = argv[1];
    const char* outPath = argc > 2 ? argv[2] : inPath;

    FILE* f = fopen(inPath, "rb");
    if (!f) { printf("Cannot open %s\n", inPath); return 1; }
    fseek(f, 0, SEEK_END);
    int sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    BYTE* buf = new BYTE[sz];
    fread(buf, 1, sz, f);
    fclose(f);

    for (int i = 4; i < sz; i++) buf[i] ^= g_XorKey[(i - 4) % 3];

    BYTE entryMagic[] = {0x21, 0x1D, 0x07, 0x38, 0x5E, 0x6E};
    int entryOffsets[10] = {};
    int entryCount = 0;

    for (int i = 0; i < sz - 8 && entryCount < 10; i++) {
        if (memcmp(&buf[i], entryMagic, 6) == 0) {
            entryOffsets[entryCount++] = i;
            printf("Entry %d at 0x%04X: code=%d name=\"%s\"\n",
                entryCount, i,
                buf[i+8] | (buf[i+9] << 8),
                &buf[i+10]);
        }
    }
    printf("Found %d entries\n", entryCount);

    const char* newNames[] = {"CS", "Servidor-Free", "Servidor-Vip", "Servidor-Free", "Servidor-Vip"};

    for (int i = 0; i < entryCount && i < 5; i++) {
        int off = entryOffsets[i];
        int nameFieldStart = off + 8;
        int nameFieldSize = 33;

        memset(&buf[nameFieldStart], 0, nameFieldSize);

        const char* name = newNames[i];
        int len = (int)strlen(name);
        if (len > nameFieldSize - 1) len = nameFieldSize - 1;
        memcpy(&buf[nameFieldStart], name, len);
        printf("Entry %d: name -> \"%s\" (%d bytes)\n", i + 1, name, len);
    }

    for (int i = 4; i < sz; i++) buf[i] ^= g_XorKey[(i - 4) % 3];

    f = fopen(outPath, "wb");
    if (f) {
        fwrite(buf, 1, sz, f);
        fclose(f);
        printf("Saved %s (%d bytes)\n", outPath, sz);
    } else {
        printf("ERROR: Cannot write %s\n", outPath);
    }

    delete[] buf;
    return 0;
}
