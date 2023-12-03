package day3

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	"ahse.no/aoc/utils"
)

func Solve() {
	println("Solving Day 3")
	lines := utils.ReadAllLines("./challenges/day3/input.txt")

	part_1 := 0
	part_2 := 0

	
	gears := make(map[string][]int)

	for y, line := range lines  {
		lineChars := strings.Split(line, "")
		for x := 0; x < len(lineChars); x++ {
			char := lineChars[x]
			if !isInt(char) { continue }

			offset := 0;

			for x + offset < len(lineChars) && isInt(lineChars[x + offset]) {
				offset++;
			}

			num,err := strconv.Atoi(line[x:x+offset])

			if err != nil {
				log.Fatal("failed to convert the number\n", err,"\n", line[x:x+offset], x, offset, y);
			}


			hasAdjacentSymbol := false

			for cy := y - 1; cy < y + 2; cy++ {
				if cy < 0 || cy >= len(lines) { continue }
				lineCharsCheck := strings.Split(lines[cy], "");
				for cx := x - 1; cx < x + offset + 1; cx++ {
					if cx < 0 || cx >= len(lineCharsCheck) { continue }
					hasAdjacentSymbol = hasAdjacentSymbol || (!isInt(lineCharsCheck[cx]) && lineCharsCheck[cx] != ".")
					
					if lineCharsCheck[cx] == "*" {
						key := fmt.Sprint(cx,",",cy)
						if gears[key] == nil {
							gears[key] = []int {}
						}
						gears[key] = append(gears[key], num)
					}
				}
			}
			
			if hasAdjacentSymbol {
				part_1 += num
			}

			x += offset
		}
	}

	for _, gearRatio := range gears {
		if len(gearRatio) == 2 {
			part_2 += gearRatio[0] * gearRatio[1]
		}
	}	

	println(lines)
	println("Part 1:", part_1)
	println("Part 2:", part_2)
	println()
}

func isInt(v string) bool {
	if _, err := strconv.Atoi(v); err == nil {
		return true
	}
	return false
}