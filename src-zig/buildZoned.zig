const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target   = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});


    // ===========================================================
    // 
    // Resolve the 'library' dependency.
    // const zenlib_tui = b.dependency("libtui", .{});
    const zenlib_znd = b.dependency("libznd", .{});
    // const zenlib_sql = b.dependency("libsqlite", .{});


    // Building the executable

    const Prog = b.addExecutable(.{
    .name = "Zoned",
    .root_module = b.createModule(.{
        .root_source_file = b.path( "./Zoned.zig" ),
        .target = target,
        .optimize = optimize,
    }),
    });

 
    Prog.root_module.addImport("zfield", zenlib_znd.module("zfield"));
    Prog.root_module.addImport("decimal", zenlib_znd.module("decimal"));
    Prog.root_module.addImport("datetime", zenlib_znd.module("datetime"));
    Prog.root_module.addImport("timezones", zenlib_znd.module("timezones"));    b.installArtifact(Prog);





}
