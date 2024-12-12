const std = @import("std");
const util = @import("./util.zig");
const assert = std.debug.assert;

const day1 = @import("./challenges/day1.zig");
const day2 = @import("./challenges/day2.zig");
const day3 = @import("./challenges/day3.zig");
const day4 = @import("./challenges/day4.zig");
const day5 = @import("./challenges/day5.zig");
const day6 = @import("./challenges/day6.zig");
const day7 = @import("./challenges/day7.zig");
const day8 = @import("./challenges/day8.zig");
const day9 = @import("./challenges/day9.zig");
const day10 = @import("./challenges/day10.zig");
const day11 = @import("./challenges/day11.zig");

const Challenge = struct {
    input: []const u8,
    solveFn: *const fn ([]const u8, std.mem.Allocator) anyerror!void,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // Detect memory leaks
    defer assert(!gpa.detectLeaks());

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
        Challenge{ .input = "./src/inputs/day6.txt", .solveFn = &day6.solve },
        Challenge{ .input = "./src/inputs/day7.txt", .solveFn = &day7.solve },
        Challenge{ .input = "./src/inputs/day8.txt", .solveFn = &day8.solve },
        Challenge{ .input = "./src/inputs/day9.txt", .solveFn = &day9.solve },
        Challenge{ .input = "./src/inputs/day10.txt", .solveFn = &day10.solve },
        Challenge{ .input = "./src/inputs/day11.txt", .solveFn = &day11.solve },
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
        const contents = try crlf_to_lf(try file.readToEndAlloc(alloc, file_size), alloc);

        const stopWatch = util.StopWatch().init();
        try challenge.solveFn(contents, alloc);

        std.debug.print("Done solving day{}, it took {s}\n\n", .{ day, try stopWatch.lapWithFormat() });
    }
    std.debug.print("All done :)\n", .{});
}

fn crlf_to_lf(contents: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const size = std.mem.replacementSize(u8, contents, "\r\n", "\n");
    const buffer = try allocator.alloc(u8, size);
    _ = std.mem.replace(u8, contents, "\r\n", "\n", buffer);
    return buffer;
}
