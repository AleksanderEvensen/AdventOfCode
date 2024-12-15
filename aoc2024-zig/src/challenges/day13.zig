const std = @import("std");
const util = @import("../util.zig");
const set = @import("ziglangSet");

const print = std.debug.print;
const assert = std.debug.assert;

pub fn solve(input: []const u8, alloc: std.mem.Allocator) !void {
    var equations_it = util.split(input, "\n\n");

    var part_1: isize = 0;
    var part_2: isize = 0;

    while (equations_it.next()) |equation| {
        const lines = try util.collectLines(equation, alloc);
        defer lines.deinit();

        _, const button_a = try util.splitOnce(lines.items[0], ": ");
        _, const button_b = try util.splitOnce(lines.items[1], ": ");
        const x1, const y1 = try util.splitOnce(button_a, ", ");
        const x2, const y2 = try util.splitOnce(button_b, ", ");

        const A = try util.parseInt(isize, x1[1..]);
        const B = try util.parseInt(isize, x2[1..]);
        const C = try util.parseInt(isize, y1[1..]);
        const D = try util.parseInt(isize, y2[1..]);

        const target_x, const target_y = try util.splitOnce(lines.items[2], ", ");
        const E = try util.parseInt(isize, target_x[9..]);
        const F = try util.parseInt(isize, target_y[2..]);

        const c1, const c2 = solveEq(A, B, C, D, E, F);

        if (c1 * A + c2 * B == E and c1 * C + c2 * D == F) {
            part_1 += 3 * c1 + c2;
        }

        const E2 = E + 10000000000000;
        const F2 = F + 10000000000000;
        const c1_2, const c2_2 = solveEq(A, B, C, D, E2, F2);
        if (c1_2 * A + c2_2 * B == E2 and c1_2 * C + c2_2 * D == F2) {
            part_2 += 3 * c1_2 + c2_2;
        }
    }

    print("Part 1: {d}\n", .{part_1});
    print("Part 2: {}\n", .{part_2});
}

fn solveEq(A: isize, B: isize, C: isize, D: isize, E: isize, F: isize) struct { isize, isize } {
    // Thank you so much IMAT1002
    const deternmiant = A * D - B * C;
    const c1 = D * E - B * F;
    const c2 = A * F - C * E;
    const x = @divFloor(c1, deternmiant);
    const y = @divFloor(c2, deternmiant);
    return .{ x, y };
}
