#include <cstdio>
#include <cstring>
#include <windows.h>

const BYTE g_XorKey[3] = {0xAB, 0xFC, 0xCF};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: patch_bmd.exe <input.bmd> [output.bmd]\n");
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

    // Decrypt
    for (int i = 4; i < sz; i++) buf[i] ^= g_XorKey[(i - 4) % 3];

    // Find all entry headers (21 1D 07 38 5E 6E) and replace codes
    // Original codes: 1, 24, 36, 40, 47
    // New codes:      19, 40, 41, 40, 47  (keep entry 4/5 as-is)
    WORD newCodes[] = {19, 40, 41, 40, 47};
    int codeIdx = 0;
    BYTE entryMagic[] = {0x21, 0x1D, 0x07, 0x38, 0x5E, 0x6E};

    for (int i = 0; i < sz - 8; i++) {
        if (memcmp(&buf[i], entryMagic, 6) == 0) {
            // Found entry header - code is at offset +6 (2 bytes LE)
            if (codeIdx < 5) {
                buf[i + 6] = newCodes[codeIdx] & 0xFF;
                buf[i + 7] = (newCodes[codeIdx] >> 8) & 0xFF;
                printf("Entry %d: code %d -> %d\n", codeIdx + 1, 
                    (buf[i+7] << 8) | buf[i+6], newCodes[codeIdx]);
                codeIdx++;
            }
        }
    }

    // Re-encrypt
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
