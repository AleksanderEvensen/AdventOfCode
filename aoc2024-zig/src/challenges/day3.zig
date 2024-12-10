const std = @import("std");
const util = @import("../util.zig");

const print = std.debug.print;

const Instructions = enum {
    dont,
    do,
    mul,
};

pub fn solve(input: []const u8, _: std.mem.Allocator) !void {
    var fns = util.split(input, "(");

    var sum_part1: isize = 0;
    var sum_part2: isize = 0;
    var disabled = false;

    var prev = fns.next().?;
    while (fns.next()) |token| {
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

        const params = util.splitTakeFirst(token, ")") orelse continue;

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

                const p1, const p2 = util.splitOnceNumbers(isize, params, ",") catch continue;

                sum_part1 += p1 * p2;
                sum_part2 += p1 * p2 * @as(isize, if (disabled) 0 else 1);
            },
        }
    }

    print("Part 1: {d}\n", .{sum_part1});
    print("Part 2: {d}\n", .{sum_part2});
}
