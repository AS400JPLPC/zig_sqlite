# zig-sqlite

zig 0.14.dev

I thank "[nDimensional](https://github.com/nDimensional/zig-sqlite)"
it is on this basis that I undertook to work, it remains simple, it is not a real duplication, because I updated so that it works from zig 0.14.dev.
I added some functions:

```
pub isDir( vdir : []const u8) bool ...

pub isDbxist( vdir : []const u8, fn_file_name:[]const u8) bool ...

pub open(vdir : []const u8, name: []const u8) !Database ...

pub fn open(vdir : []const u8, name: []const u8) !Database ...

pub fn openTmp(tDir: std.fs.Dir, name: []const u8) !Database ...

pub fn cbool(data : i32 ) bool ...

```

**TEST. Testsql.zig** :

a complete test cycle is made available to you
and functional.


Simple, low-level, explicitly-typed SQLite bindings for Zig.

## Table of Contents

- [Usage](#usage)
  - [Methods](#methods)
  - [Queries](#queries)
- [Notes](#notes)
- [Build options](#build-options)
- [License](#license)



Then add `sqlite` as an import to your root modules in `build.zig`:

```zig
fn build(b: *std.Build) void {
    const app = b.addExecutable(.{ ... });
    // ...

    const sqlite = b.dependency("sqlite", .{});
    app.root_module.addImport("sqlite", sqlite.module("sqlite"));
}
```

## Usage

Open databases using `Database.open` and close them with `db.close()`:

```zig
const sqlite = @import("sqlite");

{
    // in-memory database
    const db = try sql3.open("sqlite", "db.sqlite");
    defer db.close();

}

{
    // persistent database
    const db = try sqlite.Database.open(.{ .path = "path/to/db.sqlite" });
    defer db.close();
}
```


Text and blob values must not be retained across steps. **You are responsible for copying them.**

## Notes

Crafting sensible Zig bindings for SQLite involves making tradeoffs between following the Zig philosophy ("deallocation must succeed") and matching the SQLite API, in which closing databases or finalizing statements may return error codes.

This library takes the following approach:

- `Database.close` calls `sqlite3_close_v2` and panics if it returns an error code.
- `Statement.finalize` calls `sqlite3_finalize` and panics if it returns an error code.
- `Statement.step` automatically calls `sqlite3_reset` if `sqlite3_step` returns an error code.
  - In SQLite, `sqlite3_reset` returns the error code from the most recent call to `sqlite3_step`. This is handled gracefully.
- `Statement.reset` calls both `sqlite3_reset` and `sqlite3_clear_bindings`, and panics if either return an error code.

These should only result in panic through gross misuse or in extremely unusual situations, e.g. `sqlite3_reset` failing internally. All "normal" errors are faithfully surfaced as Zig errors.

## Build options

```zig
struct {
    SQLITE_ENABLE_COLUMN_METADATA: bool = false,
    SQLITE_ENABLE_DBSTAT_VTAB:     bool = false,
    SQLITE_ENABLE_FTS3:            bool = false,
    SQLITE_ENABLE_FTS4:            bool = false,
    SQLITE_ENABLE_FTS5:            bool = false,
    SQLITE_ENABLE_GEOPOLY:         bool = false,
    SQLITE_ENABLE_ICU:             bool = false,
    SQLITE_ENABLE_MATH_FUNCTIONS:  bool = false,
    SQLITE_ENABLE_RBU:             bool = false,
    SQLITE_ENABLE_RTREE:           bool = false,
    SQLITE_ENABLE_STAT4:           bool = false,
    SQLITE_OMIT_DECLTYPE:          bool = false,
    SQLITE_OMIT_JSON:              bool = false,
    SQLITE_USE_URI:                bool = false,
    SQLITE_OMIT_DEPRECATED:        bool = false,
}
```

Set these by passing e.g. `-DSQLITE_ENABLE_RTREE` in the CLI, or by setting `.SQLITE_ENABLE_RTREE = true` in the `args` parameter to `std.Build.dependency`. For example:

```zig
pub fn build(b: *std.Build) !void {
    // ...

    const sqlite = b.dependency("sqlite", .{ .SQLITE_ENABLE_RTREE = true,.SQLITE_OMIT_DEPRECATED = true  });
}
```
