const std = @import("std");
const util = @import("../util.zig");

const print = std.debug.print;

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    var lines = util.lines(input);

    var left_column = std.ArrayList(u32).init(alloc);
    var right_column = std.ArrayList(u32).init(alloc);
    defer left_column.deinit();
    defer right_column.deinit();

    while (lines.next()) |line| {
        const left, const right = try util.splitOnceNumbers(u32, line, "   ");

        try left_column.append(left);
        try right_column.append(right);
    }

    std.mem.sort(u32, left_column.items, {}, std.sort.asc(u32));
    std.mem.sort(u32, right_column.items, {}, std.sort.asc(u32));

    var sum_part1: usize = 0;
    var sum_part2: usize = 0;
    for (left_column.items, right_column.items) |left, right| {
        sum_part1 += if (left > right) left - right else right - left;

        var count: usize = 0;
        for (right_column.items) |right_loop| {
            if (left == right_loop) count += 1;
        }
        sum_part2 += count * left;
    }

    print("Part 1: {}\n", .{sum_part1});
    print("Part 2: {}\n", .{sum_part2});
}
