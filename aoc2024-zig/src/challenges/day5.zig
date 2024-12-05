const std = @import("std");
const print = std.debug.print;

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    var sections = std.mem.splitSequence(u8, input, "\n\n");
    const order_data = sections.next().?;
    const pages_data = sections.next().?;

    var part_1: u32 = 0;
    var part_2: u32 = 0;

    var map = std.AutoHashMap(u32, std.ArrayList(u32)).init(alloc);
    defer cleanUp(&map); // Clean up the map and all arrays

    var orders_iter = std.mem.splitScalar(u8, order_data, '\n');

    while (orders_iter.next()) |order| {
        var order_iter = std.mem.splitScalar(u8, order, '|');
        const left = try std.fmt.parseInt(u32, order_iter.next().?, 10);
        const right = try std.fmt.parseInt(u32, order_iter.next().?, 10);
        var val = try map.getOrPut(left);
        if (!val.found_existing) {
            val.value_ptr.* = std.ArrayList(u32).init(alloc);
        }
        try val.value_ptr.append(right);
    }

    var pages_iter = std.mem.splitScalar(u8, pages_data, '\n');

    while (pages_iter.next()) |page_def| {
        var page = std.ArrayList(u32).init(alloc);
        defer page.deinit();

        var page_iter = std.mem.splitScalar(u8, page_def, ',');
        while (page_iter.next()) |page_num| {
            const num = try std.fmt.parseInt(u32, page_num, 10);
            try page.append(num);
        }

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
        if (array_contains(u32, current.items, b)) {
            return true;
        }
    }
    return false;
}

fn array_contains(comptime T: type, array: []const T, value: T) bool {
    for (array) |item| {
        if (item == value) {
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
