const std = @import("std");
const print = std.debug.print;

pub fn solve(input: []const u8, _: std.mem.Allocator) !void {
    var tokens = std.mem.tokenizeScalar(u8, input, '(');

    var sum_part1: isize = 0;
    var sum_part2: isize = 0;
    var disabled = false;
    var prev = tokens.next().?;

    const Instructions = enum {
        dont,
        do,
        mul,
    };

    while (tokens.next()) |token| {
        defer prev = token;

        if (!std.mem.containsAtLeast(u8, token, 1, ")")) {
            continue;
        }

        const instr_type = if (std.mem.endsWith(u8, prev, "don't"))
            Instructions.dont
        else if (std.mem.endsWith(u8, prev, "do"))
            Instructions.do
        else if (std.mem.endsWith(u8, prev, "mul"))
            Instructions.mul
        else
            continue;

        var rest = std.mem.splitScalar(u8, token, ')');

        const params = rest.next() orelse continue;

        switch (instr_type) {
            Instructions.dont => {
                if (params.len != 0) continue;
                disabled = true;
            },
            Instructions.do => {
                if (params.len != 0) continue;
                disabled = false;
            },
            Instructions.mul => {
                if (params.len > 7) continue;
                var numbers_iter = std.mem.tokenizeScalar(u8, params, ',');

                const a = numbers_iter.next() orelse continue;
                const b = numbers_iter.next() orelse continue;

                const p1 = std.fmt.parseInt(isize, a, 10) catch continue;
                const p2 = std.fmt.parseInt(isize, b, 10) catch continue;
                if (p1 * p2 == 793086) print("Found the bastard: {s}({s}\n", .{ prev, token });
                sum_part1 += p1 * p2;
                sum_part2 += p1 * p2 * @as(isize, if (disabled) 0 else 1);
            },
        }
    }

    print("Part 1: {d}\n", .{sum_part1});
    print("Part 2: {d}\n", .{sum_part2});
}
