    ///-----------------------
    /// build Test
    /// zig 0.14.0 dev
    ///-----------------------

const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target   = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});


    // ===========================================================

     const zfield   = b.dependency("libznd", .{}).module("zfield");


    // Building the executable

    const Prog = b.addExecutable(.{
    .name = "Testmem",
    .root_source_file = b.path( "./Testmem.zig" ),
    .target = target,
    .optimize = optimize,
    });


    Prog.root_module.addImport("zfield", zfield);



    b.installArtifact(Prog);

}
