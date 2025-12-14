#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define BUFFER_LENGTH 2048

typedef struct {
    int from;
    int to;
} Range;


struct RangeListEntry {
    Range range;
    struct RangeListEntry* next;
};

typedef struct {
    struct RangeListEntry* root;
    struct RangeListEntry* tail;
} RangeList;


char* slice(char* str, int start, int end) {
    int length = end - start;
    char* result = (char*) calloc(length + 1, sizeof(char));
    
    strncpy(result, str + start, length);

    return result;
}

RangeList parseFile(char* data, int len) {
    RangeList list = {
        .root = NULL,
        .tail = NULL,
    };


    
    int pointer1 = 0;
    int pointer2 = 0;



    for (int cursor = 0; cursor < len; cursor++) {
        if (data[cursor] == ',' || data[cursor] == '\n') {
           
            char* fromStr = slice(data, pointer1, pointer2 - 1);
            char* toStr = slice(data, pointer2, cursor);

            printf("Creating from '%s' to '%s'\n", fromStr, toStr);

            int from = atoi(fromStr);
            int to = atoi(toStr);

            Range range = {
                .from = from,
                .to = to,
            };

            struct RangeListEntry* entry = (struct RangeListEntry*) malloc(sizeof(struct RangeListEntry));

            entry->range = range;

            if (list.root == NULL) {
                list.root = entry;
                list.tail = entry;
            } else {
                list.tail->next = entry;
                list.tail = entry;
            }

            free(fromStr);
            free(toStr);
            pointer1 = cursor + 1;
            pointer2 = cursor + 1;
            continue;
        }

        if (data[cursor] == '-') {
            pointer2 = cursor + 1;
            continue;
        }
    }

    return list;
}



int digitCount(int num) {
    return ((int)floor(log10(num))) + 1;
}
int hasEvenDigits(int num) {
    return digitCount(num) % 2 == 0;

}

int hasRepeatingPattern(int num) {
    int count = digitCount(num);

    int halfDigits = count / 2;
    int power = (int)pow(10, halfDigits);
    int firstHalf = num / power;
    int lastHalf = num % power;


    return firstHalf == lastHalf;
}


int main(int argc, char** argv) {
    
    if (argc < 2) {
        printf("No input file parameter");
        return 1;
    }

    char* filename = argv[1];


    FILE *fd;
    char buffer[BUFFER_LENGTH];

    fd = fopen(filename, "r");
    if (fd == NULL) {
        perror("Error opening file");
        printf("Failed to read file '%s'\n", filename);
        return 1;
    }

    char* line = fgets(buffer, BUFFER_LENGTH, fd);
    int length = strlen(line);

    RangeList list = parseFile(line, length);


    struct RangeListEntry* current = list.root;

    long part1 = 0;

    while(current != NULL) {
        // printf("Range from '%d' to '%d'\n", current->range.from, current->range.to);
        
        for (int i = current->range.from; i <= current->range.to; i++) {
            if (!hasEvenDigits(i)) continue;
            if (!hasRepeatingPattern(i)) continue;
            // printf("Possible repeating '%d'\n", i);
            
            part1 += (long)i;

        }

        current = current->next;
    }

    printf("Part 1: %ld\n", part1);
}

