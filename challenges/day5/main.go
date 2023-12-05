package day5

import (
	"fmt"
	"strings"
	"sync"
	"time"

	"ahse.no/aoc/utils"
)

type Mapping struct {
	dest int
	src  int
	len  int
}

var (
	seedSoilMap   []Mapping
	soilFertMap   []Mapping
	fertWaterMap  []Mapping
	waterLightMap []Mapping
	lightTempMap  []Mapping
	tempHumidMap  []Mapping
	humidLocMap   []Mapping
)

func Solve() {
	println("Solving Day 5")
	// lines := utils.ReadAllLines("./challenges/day5/input.test.txt")
	lines := utils.ReadAllLines("./challenges/day5/input.txt")

	parsingStage := 0
	seeds := []int{}

	seedSoilMap = []Mapping{}
	soilFertMap = []Mapping{}
	fertWaterMap = []Mapping{}
	waterLightMap = []Mapping{}
	lightTempMap = []Mapping{}
	tempHumidMap = []Mapping{}
	humidLocMap = []Mapping{}

	for _, line := range lines {
		if seedStr, found := strings.CutPrefix(line, "seeds: "); found {
			seeds = utils.GetNumbers(strings.Split(seedStr, " "))
			continue
		}
		if strings.Contains(line, ":") {
			parsingStage++
			continue
		}

		numbers := utils.GetNumbers(strings.Split(line, " "))

		if len(numbers) != 3 {
			continue
		}

		dest := numbers[0]
		src := numbers[1]
		len := numbers[2]

		switch parsingStage {
		case 1: // seed-to-soil
			seedSoilMap = append(seedSoilMap, Mapping{dest, src, len})
			break
		case 2: // soil-to-fertilizer
			soilFertMap = append(soilFertMap, Mapping{dest, src, len})
			break
		case 3: // fertilizer-to-water
			fertWaterMap = append(fertWaterMap, Mapping{dest, src, len})
			break
		case 4: // water-to-light
			waterLightMap = append(waterLightMap, Mapping{dest, src, len})
			break
		case 5: // light-to-temp
			lightTempMap = append(lightTempMap, Mapping{dest, src, len})
			break
		case 6: // temp-to-humid
			tempHumidMap = append(tempHumidMap, Mapping{dest, src, len})
			break
		case 7: // humid-to-location
			humidLocMap = append(humidLocMap, Mapping{dest, src, len})
			break
		}
	}

	part_1 := 0
	part_2 := 0

	for _, seed := range seeds {

		soil := convertMapValue(seedSoilMap, seed)
		fert := convertMapValue(soilFertMap, soil)
		water := convertMapValue(fertWaterMap, fert)
		light := convertMapValue(waterLightMap, water)
		temp := convertMapValue(lightTempMap, light)
		humid := convertMapValue(tempHumidMap, temp)
		loc := convertMapValue(humidLocMap, humid)

		if loc < part_1 || part_1 == 0 {
			part_1 = loc
		}

	}

	startTime := time.Now()
	// brute force for the win
	lowestSeeds := [10]int{}
	var wg sync.WaitGroup
	wg.Add(len(seeds) / 2)

	for i := 0; i < len(seeds); i += 2 {
		start := seeds[i]
		length := seeds[i+1]

		go func(index int) {
			result := 0
			for seed := start; seed < start+length; seed++ {
				soil := convertMapValue(seedSoilMap, seed)
				fert := convertMapValue(soilFertMap, soil)
				water := convertMapValue(fertWaterMap, fert)
				light := convertMapValue(waterLightMap, water)
				temp := convertMapValue(lightTempMap, light)
				humid := convertMapValue(tempHumidMap, temp)
				loc := convertMapValue(humidLocMap, humid)

				if loc < result || result == 0 {
					result = loc
				}
			}
			lowestSeeds[index] = result
			wg.Done()
		}(i / 2)
	}

	wg.Wait()
	for _, lowestLoc := range lowestSeeds {
		if part_2 == 0 || lowestLoc < part_2 {
			part_2 = lowestLoc
		}
	}

	executionTime := time.Now().Sub(startTime)
	fmt.Printf("Took  %v to execute\n", executionTime)

	println("Part 1:", part_1)
	println("Part 2:", part_2)
	println()

}

func convertMapValue(mappings []Mapping, value int) int {
	for _, mapping := range mappings {
		if value >= mapping.src && value < mapping.src+mapping.len {
			return mapping.dest + (value - mapping.src)
		}
	}
	return value
}
