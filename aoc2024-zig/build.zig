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

    const mibu_dep = b.dependency("mibu", .{
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("mibu", mibu_dep.module("mibu"));

    const ziglangSet = b.dependency("ziglangSet", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("ziglangSet", ziglangSet.module("ziglangSet"));

    b.installArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
