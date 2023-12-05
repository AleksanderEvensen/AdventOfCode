use super::{Challenge, PuzzleAnswer};
use indicatif::{MultiProgress, ProgressBar, ProgressIterator, ProgressStyle};
use rayon::prelude::*;
use std::{io::Read, ops::Range, usize};

pub struct Day5;

impl Challenge for Day5 {
    fn solve(
        &mut self,
        input_file: &mut std::fs::File,
    ) -> std::io::Result<(super::PuzzleAnswer, super::PuzzleAnswer)> {
        let mut input_data = String::new();
        input_file.read_to_string(&mut input_data)?;

        let mut seeds: Vec<usize> = vec![];

        let layers: Vec<Vec<(Range<usize>, Range<usize>)>> = input_data
            .replace("\r", "")
            .split("\n\n")
            .into_iter()
            .filter_map(|section| {
                let Some((section_type, values)) = section.split_once(":") else {
                    return None;
                };
                match section_type {
                    "seeds" => {
                        seeds = values
                            .split_whitespace()
                            .filter_map(|v| v.parse().ok())
                            .collect();
                        return None;
                    }

                    _ => Some(
                        values
                            .lines()
                            .skip(1)
                            .map(|line| {
                                let nums = line
                                    .split_whitespace()
                                    .filter_map(|v| v.parse::<usize>().ok())
                                    .collect::<Vec<usize>>();
                                (nums[0]..nums[0] + nums[2], nums[1]..nums[1] + nums[2])
                            })
                            .collect(),
                    ),
                }
            })
            .collect();

        let seed_ranges = seeds
            .chunks(2)
            .map(|seed_range| seed_range[0]..seed_range[0] + seed_range[1])
            .collect::<Vec<Range<usize>>>();

        let part_1 = seeds
            .iter()
            .map(|seed| {
                layers.iter().fold(*seed, |acc, ranges| {
                    for (dest, src) in ranges {
                        if src.contains(&acc) {
                            return dest.start + (acc - src.start);
                        }
                    }
                    return acc;
                })
            })
            .min()
            .unwrap();

        // let mut mb = MultiProgress::new();
        let start = std::time::Instant::now();
        let part_2 = seed_ranges
            .par_iter()
            .enumerate()
            .map(|(_i, seed_range)| {
                // println!("Started solving: {i}");
                // let pb = ProgressBar::new(seed_range.len() as u64);
                // pb.set_message(format!("Seed range ({i})"));
                // pb.set_style(
                //     ProgressStyle::with_template(
                //         "[{elapsed_precise}] {bar:40.cyan/blue} {pos:>7}/{len:7} {msg}",
                //     )
                //     .unwrap()
                //     .progress_chars("##-"),
                // );
                // print!("{}[2J", 27 as char);
                // let pb = mb.add(pb);
                let closest = seed_range
                    .clone()
                    // .progress_with(pb)
                    .map(|seed| {
                        layers.iter().fold(seed, |acc, ranges| {
                            for (dest, src) in ranges {
                                if acc >= src.start && acc < src.end {
                                    return dest.start + (acc - src.start);
                                }
                            }
                            return acc;
                        })
                    })
                    .min();
                // println!("Done solving: {i}");
                closest.unwrap()
            })
            .min()
            .unwrap();

        let dur = std::time::Instant::now() - start;

        println!("Took {}s to complete", dur.as_secs_f32());
        // mb.clear().unwrap();
        Ok((PuzzleAnswer::UNumber(part_1), PuzzleAnswer::UNumber(part_2)))
    }
}
