const std = @import("std");

const Color = enum { Red, Green, Blue };

const Dice = struct {
    count: u8,
    color: Color,
};

pub fn solve(inputFile: []const u8) !void {
    const file = try std.fs.cwd().openFile(inputFile, .{});
    defer file.close();

    var bufferReader = std.io.bufferedReader(file.reader());
    var inputReader = bufferReader.reader();

    var part1: u32 = 0;
    var part2: u32 = 0;

    var lineBuf: [1024]u8 = undefined;
    while (try inputReader.readUntilDelimiterOrEof(&lineBuf, '\n')) |line| {
        var lineStream = std.io.fixedBufferStream(line);
        var lineReader = lineStream.reader();

        try lineReader.skipBytes("Game ".len, .{});

        var buf: [1024]u8 = undefined;
        const GameIdStr = try lineReader.readUntilDelimiter(&buf, ':');
        const GameId = try std.fmt.parseInt(u8, GameIdStr, 10);

        var maxRed: u8 = 0;
        var maxGreen: u8 = 0;
        var maxBlue: u8 = 0;

        while (try lineReader.readUntilDelimiterOrEof(&buf, ';')) |set| {
            var setStream = std.io.fixedBufferStream(set);
            var setReader = setStream.reader();

            var setBuf: [128]u8 = undefined;
            setLoop: while (try setReader.readUntilDelimiterOrEof(&setBuf, ',')) |diceType| {
                var num: u8 = 0;
                for (diceType) |char| {
                    const color = switch (char) {
                        '0'...'9' => {
                            const digit = try std.fmt.charToDigit(char, 10);
                            num *= 10;
                            num += digit;
                            continue;
                        },
                        'r' => Color.Red,
                        'g' => Color.Green,
                        'b' => Color.Blue,
                        else => continue,
                    };

                    switch (color) {
                        .Red => if (num > maxRed) {
                            maxRed = num;
                        },
                        .Green => if (num > maxGreen) {
                            maxGreen = num;
                        },
                        .Blue => if (num > maxBlue) {
                            maxBlue = num;
                        },
                    }

                    continue :setLoop;
                }
            }
        }

        if (maxRed <= 12 and maxGreen <= 13 and maxBlue <= 14) {
            part1 += GameId;
        }
        part2 += @as(u32, maxRed) * @as(u32, maxBlue) * @as(u32, maxGreen);
    }

    std.debug.print("Part 1: {} | Part 2: {}\n", .{ part1, part2 });
}
