const std = @import("std");

pub fn solve(input: []const u8, allocator: std.mem.Allocator) !void {
    var lines = std.mem.tokenizeAny(u8, input, "\n");

    var sum_part1: usize = 0;
    var sum_part2: usize = 0;

    while (lines.next()) |line| {
        var values = std.mem.tokenizeScalar(u8, line, ' ');

        var lastValue: isize = std.fmt.parseInt(isize, values.next().?, 10) catch unreachable;
        const isIncreasing = std.fmt.parseInt(isize, values.peek().?, 10) catch unreachable > lastValue;
        const isSafe = while (values.next()) |value| {
            const currentValue: isize = std.fmt.parseInt(isize, value, 10) catch unreachable;
            const diff = (currentValue - lastValue) * (if (isIncreasing) @as(isize, 1) else -1);

            lastValue = currentValue;

            if (diff < 1 or diff > 3) {
                break false;
            }
        } else true;

        sum_part1 += if (isSafe) 1 else 0;
    }
    lines.reset();

    while (lines.next()) |line| {
        var iter = std.mem.tokenizeScalar(u8, line, ' ');

        var values = std.ArrayList(isize).init(allocator);
        defer values.deinit();
        while (iter.next()) |v| {
            values.append(std.fmt.parseInt(u8, v, 10) catch unreachable) catch unreachable;
        }

        const isAnySafe = skipping: for (0..values.items.len) |toSkip| {
            var levels = std.ArrayList(isize).init(allocator);
            defer levels.deinit();

            if (toSkip == 0) {
                try levels.appendSlice(values.items[1..]);
            } else {
                try levels.appendSlice(values.items[0..toSkip]);
                try levels.appendSlice(values.items[(toSkip + 1)..]);
            }

            const isIncreasing = levels.items[1] > levels.items[0];
            const isSafe = for (1..levels.items.len) |i| {
                const diff: isize = (levels.items[i] - levels.items[i - 1]) * (if (isIncreasing) @as(isize, 1) else -1);
                if (diff < 1 or diff > 3) {
                    break false;
                }
            } else true;

            if (isSafe) {
                break :skipping true;
            }
        } else false;

        if (isAnySafe) {
            sum_part2 += 1;
        }
    }

    std.debug.print("Part 1: {}\n", .{sum_part1});
    std.debug.print("Part 2: {}\n", .{sum_part2});
}
