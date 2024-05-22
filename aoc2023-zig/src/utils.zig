const std = @import("std");

pub fn readFile(path: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    const allocator = std.heap.page_allocator;
    const fileSize = (try file.stat()).size;
    const buffer = try allocator.alloc(u8, fileSize);

    try file.reader().readNoEof(buffer);

    return buffer;
}
