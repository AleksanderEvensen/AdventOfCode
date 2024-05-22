const std = @import("std");
const utils = @import("../utils.zig");
const print = std.debug.print;

pub fn solve(inputFile: []const u8) !void {
    const fileContent = try utils.readFile(inputFile);

    var it = std.mem.tokenizeAny(u8, fileContent, "\n");

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var grid = std.ArrayList([]const u8).init(allocator);
    defer grid.deinit();

    while (it.next()) |line| {
        try grid.append(line);
    }

    var gearMap = std.AutoHashMap([2]usize, [2]usize).init(allocator);
    defer gearMap.deinit();

    var part1: usize = 0;
    var part2: usize = 0;

    var currentNumber: usize = 0;
    var isAttachedToSymbol = false;
    var isAttachedToGear = false;

    var gearPos: [2]usize = .{ 0, 0 };

    for (grid.items, 0..) |row, y| {
        for (row, 0..) |char, x| {
            if (!std.ascii.isDigit(char)) {
                if (currentNumber != 0) {
                    if (isAttachedToSymbol) {
                        part1 += currentNumber;
                    }
                    if (isAttachedToGear) {
                        const entry = try gearMap.getOrPut(gearPos);
                        const value = entry.value_ptr;
                        if (!entry.found_existing) {
                            value.* = .{ currentNumber, 0 };
                        } else {
                            if (value.*[1] != 0) {
                                // since we only want gears with exactly 2 values
                                // we just set the first one to 0 if more than 2 values is detected
                                // that way when the gear ratio is calculated it will not be added in the calculation
                                value.*[0] = 0;
                            }
                            value.*[1] = currentNumber;
                        }
                    }
                    currentNumber = 0;
                    isAttachedToSymbol = false;
                    isAttachedToGear = false;
                }
                continue;
            }

            currentNumber *= 10;
            currentNumber += char - '0';

            var yOffset: isize = -1;
            while (yOffset <= 1) : (yOffset += 1) {
                var xOffset: isize = -1;
                while (xOffset <= 1) : (xOffset += 1) {
                    if (yOffset == 0 and xOffset == 0) continue;
                    const cY: isize = @as(isize, @intCast(y)) + yOffset;
                    const cX: isize = @as(isize, @intCast(x)) + xOffset;
                    if (cY < 0 or cX < 0) continue;
                    if (cY >= grid.items.len or cX >= row.len) continue;
                    const checkChar = grid.items[@as(usize, @intCast(cY))][@as(usize, @intCast(cX))];

                    if (std.ascii.isDigit(checkChar) or checkChar == '.') continue;
                    isAttachedToSymbol = true;
                    if (checkChar == '*') {
                        isAttachedToGear = true;
                        gearPos = .{ @as(usize, @intCast(cY)), @as(usize, @intCast(cX)) };
                    }
                }
            }
        }

        if (currentNumber != 0) {
            if (isAttachedToSymbol) {
                part1 += currentNumber;
            }
            currentNumber = 0;
            isAttachedToSymbol = false;
            isAttachedToGear = false;
        }
    }

    var iter = gearMap.iterator();
    while (iter.next()) |entry| {
        const gearRatio = entry.value_ptr.*[0] * entry.value_ptr.*[1];
        part2 += gearRatio;
    }

    std.debug.print("Part 1: {} | Part 2: {}\n", .{ part1, part2 });
}
