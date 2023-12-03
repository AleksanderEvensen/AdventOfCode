use crate::challenges::{Challenge, PuzzleAnswer};
use std::fs::File;
use std::io::Read;

pub struct Day2;

impl Challenge for Day2 {
    fn solve(&mut self, input_file: &mut File) -> std::io::Result<(PuzzleAnswer, PuzzleAnswer)> {
        let mut input_data = String::new();
        input_file.read_to_string(&mut input_data)?;

        let mut part_1 = 0;
        let part_2 = input_data
            .lines()
            .map(|line| {
                let game_id: usize = line
                    .split_once("Game ")
                    .unwrap()
                    .1
                    .split_once(":")
                    .unwrap()
                    .0
                    .parse()
                    .unwrap();

                let (red, green, blue) = line
                    .strip_prefix(&format!("Game {game_id}: "))
                    .unwrap()
                    .split("; ")
                    .map(|round| {
                        round
                            .split(", ")
                            .map(|dice| {
                                let (num, color) = dice.split_once(" ").unwrap();

                                (num.parse::<usize>().unwrap(), color)
                            })
                            .fold((0, 0, 0), |acc, (count, color)| match color {
                                "red" if count > acc.0 => (count, acc.1, acc.2),
                                "green" if count > acc.1 => (acc.0, count, acc.2),
                                "blue" if count > acc.2 => (acc.0, acc.1, count),
                                _ => acc,
                            })
                    })
                    .fold((0, 0, 0), |acc, (red, green, blue)| {
                        (
                            if acc.0 > red { acc.0 } else { red },
                            if acc.1 > green { acc.1 } else { green },
                            if acc.2 > blue { acc.2 } else { blue },
                        )
                    });

                if red <= 12 && green <= 13 && blue <= 14 {
                    part_1 += game_id
                }

                red * green * blue
            })
            .sum();

        Ok((PuzzleAnswer::UNumber(part_1), PuzzleAnswer::UNumber(part_2)))
    }
}
