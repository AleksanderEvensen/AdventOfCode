pub fn solve(input: String) {
    let mut left_column: Vec<isize> = Vec::new();
    let mut right_column: Vec<isize> = Vec::new();
    for line in input.lines() {
        let mut iter = line.trim().split_whitespace();
        let left = iter.next().unwrap().parse::<isize>().unwrap();
        let right = iter.next().unwrap().parse::<isize>().unwrap();
        left_column.push(left);
        right_column.push(right);
    }
    left_column.sort();
    right_column.sort();

    let part1 = left_column
        .iter()
        .zip(right_column.iter())
        .fold(0, |acc, (left, right)| {
            acc + (if left > right {
                left - right
            } else {
                right - left
            })
        });

    let part2 = left_column.iter().fold(0, |acc, left| {
        acc + right_column.iter().filter(|right| left == *right).count() as isize * left
    });

    println!("Part 1: {}", part1);
    println!("Part 2: {}", part2);
}
