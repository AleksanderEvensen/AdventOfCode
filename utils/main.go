package utils

import (
	"log"
	"os"
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