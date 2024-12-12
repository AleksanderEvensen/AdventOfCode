const std = @import("std");
const util = @import("../util.zig");

const print = std.debug.print;
const assert = std.debug.assert;

const CacheEntry = struct {
    value: usize,
    level: usize,
};

var cache: std.AutoHashMap(CacheEntry, usize) = undefined;

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    cache = std.AutoHashMap(CacheEntry, usize).init(alloc);
    defer cache.deinit();

    var stones = try util.collectNumbersSeperator(usize, input, " ", alloc);
    defer stones.deinit();

    var part_1: usize = 0;
    var part_2: usize = 0;
    for (stones.items) |stone| {
        part_1 += try blink(stone, 25);
        part_2 += try blink(stone, 75);
    }
    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

fn blink(value: usize, level: usize) !usize {
    if (level == 0) return 1;
    // Return memoized value
    if (cache.get(.{ .value = value, .level = level })) |entry| return entry;

    const result: usize = stones: {
        if (value == 0) break :stones try blink(1, level - 1);

        const digits = std.math.log10_int(value) + 1;
        if (digits % 2 == 0) {
            const middle = digits / 2;
            const left = value / std.math.pow(usize, 10, middle);
            const right = value % std.math.pow(usize, 10, middle);
            break :stones try blink(left, level - 1) + try blink(right, level - 1);
        }
        break :stones try blink(value * 2024, level - 1);
    };
    // Add to cache
    try cache.put(.{ .value = value, .level = level }, result);
    return result;
}
