package utils

import (
	"log"
	"os"
	"strconv"
	"strings"
)

func ReadFile(filePath string) string {
	file, err := os.ReadFile(filePath)
	if err != nil {
		log.Fatal(err)
	}
	return string(file)
}

func ReadAllLines(filePath string) []string {
	return strings.Split(strings.ReplaceAll(ReadFile(filePath), "\r\n", "\n"), "\n")
}

func GetNumbers(strarr []string) []int {
	var arr []int
	for _, str := range strarr {
		if v, err := strconv.Atoi(str); err == nil {
			arr = append(arr, v)
		}
	}
	return arr
}
