package day4

import (
	"math"
	"slices"
	"strconv"
	"strings"

	"ahse.no/aoc/utils"
)

func Solve() {
	println("Solving Day 4")
	lines := utils.ReadAllLines("./challenges/day4/input.txt")

	part_1 := 0
	part_2 := 0

	copies := make(map[int]int)

	for i, line := range lines {
		cardData := strings.Split(strings.Split(line, ": ")[1], "|")
		card := i + 1
		winningNumbers := getNumbers(strings.Split(cardData[0], " "))
		playingNumbers := getNumbers(strings.Split(cardData[1], " "))

		pow := 0

		for _, num := range winningNumbers {
			if slices.Contains(playingNumbers, num) {
				pow++
			}

		}

		for j := card + 1; j < card+pow+1; j++ {
			if _, exist := copies[j]; !exist {
				copies[j] = 0
			}
			copies[j] += copies[card] + 1
		}

		if pow > 0 {
			part_1 += int(math.Pow(2, float64(pow-1)))
		}
		println("Card", card, "has", copies[card], "copies")
		part_2 += copies[card] + 1

	}

	println(lines)
	println("Part 1:", part_1)
	println("Part 2:", part_2)
	println()

}

func getNumbers(strarr []string) []int {
	var arr []int
	for _, str := range strarr {
		if v, err := strconv.Atoi(str); err == nil {
			arr = append(arr, v)
		}
	}
	return arr
}
