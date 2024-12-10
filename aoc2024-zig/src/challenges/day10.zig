const std = @import("std");
const util = @import("../util.zig");
const lib = @cImport("lib.h");
const mibu = @import("mibu");

const print = std.debug.print;
const assert = std.debug.assert;
const color = mibu.color;

const Position = struct {
    x: i32,
    y: i32,
};

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    var height_map = std.AutoHashMap(Position, u8).init(alloc);
    defer height_map.deinit();

    var ranking = std.AutoHashMap(Position, std.ArrayList(Position)).init(alloc);
    var total_hikes = std.AutoHashMap(Position, usize).init(alloc);

    defer {
        var top_iter = ranking.iterator();
        while (top_iter.next()) |entry| {
            entry.value_ptr.deinit();
        }
        ranking.deinit();
    }

    var bottom_positions = std.ArrayList(Position).init(alloc);

    for (lines.items, 0..) |line, y| {
        for (0..line.len) |x| {
            const height = try util.parseInt(u8, line[x..(x + 1)]);

            const pos = Position{ .x = @intCast(x), .y = @intCast(y) };

            if (height == 0) {
                try bottom_positions.append(pos);
            }

            try height_map.put(pos, height);
        }
    }

    for (bottom_positions.items) |pos| {
        try findTrailHeads(pos, pos, &height_map, &ranking, &total_hikes);
    }

    var part_1: usize = 0;

    var ranking_iter = ranking.iterator();
    while (ranking_iter.next()) |entry| {
        part_1 += entry.value_ptr.items.len;
    }

    var part_2: usize = 0;

    var total_iter = total_hikes.iterator();
    while (total_iter.next()) |entry| {
        part_2 += entry.value_ptr.*;
    }

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

pub fn findTrailHeads(start_pos: Position, pos: Position, height_map: *std.AutoHashMap(Position, u8), heads: *std.AutoHashMap(Position, std.ArrayList(Position)), total: *std.AutoHashMap(Position, usize)) !void {
    const current_height = height_map.get(pos) orelse 0;

    if (current_height == 9) {
        const entry = try heads.getOrPut(start_pos);
        if (!entry.found_existing) entry.value_ptr.* = std.ArrayList(Position).init(heads.allocator);
        if (!util.contains(Position, entry.value_ptr.items, pos)) {
            try entry.value_ptr.*.append(pos);
        }

        const entry_total = try total.getOrPut(start_pos);
        if (!entry_total.found_existing) entry_total.value_ptr.* = 0;
        entry_total.value_ptr.* += 1;
    }

    const neighbours = try getValidNeighbours(pos, height_map);
    for (neighbours.items) |neighbour| {
        try findTrailHeads(start_pos, neighbour, height_map, heads, total);
    }
}

pub fn findTrailHeadsTracked(start_pos: Position, pos: Position, height_map: *std.AutoHashMap(Position, u8), visited: *std.AutoHashMap(Position, bool)) !void {
    try visited.put(pos, true);

    const neighbours = try getValidNeighbours(pos, height_map);
    for (neighbours.items) |neighbour| {
        try findTrailHeadsTracked(start_pos, neighbour, height_map, visited);
    }
}

pub fn getValidNeighbours(pos: Position, height_map: *std.AutoHashMap(Position, u8)) !std.ArrayList(Position) {
    var neighbours = std.ArrayList(Position).init(height_map.allocator);

    const current_height = height_map.get(pos) orelse 0;

    const directions = [_]Position{ Position{ .x = 0, .y = -1 }, Position{ .x = 0, .y = 1 }, Position{ .x = -1, .y = 0 }, Position{ .x = 1, .y = 0 } };

    for (directions) |direction| {
        const neighbour = Position{ .x = pos.x + direction.x, .y = pos.y + direction.y };

        if (height_map.get(neighbour)) |n| {
            if (n == current_height + 1) {
                try neighbours.append(neighbour);
            }
        }
    }

    return neighbours;
}
