use crate::challenges::{Challenge, PuzzleAnswer};
use std::collections::HashMap;
use std::fs::File;
use std::io::Read;
use std::str::Chars;

pub struct Day3;

impl Challenge for Day3 {
    fn solve(&mut self, input_file: &mut File) -> std::io::Result<(PuzzleAnswer, PuzzleAnswer)> {
        let mut part_1 = 0;

        let mut input_data = String::new();
        input_file.read_to_string(&mut input_data).unwrap();

        let char_map = input_data
            .lines()
            .map(|line| line.chars().collect())
            .collect::<Vec<Vec<char>>>();

        let mut gear_map: HashMap<(usize, usize), Vec<u32>> = HashMap::new();

        let mut line_iter = char_map.iter().enumerate();

        while let Some((y, line)) = line_iter.next() {
            let mut char_iter = line.iter().enumerate();

            while let Some((x, mut char)) = char_iter.next() {
                if char == &'.' {
                    continue;
                }

                let mut num = 0;
                let mut num_end = 0;
                while char.is_numeric() {
                    num *= 10;
                    num += char.to_digit(10).unwrap();

                    if let Some((next_x, next_c)) = char_iter.next() {
                        char = next_c;
                        num_end = next_x;
                    } else {
                        break;
                    }
                }

                let mut has_adjacent = false;

                for cy in y - if y == 0 { 0 } else { 1 }..y + 2 {
                    if let Some(cline) = char_map.get(cy) {
                        for cx in x - if x == 0 { 0 } else { 1 }..num_end + 1 {
                            if let Some(cchar) = cline.get(cx) {
                                has_adjacent |= cchar != &'.' && !cchar.is_numeric();
                                if cchar == &'*' {
                                    if !gear_map.contains_key(&(cx, cy)) {
                                        gear_map.insert((cx, cy), vec![]);
                                    }
                                    gear_map.get_mut(&(cx, cy)).unwrap().push(num);
                                }
                            }
                        }
                    }
                }

                if has_adjacent {
                    part_1 += num as usize;
                }
            }
        }

        let part_2 = gear_map
            .iter()
            .filter(|(_, gear_ratios)| gear_ratios.len() == 2)
            .map(|(_, gear_ratios)| gear_ratios.iter().fold(1, |acc, v| acc * v) as usize)
            .sum();

        Ok((PuzzleAnswer::UNumber(part_1), PuzzleAnswer::UNumber(part_2)))
    }
}
