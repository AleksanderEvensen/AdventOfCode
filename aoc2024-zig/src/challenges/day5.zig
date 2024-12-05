const std = @import("std");
const util = @import("../util.zig");
const print = std.debug.print;

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const orders, const pages = util.splitOnce(input, "\n\n");

    var part_1: u32 = 0;
    var part_2: u32 = 0;

    var map = std.AutoHashMap(u32, std.ArrayList(u32)).init(alloc);
    defer cleanUp(&map); // Clean up the map and all arrays

    var orders_iter = util.lines(orders);
    while (orders_iter.next()) |order| {
        const left, const right = try util.splitOnceNumbers(u32, order, "|");

        var val = try map.getOrPut(left);

        if (!val.found_existing) {
            val.value_ptr.* = std.ArrayList(u32).init(alloc);
        }
        try val.value_ptr.append(right);
    }

    var pages_iter = util.lines(pages);
    while (pages_iter.next()) |page_def| {
        var page = try util.collectNumbersSeperator(u32, page_def, ",", alloc);
        defer page.deinit();

        const isInOrder = for (page.items[1..], 1..) |value, i| {
            const prev = page.items[i - 1];
            if (!is_before(prev, value, &map)) {
                break false;
            }
        } else true;

        const middle = @divFloor(page.items.len, 2);

        if (isInOrder) {
            part_1 += page.items[middle];
        } else {
            std.mem.sort(u32, page.items, &map, sort_before);
            part_2 += page.items[middle];
        }
    }

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

fn sort_before(ctx: *std.AutoHashMap(u32, std.ArrayList(u32)), left: u32, right: u32) bool {
    return is_before(left, right, ctx);
}

fn is_before(a: u32, b: u32, map: *std.AutoHashMap(u32, std.ArrayList(u32))) bool {
    if (map.get(a)) |current| {
        if (util.contains(u32, current.items, b)) {
            return true;
        }
    }
    return false;
}
fn cleanUp(map: *std.AutoHashMap(u32, std.ArrayList(u32))) void {
    var iter = map.iterator();
    while (iter.next()) |entry| {
        entry.value_ptr.deinit();
    }
    map.deinit();
}
