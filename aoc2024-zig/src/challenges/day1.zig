const std = @import("std");
const File = std.fs.File;
const expect = std.testing.expect;
const equal = std.mem.eql;

pub fn solve(inputFile: []const u8) !void {
    const file = try std.fs.cwd().openFile(inputFile, .{});
    defer file.close();

    var bufferReader = std.io.bufferedReader(file.reader());
    var inputReader = bufferReader.reader();

    var buffer: [1024]u8 = undefined;
    while (try inputReader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        std.debug.print("line: {s}\n", .{line});
    }
}
