const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //-------------------------------------------------------------------------
    // ZLS Dev Tool LSP
    //  - can be skipped if you have zls installed globally
    //-------------------------------------------------------------------------

    const zls = b.dependency("zls", .{}).artifact("zls");
    const zls_step = b.step("build-zls", "Build zls");
    b.installArtifact(zls);
    zls_step.dependOn(&zls.step);

    const run_zls_step = b.step("zls", "Run zls");
    const run_zls = b.addRunArtifact(zls);
    const install_zls = b.addInstallArtifact(zls, .{});
    run_zls_step.dependOn(&zls.step);
    run_zls_step.dependOn(&run_zls.step);
    run_zls_step.dependOn(&install_zls.step);

    //-------------------------------------------------------------------------
    // Main App
    //-------------------------------------------------------------------------

    const exe = b.addExecutable(.{
        .name = "my-app",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
