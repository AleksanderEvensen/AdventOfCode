const std = @import("std");

pub fn solve(input: []const u8, _: std.mem.Allocator) !void {
    std.debug.print("Input: \n\n###\n{s}\n###\n\n", .{input});
}
