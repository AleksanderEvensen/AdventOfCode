const std = @import("std");
const util = @import("../util.zig");
const lib = @cImport("lib.h");
const print = std.debug.print;
const assert = std.debug.assert;

const Node = struct {
    x: isize,
    y: isize,

    pub fn antiNode(self: Node, other: Node) Node {
        return self.add(self.deltaPos(other));
    }

    pub fn deltaPos(self: Node, other: Node) Node {
        return Node{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn add(self: Node, other: Node) Node {
        return Node{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn inBounds(self: *const Node, width: isize, height: isize) bool {
        return self.x >= 0 and self.y >= 0 and self.x < width and self.y < height;
    }
};

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    var nodes = std.AutoHashMap(u8, std.ArrayList(Node)).init(alloc);
    defer {
        var keyIter = nodes.keyIterator();
        while (keyIter.next()) |key| {
            nodes.get(key.*).?.deinit();
        }
        nodes.deinit();
    }

    var antiNodes = std.AutoHashMap(Node, u1).init(alloc);
    defer antiNodes.deinit();

    var gridNodes = std.AutoHashMap(Node, u1).init(alloc);
    defer gridNodes.deinit();

    const mapHeight: isize = @intCast(lines.items.len);
    const mapWidth: isize = @intCast(lines.items[0].len);

    for (lines.items, 0..) |line, y| {
        for (line, 0..) |c, x| {
            if (c == '.') continue;

            const entry = try nodes.getOrPut(c);

            if (!entry.found_existing) {
                entry.value_ptr.* = std.ArrayList(Node).init(alloc);
            }

            try entry.value_ptr.append(Node{ .x = @intCast(x), .y = @intCast(y) });
        }
    }

    var keyIter = nodes.keyIterator();
    while (keyIter.next()) |key| {
        const value = nodes.get(key.*).?;

        for (value.items, 0..) |a, i| {
            for (value.items, 0..) |b, j| {
                if (i == j) continue;
                var anti = a.antiNode(b);
                const delta = a.deltaPos(b);
                const negated = Node{ .x = -delta.x, .y = -delta.y };
                if (anti.inBounds(mapWidth, mapHeight)) {
                    _ = try antiNodes.getOrPut(anti);
                    _ = try gridNodes.getOrPut(anti);

                    while (true) {
                        anti = anti.add(delta);
                        if (!anti.inBounds(mapWidth, mapHeight)) break;

                        _ = try gridNodes.getOrPut(anti);
                    }

                    anti = a.antiNode(b);

                    while (true) {
                        anti = anti.add(negated);
                        if (!anti.inBounds(mapWidth, mapHeight)) break;

                        _ = try gridNodes.getOrPut(anti);
                    }
                }

                _ = try gridNodes.getOrPut(a);
                _ = try gridNodes.getOrPut(b);
            }
        }
    }

    var antiIter = antiNodes.keyIterator();
    var gridIter = gridNodes.keyIterator();
    const part_1 = util.countIter(&antiIter);
    const part_2 = util.countIter(&gridIter);

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}
