use std::fs::File;

pub mod day1;
pub mod day2;
pub mod day3;
pub mod day4;

#[derive(Debug, Clone)]
pub enum PuzzleAnswer {
    UNumber(usize),
    Number(isize),
    String(String),
}

pub trait Challenge {
    fn solve(&mut self, input_file: &mut File) -> std::io::Result<(PuzzleAnswer, PuzzleAnswer)>;
}
