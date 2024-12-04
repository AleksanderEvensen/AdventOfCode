const std = @import("std");
const print = std.debug.print;

const Point = struct {
    x: i32,
    y: i32,
};

pub fn solve(input: []const u8, allocator: std.mem.Allocator) !void {
    var map = std.AutoHashMap(Point, u8).init(allocator);
    defer map.deinit();

    var iter = std.mem.splitScalar(u8, input, '\n');
    var y: i32 = 0;
    while (iter.next()) |line| {
        defer y += 1;
        for (line, 0..) |char, x| {
            try map.put(.{ .x = @intCast(x), .y = y }, char);
        }
    }

    var part_1: usize = 0;
    var part_2: usize = 0;

    var keys = map.keyIterator();
    while (keys.next()) |pos| {
        const char = map.get(pos.*) orelse unreachable;

        if (char == 'X') {
            var horiz_buffer = [_]u8{ 'X', undefined, undefined, undefined };
            var vert_buffer = [_]u8{ 'X', undefined, undefined, undefined };
            var diagdown_buffer = [_]u8{ 'X', undefined, undefined, undefined };
            var diagup_buffer = [_]u8{ 'X', undefined, undefined, undefined };

            var cursor: i32 = -3;
            while (cursor <= 3) : (cursor += 1) {
                const horiz = map.get(.{ .x = pos.x + cursor, .y = pos.y }) orelse 0;
                const vert = map.get(.{ .x = pos.x, .y = pos.y + cursor }) orelse 0;
                const diagdown = map.get(.{ .x = pos.x + cursor, .y = pos.y + cursor }) orelse 0;
                const diagup = map.get(.{ .x = pos.x + cursor, .y = pos.y - cursor }) orelse 0;

                const buf_pos: usize = @intCast(if (cursor < 0) -cursor else cursor);

                horiz_buffer[buf_pos] = horiz;
                vert_buffer[buf_pos] = vert;
                diagdown_buffer[buf_pos] = diagdown;
                diagup_buffer[buf_pos] = diagup;

                if (cursor == 0) {
                    const dirs = [_][4]u8{ horiz_buffer, vert_buffer, diagdown_buffer, diagup_buffer };
                    for (dirs) |dir| {
                        if (std.mem.eql(u8, &dir, "XMAS")) {
                            part_1 += 1;
                        }
                    }
                    horiz_buffer = [_]u8{ 'X', undefined, undefined, undefined };
                    vert_buffer = [_]u8{ 'X', undefined, undefined, undefined };
                    diagdown_buffer = [_]u8{ 'X', undefined, undefined, undefined };
                    diagup_buffer = [_]u8{ 'X', undefined, undefined, undefined };
                }
            }

            const dirs = [_][4]u8{ horiz_buffer, vert_buffer, diagdown_buffer, diagup_buffer };
            for (dirs) |dir| {
                if (std.mem.eql(u8, &dir, "XMAS")) {
                    part_1 += 1;
                }
            }
        }

        if (char == 'A') {
            const top_left = map.get(.{ .x = pos.x - 1, .y = pos.y - 1 }) orelse 0;
            const top_right = map.get(.{ .x = pos.x + 1, .y = pos.y - 1 }) orelse 0;
            const bottom_left = map.get(.{ .x = pos.x - 1, .y = pos.y + 1 }) orelse 0;
            const bottom_right = map.get(.{ .x = pos.x + 1, .y = pos.y + 1 }) orelse 0;

            const diagdown = [_]u8{ top_left, char, bottom_right };
            const diagup = [_]u8{ bottom_left, char, top_right };

            if (std.mem.eql(u8, &diagdown, "MAS") or std.mem.eql(u8, &diagdown, "SAM")) {
                if (std.mem.eql(u8, &diagup, "MAS") or std.mem.eql(u8, &diagup, "SAM")) {
                    part_2 += 1;
                }
            }
        }
    }

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}
