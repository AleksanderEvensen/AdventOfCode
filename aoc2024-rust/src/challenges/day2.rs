pub fn solve(input: String) {

    let part_1 = input.lines().filter(|line| {
        let nums: Vec<isize> = line.split_whitespace().filter_map(|v| v.parse().ok()).collect();
        is_report_valid(&nums)
    }).count();

    let part_2 = input.lines().filter(|line| {
        let nums: Vec<isize> = line.split_whitespace().filter_map(|v|v.parse().ok()).collect();
        
        (0..nums.len()).any(|to_skip| { 
            let mut report = nums.clone();
            report.remove(to_skip);
            is_report_valid(&report)
        })
    }).count();

    println!("Part 1: {}", part_1);
    println!("Part 2: {}", part_2);


}


fn is_report_valid(report: &[isize]) -> bool {
    let is_inc = report[0] < report[2];

    return report.windows(2).all(|pair|{
        let diff: isize = (pair[1] - pair[0]) * (if is_inc { 1 } else { -1 });
        (1..=3).contains(&diff)
    });
}