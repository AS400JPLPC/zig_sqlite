const std = @import("std");
const sql3 = @import("sqlite");



pub fn main () ! void {



    std.debug.print("dir exits {}\n",.{sql3.isDir("sqlitex") });
    std.debug.print("db  exits {}\n",.{sql3.isDbxist("sqlite","db.sqlitex") });
    


    const db = try sql3.open("sqlite", "db.sqlite");
    defer db.close();
    
    {
         std.debug.print("name:{s} istable:{s}   {}\n", .{ "db.sqlite" ,"users",try db.istable("users")});
         std.debug.print("name:{s} istable:{s}   {}\n", .{ "db.sqlite" ,"xxxxusers",try db.istable("xxxxusers")});
    }

    const User = struct { id: sql3.Text, age: ?i32, isok: i32 };


    // The BOOL specification is purely indicative, as SQLite will see it as an integer
    if (! try db.istable("users") ) {
        try db.exec(
            \\ CREATE TABLE users (
            \\ id TEXT NOT NULL UNIQUE,
            \\ age INTEGER,
            \\ isok BOOL CHECK(isok IN(0,1)),
            \\ PRIMARY KEY(id));
            , .{});


        const insert = try db.prepare(
            User,
            void,
            "INSERT INTO users VALUES (:id, :age, :isok)",
        );
        defer insert.finalize();
    

        try db.exec("INSERT INTO users VALUES(\"a\", 21,true )", .{});
        try db.exec("INSERT INTO users VALUES(\"b\", 23, false)", .{});
        try db.exec("INSERT INTO users VALUES(\"c\", NULL, true)", .{});
    }
    
    // Test SELECT first
    {
        const select1 = try db.prepare(
            struct { min: i32 },
            User,
            "SELECT * FROM users WHERE age >= :min",
        );
        defer select1.finalize();


        // Get a single row
         try select1.bind(.{ .min = 0 });
        defer select1.reset();

        if (try select1.step()) |user| {
            std.log.info(" if select .min = 0   {s} age: {d}  tst OK:{}",
                .{ user.id.data, user.age orelse 0,user.isok});
        }
    }


    // Test SELECT
    {
        const select2 = try db.prepare(
            struct {},
            User,
            "SELECT * FROM users ",
        );
        defer select2.finalize();
       // Iterate again, full

        try select2.bind(.{});
        defer select2.reset();

        while (try select2.step()) |user| {
            std.log.info("while select FULL   {s} age: {d}  tst OK:{}", .{user.id.data, user.age orelse 0,user.isok} );
        }
    }


    {
        const select3 = try db.prepare(
            struct { val: i32 },
            User,
            "SELECT * FROM users WHERE age == :val",
        );
        defer select3.finalize();
    // Iterate again, with different params
        try select3.bind(.{ .val = 21 });
        defer select3.reset();

        while (try select3.step()) |user| {
            std.log.info("while select .val = 21   {s} age: {d}  tst OK:{}",
                .{ user.id.data, user.age orelse 0,user.isok} );
        }
    }


    {
         const select4 = try db.prepare(
            struct {},

            User,
            "SELECT * FROM users WHERE age is null",
        );
        // Iterate over all rows is null
        try select4.bind(.{});
        defer select4.reset();

        while (try select4.step()) |user| {
            std.log.info("while select NULL   {s} age: {any}  tst OK:{}",
                .{ user.id.data, user.age ,user.isok} );
        }
    }


    // UPDATE
    {
        const allocator = std.heap.page_allocator;
        const sqlUpdate : []const u8 = std.fmt.allocPrint(allocator,
            "UPDATE users SET age = {d} WHERE id = \"{s}\"",.{55,"a" }) catch {@panic("init Update invalide");};
        defer allocator.free(sqlUpdate);
        try db.exec(sqlUpdate,.{});    
    }



    // DELETE
    {
        const allocator = std.heap.page_allocator;
        const sqlDelete : []const u8 = std.fmt.allocPrint(allocator,
            "DELETE FROM users  WHERE id = \"{s}\"",.{"b" }) catch {@panic("init Delete invalide");};
        defer allocator.free(sqlDelete);
        try db.exec(sqlDelete,.{});    
    }
     // Control UPDATE
    {
        const select5 = try db.prepare(
            struct { val: sql3.Text},
            User,
            "SELECT * FROM users WHERE id == :val",
        );
        defer select5.finalize();
        // Iterate again, with different params
        try select5.bind(.{ .val = sql3.text("a") });
        defer select5.reset();

        while (try select5.step()) |user| {
            std.log.info("while select .val = 21   {s} age: {d}  tst OK:{}",
                 .{ user.id.data, user.age orelse 0,user.isok} );
        }
    }

    try deserialize();
 } 


fn deserialize () ! void {
    const allocator = std.heap.c_allocator;

    var tmp = std.testing.tmpDir(.{});
    defer tmp.cleanup();

    const db1 = try sql3.openTmp(tmp.dir, "db.sqlite");
    defer db1.close();

    try db1.exec("CREATE TABLE Tusers (id INTEGER PRIMARY KEY)", .{});
    try db1.exec("INSERT INTO Tusers VALUES (:id)", .{ .id = @as(usize, 0) });
    try db1.exec("INSERT INTO Tusers VALUES (:id)", .{ .id = @as(usize, 1) });

    const file = try tmp.dir.openFile("db.sqlite", .{});
    defer file.close();

    const data = try file.readToEndAlloc(allocator, 4096 * 8);
    defer allocator.free(data);

    const db2 = try sql3.Database.import(data);
    defer db2.close();

    const User = struct { id: usize };
    var rows = std.ArrayList(User).init(allocator);
    defer rows.deinit();

    const stmt = try db2.prepare(struct {}, User, "SELECT id FROM Tusers");
    defer stmt.finalize();

    try stmt.bind(.{});
    defer stmt.reset();
    var x : u32 =5;
    while (try stmt.step()) |row| {
         x += 1;
         var upd = row;
         upd.id = x;
        try rows.append(upd);
    }

    try std.testing.expectEqualSlices(User, &.{ .{ .id = 6 }, .{ .id = 7 } }, rows.items);
    std.log.info("User id1:{d}  id2:{d}", .{ rows.items[0].id, rows.items[1].id} );
 }
