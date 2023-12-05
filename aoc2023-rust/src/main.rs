use crate::challenges::Challenge;
mod challenges;

fn main() {
    let to_run = std::env::args()
        .last()
        .unwrap()
        .parse::<i8>()
        .map_or(-1, |v| v);

    let mut challenges: Vec<(Box<dyn Challenge>, &str)> = vec![
        (Box::new(challenges::Day1), "./src/inputs/day1.txt"),
        (Box::new(challenges::Day2), "./src/inputs/day2.txt"),
        (Box::new(challenges::Day3), "./src/inputs/day3.txt"),
        (Box::new(challenges::Day4), "./src/inputs/day4.txt"),
        (Box::new(challenges::Day5), "./src/inputs/day5.txt"),
    ];

    challenges
        .iter_mut()
        .enumerate()
        .for_each(|(i, (ch, inp))| {
            if to_run == -1 || to_run == i as i8 + 1 {
                println!("Solving Day{}:", i + 1);
                let Ok(mut file) = std::fs::File::open(&inp) else {
                    panic!(
                        "Failed to read input file for Day{}\nInput file: {}",
                        i + 1,
                        inp
                    );
                };
                let (part_1, part_2) = ch.solve(&mut file).unwrap();
                println!("Part 1: {:?}", part_1);
                println!("Part 2: {:?}\n", part_2);
            }
        });
}
