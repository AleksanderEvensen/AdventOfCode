const std = @import("std");
const util = @import("../util.zig");
const set = @import("ziglangSet");

const print = std.debug.print;
const assert = std.debug.assert;

const Pos = struct {
    x: isize,
    y: isize,
};

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const map, const instructions = try util.splitOnce(input, "\n\n");

    var obstacles = set.Set(Pos).init(alloc);
    defer obstacles.deinit();
    var crates = std.ArrayList(Pos).init(alloc);
    defer crates.deinit();

    var start_pos: Pos = undefined;

    const lines = try util.collectLines(map, alloc);
    defer lines.deinit();
    for (lines.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            switch (char) {
                'O' => {
                    try crates.append(Pos{ .x = @intCast(x), .y = @intCast(y) });
                },
                '#' => {
                    _ = try obstacles.add(Pos{ .x = @intCast(x), .y = @intCast(y) });
                },
                '@' => {
                    start_pos = Pos{ .x = @intCast(x), .y = @intCast(y) };
                },
                else => undefined,
            }
        }
    }

    var inst_it = util.lines(instructions);
    while (inst_it.next()) |line| {
        for (line) |char| {
            switch (char) {
                '<' => try move(&start_pos, &crates, &obstacles, -1, 0),
                '>' => try move(&start_pos, &crates, &obstacles, 1, 0),
                '^' => try move(&start_pos, &crates, &obstacles, 0, -1),
                'v' => try move(&start_pos, &crates, &obstacles, 0, 1),
                else => undefined,
            }
        }
    }

    var part_1: isize = 0;

    for (crates.items) |crate| {
        part_1 += crate.x + crate.y * 100;
    }

    const part_2 = 0;

    print("Part 1: {d}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

fn move(start_pos: *Pos, crates: *std.ArrayList(Pos), obstacles: *set.Set(Pos), dx: isize, dy: isize) !void {
    const new_pos = Pos{ .x = start_pos.x + dx, .y = start_pos.y + dy };

    if (obstacles.contains(new_pos)) return;

    var crate_index: ?usize = null;
    for (crates.items, 0..) |it, i| {
        if (it.x == new_pos.x and it.y == new_pos.y) {
            crate_index = i;
        }
    }
    if (crate_index) |index| {
        const crate = crates.*.items[index];
        var new_crate_pos = Pos{ .x = crate.x + dx, .y = crate.y + dy };
        while (util.contains(Pos, crates.items, new_crate_pos)) {
            new_crate_pos.x += dx;
            new_crate_pos.y += dy;
        }

        if (!obstacles.contains(new_crate_pos)) {
            crates.*.items[index] = new_crate_pos;
            start_pos.* = new_pos;
        }
    } else {
        start_pos.* = new_pos;
    }
}
