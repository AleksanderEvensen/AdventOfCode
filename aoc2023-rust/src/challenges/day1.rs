use crate::challenges::{Challenge, PuzzleAnswer};
use std::fs::File;
use std::io::{Read, Result};

pub struct Day1;

impl Challenge for Day1 {
    fn solve(&mut self, input_file: &mut File) -> Result<(PuzzleAnswer, PuzzleAnswer)> {
        let mut part_1: usize = 0;
        let mut part_2: usize = 0;

        let mut input_data = String::new();
        input_file.read_to_string(&mut input_data)?;

        input_data.lines().for_each(|line| {
            let numbers: Vec<usize> = line
                .chars()
                .filter(|c| c.is_numeric())
                .map(|v| v.to_digit(10).unwrap() as usize)
                .collect();

            let numbers_2: Vec<usize> = line
                .replace("one", "o1ne")
                .replace("two", "tw2o")
                .replace("three", "th3ree")
                .replace("four", "fo4ur")
                .replace("five", "fi5ve")
                .replace("six", "s6ix")
                .replace("seven", "sev7en")
                .replace("eight", "eig8ht")
                .replace("nine", "ni9ne")
                .chars()
                .filter(|c| c.is_numeric())
                .map(|v| v.to_digit(10).unwrap() as usize)
                .collect();

            part_1 += numbers.first().unwrap() * 10 + numbers.last().unwrap();
            part_2 += numbers_2.first().unwrap() * 10 + numbers_2.last().unwrap();
        });

        Ok((PuzzleAnswer::UNumber(part_1), PuzzleAnswer::UNumber(part_2)))
    }
}
