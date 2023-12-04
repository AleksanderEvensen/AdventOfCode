use super::{Challenge, PuzzleAnswer};
use std::collections::HashMap;
use std::io::Read;
use std::ops::AddAssign;

pub struct Day4;

impl Challenge for Day4 {
    fn solve(
        &mut self,
        input_file: &mut std::fs::File,
    ) -> std::io::Result<(super::PuzzleAnswer, super::PuzzleAnswer)> {
        let mut input_data = String::new();
        input_file.read_to_string(&mut input_data)?;

        let mut copies: HashMap<usize, usize> = HashMap::new();

        Ok(input_data
            .lines()
            .enumerate()
            .filter_map(|(_, line)| line.split_once(":")?.1.split_once("|"))
            .filter_map(|(winning_numbers, numbers)| {
                let winning_numbers = winning_numbers
                    .split_whitespace()
                    .filter_map(|v| v.parse::<u32>().ok())
                    .collect::<Vec<_>>();
                let numbers = numbers
                    .split_whitespace()
                    .filter_map(|v| v.parse::<u32>().ok())
                    .collect::<Vec<_>>();

                Some((winning_numbers, numbers))
            })
            .enumerate()
            .fold(
                (0, 0),
                |(mut part_1, mut part_2), (i, (winning_numbers, numbers))| {
                    let win_count = winning_numbers
                        .iter()
                        .filter(|v| numbers.contains(v))
                        .count();
                    let card = i + 1;

                    if win_count > 0 {
                        part_1 += (2 as usize).pow(win_count as u32 - 1);
                    }

                    for to_copy in card + 1..=card + win_count {
                        if !copies.contains_key(&to_copy) {
                            copies.insert(to_copy, 0);
                        }

                        let current_copies = copies.get(&card).map_or(0, |v| *v);

                        copies
                            .get_mut(&to_copy)
                            .unwrap()
                            .add_assign(current_copies + 1);
                    }

                    part_2 += copies.get(&card).map_or(0, |v| *v) + 1;
                    (part_1, part_2)
                },
            ))
        .map(|(x, y)| (PuzzleAnswer::UNumber(x), (PuzzleAnswer::UNumber(y))))
    }
}
