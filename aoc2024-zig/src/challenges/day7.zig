const std = @import("std");
const util = @import("../util.zig");
const print = std.debug.print;
const assert = std.debug.assert;

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    var part_1: usize = 0;
    var part_2: usize = 0;

    for (lines.items) |line| {
        const value_str, const equ = try util.splitOnce(line, ": ");
        const value = try util.parseInt(usize, value_str);

        const numbers = try util.collectNumbersSeperator(usize, equ, " ", alloc);
        defer numbers.deinit();

        const isPart1Valid = checkChain(value, numbers.items[0], numbers.items[1..], false);
        const isPart2Valid = isPart1Valid or checkChain(value, numbers.items[0], numbers.items[1..], true);

        if (isPart1Valid) {
            part_1 += value;
        }
        if (isPart2Valid) {
            part_2 += value;
        }
    }

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

fn checkChain(value: usize, a: usize, rest: []usize, canAppend: bool) bool {
    if (a > value) {
        return false;
    }
    if (rest.len == 0) {
        return value == a;
    }

    const b = rest[0];
    const log_b = std.math.pow(usize, 10, std.math.log_int(usize, 10, b) + 1);

    const add = checkChain(value, a + b, rest[1..], canAppend);
    const mul = checkChain(value, a * b, rest[1..], canAppend);
    const append = checkChain(value, a * log_b + b, rest[1..], canAppend);

    return add or mul or (canAppend and append);
}
