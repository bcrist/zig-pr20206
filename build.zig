const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "make_depfile",
        .root_source_file = b.path("make_depfile.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    const run_cmd = b.addRunArtifact(exe);
    _ = run_cmd.addDepFileOutputArg("deps.d");

    const step = b.step("repro", "trigger FileNotFound from depfile");
    step.dependOn(&run_cmd.step);
}
