use std::fs::File;

pub mod day1;
pub use day1::Day1;

pub mod day2;
pub use day2::Day2;

pub mod day3;
pub use day3::Day3;

pub mod day4;
pub use day4::Day4;

pub mod day5;
pub use day5::Day5;

#[derive(Debug, Clone)]
pub enum PuzzleAnswer {
    UNumber(usize),
    Number(isize),
    String(String),
}

pub trait Challenge {
    fn solve(&mut self, input_file: &mut File) -> std::io::Result<(PuzzleAnswer, PuzzleAnswer)>;
}
