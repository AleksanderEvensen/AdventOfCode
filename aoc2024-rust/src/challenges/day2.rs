use std::ops::Mul;

pub fn solve(input: String) {
    
    let reports: Vec<Vec<isize>> = input.lines().map(|line|{
        line.split_whitespace().filter_map(|v|v.parse().ok()).collect()
    }).collect();

    let part_1 = reports.iter().filter(|report| {
        let sign = (report[1] - report[0]).signum() | 1;
        report
            .windows(2)
            .all(|pair| (1..=3).contains(&(pair[1]-pair[0]).mul(sign)))
    }).count();

    let part_2 = reports.iter().filter(|report| {
        
        (0..report.len()).any(|to_skip| {
            let skipped_report = report.iter().enumerate()
                .filter(|(i,_)| *i != to_skip)
                .map(|(_,v)|v)
                .collect::<Vec<&isize>>();
            
            let sign = (skipped_report[1] - skipped_report[0]).signum() | 1;

            skipped_report
                .windows(2)
                .all(|pair| (1..=3).contains(&(pair[1]-pair[0]).mul(sign)))
        })

    }).count();

    println!("Part 1: {}", part_1);
    println!("Part 2: {}", part_2);


}
