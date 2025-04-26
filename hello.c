#include <stdio.h>

int main() {
    printf("Hello from Docker!\n");
    printf("This message shows that your custom hello-world image works correctly.\n\n");
    printf("To generate this message, Docker took the following steps:\n");
    printf(" 1. The Docker client contacted the Docker daemon.\n");
    printf(" 2. The Docker daemon used the custom image we built from our Dockerfile.\n");
    printf(" 3. The Docker daemon created a new container from that image which runs the\n");
    printf("    executable that produces the output you are currently reading.\n");
    printf(" 4. The Docker daemon streamed that output to the Docker client, which sent it\n");
    printf("    to your terminal.\n\n");
    printf("This is a custom hello-world container built from a minimal Debian image.\n");
    return 0;
}