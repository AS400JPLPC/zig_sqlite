const std = @import("std");

pub fn build(b: *std.Build) void {
	// Standard release options allow the person running `zig build` to select
	// between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
	const target   = b.standardTargetOptions(.{});
	const optimize = b.standardOptimizeOption(.{});
 
    // zig-src            source projet
    // zig-src/deps       curs/ form / outils ....
    // src_c              source c/c++



    // Definition of dependencies

    const zenlib_znd = b.dependency("libznd", .{});
    const zenlib_sql = b.dependency("libsql", .{});

    // Building the executable
    const Prog = b.addExecutable(.{
    .name = "Testsql",
    .root_module = b.createModule(.{
    .root_source_file =  b.path( "./Testsql.zig" ),
    .target = target,
    .optimize = optimize,
    }),
    });

 
    Prog.root_module.addImport("decimal", zenlib_znd.module("decimal"));
    Prog.root_module.addImport("sqlite", zenlib_sql.module("sqlite"));

    b.installArtifact(Prog);




}
