use regex::Regex;

pub fn solve(input: String) {
    let rxp = Regex::new(r"(do\(\)|don't\(\)|mul\((?<a>\d+),(?<b>\d+)\))").expect("Invalid regex");

    let mut disabled = false;
    let (part_1, part_2) = rxp.captures_iter(&input).fold((0,0), |(mut part_1, mut part_2), caps| {
        let op = caps.get(0).unwrap().as_str();
        if op.starts_with("mul") {
            let a = caps.name("a").unwrap().as_str().parse::<i32>().unwrap();            
            let b = caps.name("b").unwrap().as_str().parse::<i32>().unwrap();

            let value = a*b;
            part_1 += value;
            part_2 += value * if disabled { 0 } else { 1 };
            
        } else if op.starts_with("don't") {
            disabled = true;
        } else {
            disabled = false;
        }

        (part_1, part_2)
    });

    println!("Part 1: {}", part_1);
    println!("Part 2: {}", part_2);
}