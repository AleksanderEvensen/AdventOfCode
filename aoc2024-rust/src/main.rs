mod challenges;
fn main() {
    let to_run = std::env::args()
        .last()
        .unwrap()
        .parse::<isize>()
        .map_or(-1, |v| v);

    let challenges: Vec<(&dyn Fn(String), &'static str)> = vec![
        (&challenges::solve_day1, "./src/inputs/day1.txt"),
        (&challenges::solve_day2, "./src/inputs/day2.txt"),
    ];

    for i in 0..challenges.len() {
        if to_run != -1 && (i + 1) as isize != to_run {
            continue;
        }

        let (func, path) = challenges[i];

        println!("\nSolving day{}\n", i + 1);
        let start = std::time::Instant::now();
        match std::fs::read_to_string(path) {
            Ok(input) => func(input),
            Err(err) => {
                println!("Failed to read input file for day{}", i + 1);
                println!("    {}", err);
                continue;
            }
        }
        let elapsed = start.elapsed();
        println!("\nDone solving day{} in {:?}", i + 1, elapsed);
    }
}
