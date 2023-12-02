package day1

import (
	"strconv"
	"strings"

	"ahse.no/aoc/utils"
)

func Solve() {
	println("Solving Day 1")
	lines := utils.ReadAllLines("./challenges/day1/input.txt");
	

	partASum := 0
	partBSum := 0

	for _, line := range lines {
		partASum += partANum(line)
		partBSum += partBNum(line)
	}

	println("Part 1:", partASum);
	println("Part 2:", partBSum);
	println()
}

func partANum(line string) int {
	
	strings.Index(line, "1")
	chars := strings.Split(line, "")

	firstNum := -1
	lastNum := 0

	for _, char := range chars {
		num, err := strconv.Atoi(char)
		if err == nil {
			if firstNum == -1 {
				firstNum = num
			}
			lastNum = num
		}
	}

	return firstNum * 10 + lastNum
}

func partBNum(line string) int {
	line_converted := convertWordNumsToNums(line)
	return partANum(line_converted)
}


func convertWordNumsToNums(line string) string {
	wordReplaceMap := map[string]string {
		"one": "o1ne",
		"two": "t2wo",
		"three": "thr3ee",
		"four": "fo4ur",
		"five": "fi5ve",
		"six": "si6x",
		"seven": "se7ven",
		"eight": "ei8ght",
		"nine": "ni9ne",
	}


	for old, new := range wordReplaceMap {
		line = strings.ReplaceAll(line, old, new);
	}

	return line
}