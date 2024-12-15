const std = @import("std");
const util = @import("../util.zig");
const set = @import("ziglangSet");

const print = std.debug.print;
const assert = std.debug.assert;

const Pos = struct {
    x: isize,
    y: isize,
    character: u8,

    pub fn new(x: isize, y: isize, character: u8) Pos {
        return Pos{ .x = x, .y = y, .character = character };
    }

    pub fn fromUsize(x: usize, y: usize, character: u8) Pos {
        return Pos{ .x = @intCast(x), .y = @intCast(y), .character = character };
    }

    pub fn x_usize(self: Pos) usize {
        return @intCast(self.x);
    }
    pub fn y_usize(self: Pos) usize {
        return @intCast(self.y);
    }

    pub fn cmpX(_: @TypeOf(.{}), a: Pos, b: Pos) bool {
        return a.x < b.x;
    }

    pub fn cmpY(_: @TypeOf(.{}), a: Pos, b: Pos) bool {
        return a.y < b.y;
    }
};

const SideKey = struct {
    x: isize,
    y: isize,
};

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    var visited = set.Set(Pos).init(alloc);

    var part_1: usize = 0;
    var part_2: usize = 0;

    for (lines.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            const pos = Pos.fromUsize(x, y, char);
            if (visited.contains(pos)) {
                continue;
            }
            _ = try visited.add(pos);
            var sides = std.AutoHashMap(SideKey, std.ArrayList(Pos)).init(alloc);
            defer {
                var it = sides.iterator();
                while (it.next()) |entry| {
                    entry.value_ptr.deinit();
                }
                sides.deinit();
            }
            const area, const circumference = try getFarmLands(pos, lines.items, &visited, &sides);

            var side_count: usize = 0;
            var side_it = sides.iterator();
            while (side_it.next()) |entry| {
                const k = entry.key_ptr;

                if (k.x == 0) {
                    std.mem.sort(Pos, entry.value_ptr.*.items, .{}, Pos.cmpX);
                } else if (k.y == 0) {
                    std.mem.sort(Pos, entry.value_ptr.*.items, .{}, Pos.cmpY);
                }

                side_count += 1;
                for (entry.value_ptr.*.items[1..], 1..) |current, i| {
                    const prev = entry.value_ptr.*.items[i - 1];

                    if (i == 1) {}
                    const diff = if (k.x == 0) (current.x - prev.x) else (current.y - prev.y);
                    const diff2 = if (k.x == 0) (current.y - prev.y) else (current.x - prev.x);
                    if (diff != 1 or diff2 != 0) {
                        side_count += 1;
                    }
                }
            }

            part_1 += area * circumference;
            part_2 += area * side_count;
        }
    }

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

fn getFarmLands(pos: Pos, lines: [][]const u8, visited: *set.Set(Pos), sides: *std.AutoHashMap(SideKey, std.ArrayList(Pos))) !struct { usize, usize } {
    const width = lines[0].len - 1;
    const height = lines.len - 1;

    var circumference: usize = 0;
    var area: usize = 1;

    var neighours: [4]?Pos = undefined;

    if (pos.x > 0) neighours[0] = Pos.new(pos.x - 1, pos.y, lines[pos.y_usize()][pos.x_usize() - 1]);
    if (pos.x < width) neighours[1] = Pos.new(pos.x + 1, pos.y, lines[pos.y_usize()][pos.x_usize() + 1]);
    if (pos.y > 0) neighours[2] = Pos.new(pos.x, pos.y - 1, lines[pos.y_usize() - 1][pos.x_usize()]);
    if (pos.y < height) neighours[3] = Pos.new(pos.x, pos.y + 1, lines[pos.y_usize() + 1][pos.x_usize()]);

    for (neighours, 0..) |entry, i| {
        if (entry) |neighbour| {
            if (neighbour.character != pos.character) {
                try addSide(sides, pos, i);
                circumference += 1;
                continue;
            }
            if (visited.contains(neighbour)) continue;

            _ = try visited.add(neighbour);

            const a, const c = try getFarmLands(neighbour, lines, visited, sides);
            circumference += c;
            area += a;
        } else {
            try addSide(sides, pos, i);
            circumference += 1;
        }
    }

    return .{ area, circumference };
}

fn addSide(sides: *std.AutoHashMap(SideKey, std.ArrayList(Pos)), pos: Pos, index: usize) !void {
    const key = switch (index) {
        // Top
        2 => SideKey{ .x = 0, .y = pos.y * 10 - 5 },
        // Bottom
        3 => SideKey{ .x = 0, .y = pos.y * 10 + 5 },
        // Left
        0 => SideKey{ .x = pos.x * 10 - 5, .y = 0 },
        // Right
        1 => SideKey{ .x = pos.x * 10 + 5, .y = 0 },
        else => unreachable,
    };

    const entry = try sides.getOrPut(key);
    if (!entry.found_existing) {
        entry.value_ptr.* = std.ArrayList(Pos).init(sides.allocator);
    }

    try entry.value_ptr.append(pos);
}
