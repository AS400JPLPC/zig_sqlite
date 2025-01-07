const std = @import("std");

pub fn build(b: *std.Build) void {
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target   = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ===========================================================
    // 
    // Resolve the 'library' dependency.
    const zenlib_dep = b.dependency("library", .{});
    const zenlib_sql = b.dependency("libsql", .{});

    // Building the executable

    const Prog = b.addExecutable(.{
    .name = "Zsqlite",
    .root_source_file = b.path( "./Zsqlite.zig" ),
    .target = target,
    .optimize = optimize,
    });

 
    Prog.root_module.addImport("decimal", zenlib_dep.module("decimal"));
    Prog.root_module.addImport("zfield", zenlib_dep.module("zfield"));
    Prog.root_module.addImport("sqlite", zenlib_sql.module("sqlite"));


    b.installArtifact(Prog);





}
