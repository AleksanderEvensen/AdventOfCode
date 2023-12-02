package day2

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	"ahse.no/aoc/utils"
)

func Solve() {
	lines := utils.ReadAllLines("./challenges/day2/input.txt");


	gameIdSum := 0
	cubeSum := 0

	for _, line := range lines {
		gameId, err := strconv.Atoi(strings.Split(strings.Split(line, "Game ")[1], ": ")[0])
		if err != nil {
			log.Fatal("Failed to parse gameId: \n", err);
		}
		data,_ := strings.CutPrefix(line, fmt.Sprint("Game ", gameId, ": "));
		draws := strings.Split(data, "; ");

		maxRed := 0
		maxGreen := 0
		maxBlue := 0

		for _, draw := range draws {
			for _, dice := range strings.Split(draw, ", ") {
				dice_data := strings.Split(dice, " ")
				num, err := strconv.Atoi(dice_data[0]);
				if err != nil {
					log.Fatal("Failed to convert dice count \n",err);
				}
				color := dice_data[1]

				switch color {
					case "red": 
						if maxRed < num { maxRed = num }
						break 
					case "green": 
						if maxGreen < num { maxGreen = num }
						break 
					case "blue": 
						if maxBlue < num { maxBlue = num }
						break 
				}
			}
		}

		if maxRed <= 12 && maxGreen <= 13 && maxBlue <= 14 {
			gameIdSum += gameId
		}

		cubeSum += maxRed * maxGreen * maxBlue

	}


	println("Part 1:", gameIdSum)
	println("Part 2:", cubeSum)

}