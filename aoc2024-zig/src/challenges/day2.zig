const std = @import("std");
const util = @import("../util.zig");

const print = std.debug.print;

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    var sum_part1: usize = 0;
    var sum_part2: usize = 0;

    for (lines.items) |line| {
        const values = try util.collectNumbersSeperator(isize, line, " ", alloc);
        defer values.deinit();

        const is_safe = isSafe(values.items);

        if (is_safe) {
            sum_part1 += 1;
            sum_part2 += 1;
            continue;
        }

        const isAnySafe = for (0..values.items.len) |to_skip| {
            var new_set = try alloc.alloc(isize, values.items.len - 1);
            defer alloc.free(new_set);

            @memcpy(new_set[0..to_skip], values.items[0..to_skip]);
            @memcpy(new_set[to_skip..], values.items[(to_skip + 1)..]);

            if (isSafe(new_set)) {
                break true;
            }
        } else false;

        if (isAnySafe) sum_part2 += 1;
    }

    print("Part 1: {}\n", .{sum_part1});
    print("Part 2: {}\n", .{sum_part2});
}

fn isSafe(values: []isize) bool {
    const is_increasing = values[1] > values[0];

    for (values[1..], 1..) |value, i| {
        const last_value = values[i - 1];
        const diff = (value - last_value) * @as(isize, if (is_increasing) 1 else -1);

        if (diff < 1 or diff > 3) {
            return false;
        }
    }

    return true;
}
