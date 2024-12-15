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

pub fn splitTakeFirst(string: []const u8, sep: []const u8) ?[]const u8 {
    var it = split(string, sep);
    return it.next();
}

pub fn collectSeperator(string: []const u8, sep: []const u8, allocator: Allocator) Allocator.Error!std.ArrayList([]const u8) {
    var list = std.ArrayList([]const u8).init(allocator);
    var it = split(string, sep);
    while (it.next()) |section| {
        try list.append(section);
    }
    return list;
}

pub fn collectLines(string: []const u8, allocator: Allocator) Allocator.Error!std.ArrayList([]const u8) {
    return collectSeperator(string, "\n", allocator);
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
        if (std.meta.eql(item, value)) {
            return true;
        }
    }
    return false;
}

pub fn parseInt(comptime T: type, string: []const u8) std.fmt.ParseIntError!T {
    return try std.fmt.parseInt(T, string, 10);
}

pub fn parseFloat(comptime T: type, string: []const u8) std.fmt.ParseFloatError!T {
    return try std.fmt.parseFloat(T, string);
}

pub fn strEql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

pub fn countIter(it: anytype) usize {
    var count: usize = 0;
    while (it.next()) |_| {
        count += 1;
    }
    return count;
}

pub fn StopWatch() type {
    return struct {
        start: i64,

        const Self = @This();

        pub fn init() Self {
            return .{ .start = std.time.microTimestamp() };
        }

        pub fn restart(self: *Self) void {
            self.start = std.time.microTimestamp();
        }

        pub fn lap(self: Self) i64 {
            return std.time.microTimestamp() - self.start;
        }

        pub fn lapWithFormat(self: Self) ![]const u8 {
            const duration = self.lap();

            return try formatDurration(duration);
        }
    };
}

pub fn formatDurration(nanoseconds: i64) anyerror![]const u8 {
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

    var buffer: [16]u8 = undefined;
    return try std.fmt.bufPrint(&buffer, "{d}{s}", .{ unitValue, unit });
}
