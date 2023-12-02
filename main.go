package main

import (
	"os"
	"strconv"

	"ahse.no/aoc/challenges/day1"
	"ahse.no/aoc/challenges/day2"
	"ahse.no/aoc/challenges/day3"
)

func main() {

	dayToRun, err := strconv.Atoi(os.Args[len(os.Args)-1])

	if err != nil { dayToRun = -1 }

	if dayToRun == -1 || dayToRun == 1 { day1.Solve() }
	if dayToRun == -1 || dayToRun == 2 { day2.Solve() }
	if dayToRun == -1 || dayToRun == 3 { day3.Solve() }
	// if dayToRun == -1 || dayToRun == 4 { day4.Solve() }
	// if dayToRun == -1 || dayToRun == 5 { day5.Solve() }
	// if dayToRun == -1 || dayToRun == 6 { day6.Solve() }

}

