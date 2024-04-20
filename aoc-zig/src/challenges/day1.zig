const std = @import("std");
const File = std.fs.File;
const expect = std.testing.expect;
const equal = std.mem.eql;

pub fn solve(inputFile: []const u8) !void {
    const file = try std.fs.cwd().openFile(inputFile, .{});
    defer file.close();

    var bufferReader = std.io.bufferedReader(file.reader());
    var inputReader = bufferReader.reader();

    var part1Sum: u32 = 0;
    var part2Sum: u32 = 0;

    var buffer: [1024]u8 = undefined;
    while (try inputReader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var firstDigit: u8 = 10; // 10 is not a single digit number (it's therefor used as the placeholder here)
        var lastDigit: u8 = 10;

        var firstLetterDigit: u8 = 10;
        var lastLetterDigit: u8 = 10;

        for (line, 0..) |char, i| {
            if (char >= 48 and char <= 57) {
                const digit = char - 48;
                if (firstDigit == 10) {
                    firstDigit = digit;
                    lastDigit = digit;
                } else {
                    lastDigit = digit;
                }
                if (firstLetterDigit == 10) {
                    firstLetterDigit = digit;
                    lastLetterDigit = digit;
                } else {
                    lastLetterDigit = digit;
                }
                continue;
            }

            const letterDigit: u8 = if (checkNext(line, i, 3, "one"))
                1
            else if (checkNext(line, i, 3, "two"))
                2
            else if (checkNext(line, i, 5, "three"))
                3
            else if (checkNext(line, i, 4, "four"))
                4
            else if (checkNext(line, i, 4, "five"))
                5
            else if (checkNext(line, i, 3, "six"))
                6
            else if (checkNext(line, i, 5, "seven"))
                7
            else if (checkNext(line, i, 5, "eight"))
                8
            else if (checkNext(line, i, 4, "nine"))
                9
            else
                10;

            if (letterDigit != 10) {
                if (firstLetterDigit == 10) {
                    firstLetterDigit = letterDigit;
                    lastLetterDigit = letterDigit;
                } else {
                    lastLetterDigit = letterDigit;
                }
            }
        }

        part1Sum += firstDigit * 10 + lastDigit;
        part2Sum += firstLetterDigit * 10 + lastLetterDigit;
    }
    std.debug.print("Part 1: {} | Part 2: {}\n", .{ part1Sum, part2Sum });
}

fn checkNext(line: []u8, start: usize, len: usize, toEqual: []const u8) bool {
    if (start > line.len or start + len > line.len) return false;
    const slice = line[start .. start + len];
    return equal(u8, slice, toEqual);
}
