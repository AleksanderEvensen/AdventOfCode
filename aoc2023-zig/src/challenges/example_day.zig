const std = @import("std");

pub fn solve(inputFile: []const u8) !void {
    const file = try std.fs.cwd().openFile(inputFile, .{});
    defer file.close();

    var bufferReader = std.io.bufferedReader(file.reader());
    var inputReader = bufferReader.reader();

    var part1: u32 = 0;
    var part2: u32 = 0;

    var lineBuf: [1024]u8 = undefined;
    while (try inputReader.readUntilDelimiterOrEof(&lineBuf, '\n')) |line| {
        std.debug.print("Line: {}\n", .{line});

        part1 += 0;
        part2 += 0;
    }

    std.debug.print("Part 1: {} | Part 2: {}\n", .{ part1, part2 });
}
