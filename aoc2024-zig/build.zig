const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "aoc2024-zig",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_cmd = b.addRunArtifact(exe);

    const dependencies = [_][]const u8{
        "mibu",
        "ziglangSet",
        "regex",
    };
    for (dependencies) |dep_name| {
        const dep = b.dependency(dep_name, .{
            .target = target,
            .optimize = optimize,
        });
        exe.root_module.addImport(dep_name, dep.module(dep_name));
    }

    b.installArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
