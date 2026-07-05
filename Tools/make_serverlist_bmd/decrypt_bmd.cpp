#include <cstdio>
#include <cstring>
#include <windows.h>

int main(int argc, char* argv[]) {
    const char* path = argc > 1 ? argv[1] : "serverlist.bmd";
    FILE* f = fopen(path, "rb");
    if (!f) { printf("Cannot open %s\n", path); return 1; }
    fseek(f, 0, SEEK_END);
    int sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    BYTE* buf = new BYTE[sz];
    fread(buf, 1, sz, f);
    fclose(f);

    printf("File: %s (%d bytes)\n", path, sz);
    printf("Header: %02X %02X %02X %02X\n", buf[0], buf[1], buf[2], buf[3]);

    // Decrypt
    BYTE key[3] = {0xAB, 0xFC, 0xCF};
    for (int i = 4; i < sz; i++) buf[i] ^= key[(i-4)%3];

    // Print hex + ASCII
    for (int i = 0; i < sz; i += 16) {
        char ascii[17]; ascii[16] = 0;
        printf("%04X: ", i);
        for (int j = 0; j < 16; j++) {
            if (i + j < sz) {
                printf("%02X ", buf[i+j]);
                ascii[j] = (buf[i+j] >= 32 && buf[i+j] < 127) ? buf[i+j] : '.';
            } else { printf("   "); ascii[j] = ' '; }
        }
        printf(" %s\n", ascii);
    }
    delete[] buf;
    return 0;
}
