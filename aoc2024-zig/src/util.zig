const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn lines(string: []const u8) std.mem.SplitIterator(u8, .scalar) {
    return std.mem.splitScalar(u8, string, '\n');
}

pub fn split(string: []const u8, sep: []const u8) std.mem.SplitIterator(u8, .sequence) {
    return std.mem.splitSequence(u8, string, sep);
}

const SplitOnceError = error{
    NoFirstElement,
    NoSecondElement,
    ParseIntError,
};
pub fn splitOnce(string: []const u8, sep: []const u8) SplitOnceError!struct { []const u8, []const u8 } {
    var it = split(string, sep);
    const first = it.next() orelse return error.NoFirstElement;
    const second = it.next() orelse return error.NoSecondElement;
    return .{ first, second };
}

pub fn splitOnceNumbers(comptime T: type, string: []const u8, sep: []const u8) SplitOnceError!struct { T, T } {
    const first, const second = try splitOnce(string, sep);
    return .{ parseInt(T, first) catch return error.ParseIntError, parseInt(T, second) catch return error.ParseIntError };
}

pub fn collectLines(string: []const u8, allocator: Allocator) Allocator.Error!std.ArrayList([]const u8) {
    var list = std.ArrayList([]const u8).init(allocator);
    var it = lines(string);
    while (it.next()) |line| {
        try list.append(line);
    }
    return list;
}

pub fn collectNumbersSeperator(comptime T: type, string: []const u8, sep: []const u8, allocator: Allocator) !std.ArrayList(T) {
    var list = std.ArrayList(T).init(allocator);
    var it = split(string, sep);
    while (it.next()) |part| {
        try list.append(try parseInt(T, part));
    }
    return list;
}

pub fn contains(comptime T: type, array: []const T, value: T) bool {
    for (array) |item| {
        if (item == value) {
            return true;
        }
    }
    return false;
}

pub fn parseInt(comptime T: type, string: []const u8) std.fmt.ParseIntError!T {
    return try std.fmt.parseInt(T, string, 10);
}