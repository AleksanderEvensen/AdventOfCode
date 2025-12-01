#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_LENGTH 256

#define LEFT_DIR 0
#define RIGHT_DIR 1
#define INVALID_DIR 2

int processLine(char* line, int* amount) {
    int direction = INVALID_DIR;
    if (line[0] == 'L') {
        direction = LEFT_DIR;
    } else if (line[0] == 'R') {
        direction = RIGHT_DIR;
    }

    char* numString = line+1;
    *amount = atoi(numString);

    return direction;
}

int main(int argc, char** argv) {
    if (argc < 2) {
        printf("Missing file name at position 1\n");
    }

    char* filename = argv[1];
    printf("Reading file name '%s'\n", filename);


    FILE *fd;
    char buffer[BUFFER_LENGTH];

    fd = fopen(filename, "r");
    if (fd == NULL) {
        perror("Error opening file");
        printf("Failed to read file '%s'\n", filename);
        return 1;
    }


    int currentRotation = 50;
    int part1 = 0;
    int part2 = 0;

    while (fgets(buffer, BUFFER_LENGTH, fd) != NULL) {
        char* line = buffer;
        int amount = 0;
        int direction = processLine(line, &amount);
        int lastRotation = currentRotation;


        if (direction == LEFT_DIR) {
            currentRotation -= amount;
        } else if (direction == RIGHT_DIR) {
            currentRotation += amount;
        }

        currentRotation = currentRotation % 100;
        if (currentRotation < 0) {
            currentRotation = 100 + currentRotation;
        }

        if (currentRotation == 0) {
            part1 += 1;
        }

        int rot = lastRotation;
        int fullRotations = 0;
        for (int i = 0; i < amount; i++) {
            if (direction == LEFT_DIR) {
                rot -= 1;
            } else if (direction == RIGHT_DIR) {
                rot += 1;
            }
            if (rot >= 100) {
                rot = rot - 100;
            }
            if (rot < 0) {
                rot = 100 + rot;
            }

            if (rot == 0) {
                fullRotations++;
            }
        }

        part2 += fullRotations;

        printf("Last Rotation: %d\n", lastRotation);
        printf("Rotated in dir (%d) By: %d\n", direction, amount);
        printf("Current Rotation: %d\n", currentRotation);
        printf("Full Rotations: %d\n\n", fullRotations);
    }

    printf("Part 1: %d\n", part1);
    printf("Part 2: %d\n", part2);


    return 0;
}
