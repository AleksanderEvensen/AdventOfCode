const std = @import("std");
const util = @import("../util.zig");
const set = @import("ziglangSet");

const print = std.debug.print;
const assert = std.debug.assert;

const Robot = struct {
    x: isize,
    y: isize,
    dx: isize,
    dy: isize,

    pub fn simulate(self: *Robot, mapWidth: isize, mapHeight: isize) void {
        self.x += self.dx;
        self.y += self.dy;

        if (self.x < 0) {
            self.x += mapWidth;
        }

        if (self.y < 0) {
            self.y += mapHeight;
        }

        if (self.x >= mapWidth) {
            self.x -= mapWidth;
        }

        if (self.y >= mapHeight) {
            self.y -= mapHeight;
        }
    }
};

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    var lines = util.lines(input);

    var robots = std.ArrayList(Robot).init(alloc);
    defer robots.deinit();

    const mapWidth: usize = 101;
    const mapHeight: usize = 103;

    while (lines.next()) |line| {
        const pos, const vel = try util.splitOnce(line, " ");
        const x, const y = try util.splitOnceNumbers(isize, pos[2..], ",");
        const dx, const dy = try util.splitOnceNumbers(isize, vel[2..], ",");

        try robots.append(Robot{ .x = x, .y = y, .dx = dx, .dy = dy });
    }

    for (0..100) |_| {
        for (robots.items, 0..) |_, i| {
            robots.items[i].simulate(@intCast(mapWidth), @intCast(mapHeight));
        }
    }

    const part_1: usize = calculateDanger(robots.items, mapWidth, mapHeight);

    var time: usize = 101;
    var minDanger = calculateDanger(robots.items, mapWidth, mapHeight);
    var minTime: usize = time;
    while (time - minTime < 10000) {
        defer time += 1;
        for (robots.items, 0..) |_, i| {
            robots.items[i].simulate(@intCast(mapWidth), @intCast(mapHeight));
        }

        const danger = calculateDanger(robots.items, mapWidth, mapHeight);
        if (danger < minDanger) {
            minDanger = danger;
            minTime = time;
        }
    }

    const part_2 = minTime;

    print("Part 1: {d}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

fn calculateDanger(robots: []Robot, mapWidth: usize, mapHeight: usize) usize {
    var quadrant = [_]usize{ 0, 0, 0, 0 };
    for (robots) |robot| {
        if (robot.x < @divFloor(mapWidth, 2)) {
            if (robot.y < @divFloor(mapHeight, 2)) {
                quadrant[0] += 1;
            }
            if (robot.y > @divFloor(mapHeight, 2)) {
                quadrant[2] += 1;
            }
        }
        if (robot.x > @divFloor(mapWidth, 2)) {
            if (robot.y < @divFloor(mapHeight, 2)) {
                quadrant[1] += 1;
            }
            if (robot.y > @divFloor(mapHeight, 2)) {
                quadrant[3] += 1;
            }
        }
    }

    return quadrant[0] * quadrant[1] * quadrant[2] * quadrant[3];
}
