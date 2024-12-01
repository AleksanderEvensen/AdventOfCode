const std = @import("std");
const day1 = @import("./challenges/day1.zig");

const Challenge = struct {
    input: []const u8,
    solveFn: *const fn ([]const u8) anyerror!void,
};

pub fn main() !void {
    const challenges = [_]Challenge{
        Challenge{ .input = @embedFile("./inputs/day1.txt"), .solveFn = &day1.solve },
    };

    for (challenges, 1..) |challenge, day| {
        std.debug.print("Running solver for day{}\n", .{day});

        const start = std.time.microTimestamp();
        try challenge.solveFn(challenge.input);
        const timeDiff: i64 = std.time.microTimestamp() - start;

        std.debug.print("Done solving day{}, it took {s}\n", .{ day, try formatDurration(timeDiff) });
    }
    std.debug.print("All done :)\n", .{});
}

fn formatDurration(nanoseconds: i64) anyerror![]const u8 {
    const fNanoseconds: f64 = @floatFromInt(nanoseconds);

    const unit = switch (nanoseconds) {
        0...1000 => "ns",
        1001...100_000 => "ms",
        else => "s",
    };
    const unitValue = switch (nanoseconds) {
        0...1000 => fNanoseconds,
        1001...100_000 => fNanoseconds / 1_000,
        else => fNanoseconds / 1_000_000,
    };

    var buffer: [100]u8 = undefined;
    return try std.fmt.bufPrint(&buffer, "{d}{s}", .{ unitValue, unit });
}