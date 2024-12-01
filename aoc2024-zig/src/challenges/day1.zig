const std = @import("std");

pub fn solve(input: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var lines = std.mem.tokenizeAny(u8, input, "\n");

    var left_column = std.ArrayList(u32).init(allocator);
    var right_column = std.ArrayList(u32).init(allocator);
    defer left_column.deinit();
    defer right_column.deinit();

    while (lines.next()) |line| {
        var tokens = std.mem.tokenizeScalar(u8, line, ' ');
        const left = try std.fmt.parseInt(u32, tokens.next().?, 10);
        const right = try std.fmt.parseInt(u32, tokens.next().?, 10);

        try left_column.append(left);
        try right_column.append(right);
    }

    std.mem.sort(u32, left_column.items, {}, std.sort.asc(u32));
    std.mem.sort(u32, right_column.items, {}, std.sort.asc(u32));

    var sum_part1: usize = 0;
    for (left_column.items, right_column.items) |left, right| {
        sum_part1 += if (left > right) left - right else right - left;
    }

    var sum_part2: usize = 0;
    for (left_column.items) |left| {
        var count: usize = 0;
        for (right_column.items) |right| {
            if (left == right) count += 1;
        }
        sum_part2 += count * left;
    }

    std.debug.print("Part 1: {}\n", .{sum_part1});
    std.debug.print("Part 2: {}\n", .{sum_part2});
}
