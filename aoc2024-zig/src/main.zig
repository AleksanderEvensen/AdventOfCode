const std = @import("std");

const day1 = @import("./challenges/day1.zig");
const day2 = @import("./challenges/day2.zig");
const day3 = @import("./challenges/day3.zig");
const day4 = @import("./challenges/day4.zig");
const day5 = @import("./challenges/day5.zig");

const Challenge = struct {
    input: []const u8,
    solveFn: *const fn ([]const u8, std.mem.Allocator) anyerror!void,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    const args = try std.process.argsAlloc(arena.allocator());

    const specific_day: i32 = if (args.len > 1) (std.fmt.parseInt(i32, args[1], 10) catch -1) else -1;

    const challenges = [_]Challenge{
        Challenge{ .input = "./src/inputs/day1.txt", .solveFn = &day1.solve },
        Challenge{ .input = "./src/inputs/day2.txt", .solveFn = &day2.solve },
        Challenge{ .input = "./src/inputs/day3.txt", .solveFn = &day3.solve },
        Challenge{ .input = "./src/inputs/day4.txt", .solveFn = &day4.solve },
        Challenge{ .input = "./src/inputs/day5.txt", .solveFn = &day5.solve },
    };

    for (challenges, 1..) |challenge, day| {
        if (specific_day != -1 and specific_day != day) {
            continue;
        }
        std.debug.print("Running solver for day{}\n", .{day});
        const alloc = arena.allocator();

        const file = try std.fs.cwd().openFile(challenge.input, .{ .mode = .read_only });
        defer file.close();
        const file_size = (try file.stat()).size;
        const contents = try file.readToEndAlloc(alloc, file_size);

        const start = std.time.microTimestamp();
        try challenge.solveFn(contents, alloc);
        const timeDiff: i64 = std.time.microTimestamp() - start;

        std.debug.print("Done solving day{}, it took {s}\n\n", .{ day, try formatDurration(timeDiff) });
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
