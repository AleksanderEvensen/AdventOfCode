use regex::Regex;

pub fn solve(input: String) {
    let rxp = Regex::new(r"(do\(\)|don't\(\)|mul\(\d+,\d+\))").expect("Invalid regex");
    let rxp_num = Regex::new(r"mul\((\d+),(\d+)\)").expect("Invalid regex");

    let mut disabled = false;
    let (part_1, part_2) = rxp.find_iter(&input).fold((0,0), |(mut part_1, mut part_2), op| {
        if op.as_str().starts_with("mul") {
            
            let (_, [a,b]) = rxp_num.captures(op.as_str()).unwrap().extract();
            let value = a.parse::<i32>().unwrap() * b.parse::<i32>().unwrap();

            part_1 += value;
            part_2 += value * if disabled { 0 } else { 1 };
            
        } else if op.as_str().starts_with("don't") {
            disabled = true;
        } else {
            disabled = false;
        }

        (part_1, part_2)
    });

    println!("Part 1: {}", part_1);
    println!("Part 2: {}", part_2);
}