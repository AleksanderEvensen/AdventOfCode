const std = @import("std");
const util = @import("../util.zig");
const print = std.debug.print;
const assert = std.debug.assert;

const Block = struct {
    value: usize,
    count: usize,
    free: usize,
};

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    const lines = try util.collectLines(input, alloc);
    defer lines.deinit();

    const disk_map = try createDiskMap(input, alloc);
    var block_map = try createBlockMap(input, alloc);
    defer disk_map.deinit();
    defer block_map.deinit();

    for (0..disk_map.items.len) |i| {
        if (disk_map.items[i] == null) {
            const last_index = getLastFileIndex(disk_map.items);
            if (last_index == i - 1) break;
            disk_map.items[i] = disk_map.items[last_index];
            disk_map.items[last_index] = null;
        }

        if (disk_map.items[i] == null) break;
    }

    var part_1: usize = 0;
    for (disk_map.items, 0..) |value, i| {
        part_1 += i * (value orelse 0);
    }

    var i: usize = block_map.items.len - 1;
    while (i > 0) {
        const block = block_map.items[i];

        if (getFirstFreeSpaceThatFitsLength(block_map.items[0..i], block.count)) |block_index| {
            block_map.items[i - 1].free += block.count + block.free;

            var to_append = block_map.orderedRemove(i);
            to_append.free = block_map.items[block_index].free - to_append.count;
            try block_map.insert(block_index + 1, to_append);
            block_map.items[block_index].free = 0;
        } else {
            i -= 1;
        }
    }

    var part_2: usize = 0;
    var b_i: usize = 0;
    for (block_map.items) |block| {
        for (block.count) |_| {
            part_2 += b_i * block.value;
            b_i += 1;
        }
        for (block.free) |_| {
            b_i += 1;
        }
    }

    print("Part 1: {}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

pub fn createDiskMap(input: []const u8, alloc: std.mem.Allocator) !std.ArrayList(?usize) {
    var disk_map = std.ArrayList(?usize).init(alloc);

    var i: usize = 0;
    var file_index: usize = 0;
    while (i < input.len) : (i += 1) {
        const is_file = i % 2 == 0;
        const count = try util.parseInt(usize, input[i..(i + 1)]);
        for (0..count) |_| {
            try disk_map.append(if (is_file) file_index else null);
        }

        file_index += if (is_file) 1 else 0;
    }

    return disk_map;
}

pub fn createBlockMap(input: []const u8, alloc: std.mem.Allocator) !std.ArrayList(Block) {
    var disk_map = std.ArrayList(Block).init(alloc);

    var i: usize = 0;
    var file_index: usize = 0;
    while (i < input.len) : (i += 1) {
        defer file_index += 1;
        const count = try util.parseInt(usize, input[i..(i + 1)]);
        var block = Block{
            .value = file_index,
            .count = count,
            .free = 0,
        };
        defer disk_map.append(block) catch unreachable;

        if (i + 1 >= input.len) break;
        i += 1;
        const free_count = try util.parseInt(usize, input[i..(i + 1)]);
        block.free = free_count;
    }
    return disk_map;
}

pub fn getLastFileIndex(disk_map: []?usize) usize {
    var i = disk_map.len - 1;
    while (disk_map[i] == null) : (i -= 1) {}
    return i;
}

pub fn getFirstFreeSpaceThatFitsLength(block_map: []Block, length: usize) ?usize {
    var i: usize = 0;
    while (i < block_map.len) : (i += 1) {
        if (block_map[i].free >= length) {
            return i;
        }
    }
    return null;
}

pub fn printBlockMap(block_map: []Block) void {
    for (block_map) |block| {
        for (0..block.count) |_| {
            print("{}", .{block.value});
        }

        for (0..block.free) |_| {
            print(".", .{});
        }
    }
    print("\n", .{});
}
