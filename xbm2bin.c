#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include </dev/stdin>

int main(int argc, char **argv) {
    FILE *fp = fopen("fb.rom", "w");
    for(int i = 0; i < _width * (_height / 8); i++) {
        fputc(_bits[i], fp);
    }
    fclose(fp);
    return 0;
}
