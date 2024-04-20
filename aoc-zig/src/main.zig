const std = @import("std");
const day1 = @import("./challenges/day1.zig");
const day2 = @import("./challenges/day2.zig");

const Challenge = struct {
    inputFile: []const u8,
    solveFn: *const fn ([]const u8) anyerror!void,
};

pub fn main() !void {
    const challenges = [_]Challenge{
        Challenge{ .inputFile = "./inputs/day1.txt", .solveFn = &day1.solve },
        Challenge{ .inputFile = "./inputs/day2.txt", .solveFn = &day2.solve },
    };

    for (challenges, 1..) |challenge, i| {
        std.debug.print("Running solver for day{}\n", .{i});
        try challenge.solveFn(challenge.inputFile);
    }
    std.debug.print("All done :)\n", .{});
}
