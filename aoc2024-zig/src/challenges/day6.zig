const std = @import("std");
const util = @import("../util.zig");
const print = std.debug.print;

const Position = struct {
    x: i32,
    y: i32,

    pub fn add(self: *Position, other: Position) Position {
        self.x += other.x;
        self.y += other.y;
    }

    pub fn Add(self: Position, other: Position) Position {
        return Position{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn eql(self: Position, other: Position) bool {
        return self.x == other.x and self.y == other.y;
    }

    pub fn withinBounds(self: *Position, width: usize, height: usize) bool {
        return self.x >= 0 and self.x < width and self.y >= 0 and self.y < height;
    }
};

const Direction = enum {
    Up,
    Down,
    Left,
    Right,

    pub fn toPosition(self: Direction) Position {
        return switch (self) {
            Direction.Up => Position{ .x = 0, .y = -1 },
            Direction.Down => Position{ .x = 0, .y = 1 },
            Direction.Left => Position{ .x = -1, .y = 0 },
            Direction.Right => Position{ .x = 1, .y = 0 },
        };
    }

    pub fn turnLeft(self: Direction) Direction {
        return switch (self) {
            Direction.Up => Direction.Left,
            Direction.Left => Direction.Down,
            Direction.Down => Direction.Right,
            Direction.Right => Direction.Up,
        };
    }

    pub fn turnRight(self: Direction) Direction {
        return switch (self) {
            Direction.Up => Direction.Right,
            Direction.Right => Direction.Down,
            Direction.Down => Direction.Left,
            Direction.Left => Direction.Up,
        };
    }
};

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    var obstacles = std.AutoHashMap(Position, bool).init(alloc);
    defer obstacles.deinit();

    var start_pos = Position{ .x = 0, .y = 0 };

    const mapHeight = lines.items.len;
    const mapWidth = lines.items[0].len;

    for (lines.items, 0..) |line, y| {
        for (line, 0..) |char, x| {
            if (char == '^') {
                start_pos = Position{ .x = @intCast(x), .y = @intCast(y) };
            }

            if (char == '#') {
                const pos = Position{ .x = @intCast(x), .y = @intCast(y) };
                try obstacles.put(pos, true);
            }
        }
    }

    var unique_pos = std.AutoHashMap(Position, bool).init(alloc);
    defer unique_pos.deinit();

    var current_direction = Direction.Up;
    var guard_pos = Position{ .x = start_pos.x, .y = start_pos.y };
    while (guard_pos.withinBounds(mapWidth, mapHeight)) {
        const next_pos = guard_pos.Add(current_direction.toPosition());

        if (obstacles.contains(next_pos)) {
            current_direction = current_direction.turnRight();
        } else {
            guard_pos = next_pos;
            try unique_pos.put(guard_pos, true);
        }
    }

    var part_2: usize = 0;

    var keyIter = unique_pos.keyIterator();
    while (keyIter.next()) |pos| {
        if (pos.eql(start_pos)) continue;

        var visited = std.AutoHashMap(Position, Direction).init(alloc);
        defer visited.deinit();

        guard_pos = Position{ .x = start_pos.x, .y = start_pos.y };
        current_direction = Direction.Up;
        const doesLoop = looping: while (guard_pos.withinBounds(mapWidth, mapHeight)) {
            const next_pos = guard_pos.Add(current_direction.toPosition());

            if (pos.eql(next_pos) or obstacles.contains(next_pos)) {
                const entry = try visited.getOrPut(guard_pos);
                if (entry.found_existing) {
                    if (entry.value_ptr.* == current_direction) {
                        break :looping true;
                    }
                } else {
                    entry.value_ptr.* = current_direction;
                }
                current_direction = current_direction.turnRight();
            } else {
                guard_pos = next_pos;
            }
        } else false;
        if (doesLoop) {
            part_2 += 1;
        }
    }

    keyIter = unique_pos.keyIterator();
    const part_1: usize = util.countIter(&keyIter);

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}
