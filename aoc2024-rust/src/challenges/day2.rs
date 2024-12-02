use std::ops::Mul;

pub fn solve(input: String) {
    let reports: Vec<Vec<isize>> = input.lines().map(|line|{
        line.split_whitespace().filter_map(|v|v.parse().ok()).collect()
    }).collect();

    let (part_1, part_2) = reports.iter().fold((0,0), |acc, report| {
        let sign = (report[1] - report[0]).signum() | 1;
        let errors = report
            .windows(2)
            .filter(|pair| !(1..=3).contains(&(pair[1]-pair[0]).mul(sign)))
            .count();

        
        (acc.0 + (errors == 0) as isize, acc.1 + (errors < 2) as isize)
    });

    println!("Part 1: {}", part_1);
    println!("Part 2: {}", part_2);
}