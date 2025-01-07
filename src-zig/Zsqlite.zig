//----------------------
//---test Sqlite     ---
//----------------------


const std = @import("std");
const zfld = @import("zfield");
const dcml = @import("decimal");
const sql3 = @import("sqlite");


const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub const contact = struct {
  id        : i32,
  name      : zfld.ZFIELD  ,
  prenom    : zfld.ZFIELD  ,
  rue1      : zfld.ZFIELD  ,
  rue2      : zfld.ZFIELD  ,
  ville     : zfld.ZFIELD  ,
  pays      : zfld.ZFIELD  ,
  base      : dcml.DCMLFX  ,
  taxe      : dcml.DCMLFX  ,
  htx       : dcml.DCMLFX  ,
  ttc       : dcml.DCMLFX  ,
  date      : zfld.ZFIELD  ,
  nbritem   : dcml.DCMLFX  ,
  ok        : bool,
  

  // defined structure and set ""
    pub fn initRecord() contact {

        
        const rcd = contact {
            .id = 0,
            .name   = zfld.ZFIELD.init(30) ,      
            .prenom = zfld.ZFIELD.init(20) ,
            .rue1   = zfld.ZFIELD.init(30) ,
            .rue2   = zfld.ZFIELD.init(30) ,
            .ville  = zfld.ZFIELD.init(20) ,
            .pays   = zfld.ZFIELD.init(15) ,
            .base   = dcml.DCMLFX.init(5,2) ,      
            .taxe   = dcml.DCMLFX.init(1,2)  ,
            .htx    = dcml.DCMLFX.init(11,2) ,
            .ttc    = dcml.DCMLFX.init(30,4)  ,
            .nbritem  = dcml.DCMLFX.init(5,0) ,
            .date   = zfld.ZFIELD.init(10) ,
            .ok = true,
        };
        
        return rcd;      
    }

    pub fn deinitRecord( r : *contact) void {
        r.id = 0;
        r.name.deinit();
        r.prenom.deinit();
        r.rue1.deinit();
        r.rue2.deinit();
        r.ville.deinit();
        r.pays.deinit();
        r.base.deinit();
        r.taxe.deinit();
        r.htx.deinit();
        r.ttc.deinit();
        r.nbritem.deinit();
        r.date.deinit();
        r.ok = false;
    }


};


// var arenaSql3 = std.heap.ArenaAllocator.init(std.heap.page_allocator);
// var allocSql3 = arenaSql3.allocator();
// pub fn deinitSql3() void {
//     arenaSql3.deinit();
//     arenaSql3 = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//     allocSql3 = arenaSql3.allocator();
// }
    
pub fn main() !void {
stdout.writeAll("\x1b[2J") catch {};
stdout.writeAll("\x1b[3J") catch {};



var client  = contact.initRecord();

    pause("start");

    client.name.setZfld("AS400JPLPC") catch unreachable;
    client.prenom.setZfld("Jean-Pierre") catch unreachable;
    client.rue1.setZfld(" 01 rue du sud-ouest") catch unreachable;
    client.ville.setZfld("Narbonne") catch unreachable;
    client.pays.setZfld("France") catch unreachable;
    client.base.setDcml("126.12") catch unreachable;
    client.nbritem.setDcml("12345") catch unreachable;
    client.taxe.setDcml("1.25") catch unreachable;
    
    
    pause("setp-1   INIT value"); 

    var xx = client.name.string();
    pause(xx);


    client.ttc.rate(client.base,client.nbritem,client.taxe) catch | err | dcml.dsperr(err);

    xx = client.ttc.string();

    client.htx.multTo(client.base,client.nbritem) catch | err | dcml.dsperr(err);
    pause(xx);

 
    // only test
    client.date.setZfld("2025-01-07") catch unreachable;


    const clientSql = struct {

        id:?i32,// autoincrement
        name: sql3.Text,
        prenom: sql3.Text,
        rue1: sql3.Text,
        rue2: sql3.Text,
        ville: sql3.Text,
        pays: sql3.Text,
        base: sql3.Numeric,
        taxe: sql3.Numeric,
        htx: sql3.Numeric,
        ttc: sql3.Numeric,
        nbritem: sql3.Numeric,
        date: sql3.Date,
        ok: sql3.Bool
        };
    
    const db = try sql3.open("sqlite", "zoned.db");
    defer db.close();

// To work in extended digital (DCML) put the TEXT fields
    if (! try db.istable("Zoned")) {
        try db.exec(
        \\ CREATE TABLE "Zoned" (
    	\\ "id"    INTEGER,
    	\\ "name"    TEXT NOT NULL,
    	\\ "prenom"  TEXT NOT NULL,
    	\\ "rue1"    TEXT NOT NULL,
    	\\ "rue2"    TEXT,
    	\\ "ville"   TEXT NOT NULL,
    	\\ "pays"    TEXT NOT NULL,
    	\\ "base"    TEXT,
    	\\ "taxe"    TEXT,
    	\\ "htx"     TEXT,
    	\\ "ttc"     TEXT,
    	\\ "nbritem" TEXT,
    	\\ "date"    TEXT,
    	\\ "ok" BOOL CHECK("ok" IN (0, 1)),
    	\\ PRIMARY KEY("id" AUTOINCREMENT);
        , .{});
    }


    if (try db.istable("Zoned")) {

        // autoincrement
        // We describe all the fields except the one that increments.
        // Otherwise no need to describe the fields: by default all.
        const insert = try db.prepare(
            clientSql,
            void,
        \\INSERT INTO Zoned (id, name,prenom,rue1,rue2,ville,pays,base,taxe,htx,ttc,nbritem,date,ok)
        \\VALUES(:id, :name, :prenom, :rue1, :rue2, :ville, :pays, :base, :taxe, :htx, :ttc, :nbritem, :date, :ok)
        );
        defer insert.finalize();
// pause("prepare");
        
        try insert.exec(.{
            .id = null,
            .name = sql3.text(client.name.string()),
            .prenom = sql3.text(client.prenom.string()),
            .rue1  = sql3.text(client.rue1.string()),
            .rue2  = sql3.text(client.rue2.string()),
            .ville = sql3.text(client.ville.string()),
            .pays = sql3.text(client.pays.string()),
            .base = sql3.numeric(client.base.string()),
            .taxe = sql3.numeric(client.taxe.string()),
            .htx  = sql3.numeric(client.htx.string()),
            .ttc  = sql3.numeric(client.ttc.string()),
            .nbritem = sql3.numeric(client.nbritem.string()),
            .date = sql3.date(client.date.string()),
            .ok = sql3.boolean(client.ok),
             });

 
}
   // // UPDATE
    {
        // for test value ttc big decimal check finance Force quoted values for DCML  
        const allocator = std.heap.page_allocator;
        const sqlUpdate : []const u8 = std.fmt.allocPrint(allocator,
            "UPDATE Zoned SET (name,ttc,ok)=('{s}', \"{s}\",{d}) WHERE id='{d}'",
                .{client.name.string(),client.ttc.string(),sql3.cbool(client.ok),25,})
                catch {@panic("init Update invalide");};
        defer allocator.free(sqlUpdate);
        pause(sqlUpdate);
        try db.exec(sqlUpdate,.{});
    }

    // Test SELECT
    {

         const select = try db.prepare(
            struct {},
            clientSql,
            "SELECT * FROM Zoned ",
        );
        defer select.finalize();
       // Iterate again, full

        try select.bind(.{});
        defer select.reset();

        while (try select.step()) |rcd| {
            std.log.info(
                \\id:{d}
                \\name:{s} prenom: {s}
                \\rue1:{s} rue2:{s}
                \\ville:{s} pays:{s}
                \\base:{s} taxe:{s} htx:{s} ttc:{s} nbritem:{s}
                \\date:{s}
                \\ok:{}
                , .{rcd.id orelse 0,
                    rcd.name.data, rcd.prenom.data, rcd.rue1.data, rcd.rue2.data, rcd.ville.data, rcd.pays.data,
                    rcd.base.data, rcd.taxe.data, rcd.htx.data, rcd.ttc.data, rcd.nbritem.data,
                    rcd.date.data , rcd.ok.data} );
            client.id = rcd.id orelse 0;
            client.ok = false;
            
        }


    }


    // // UPDATE
    {
        // for test value ttc big decimal check finance Force quoted values for DCML  
   client.ttc.setDcml("912345678901234567890123456789.0123") catch unreachable;
        const allocator = std.heap.page_allocator;
        const sqlUpdate : []const u8 = std.fmt.allocPrint(allocator,
            "UPDATE Zoned SET (name,ttc,ok)=('{s}', \"{s}\",{d}) WHERE id='{d}'",
                .{"COUCOU",client.ttc.string(),sql3.cbool(client.ok),25,})
                catch {@panic("init Update invalide");};
        defer allocator.free(sqlUpdate);
        pause(sqlUpdate);
        try db.exec(sqlUpdate,.{});
    }
    
    // Test SELECT
    {

         const select = try db.prepare(
            struct {key : i32},
            clientSql,
            "SELECT * FROM Zoned WHERE id=:key",
        );
        defer select.finalize();
       // Iterate again, full

        try select.bind(.{.key = 25});
        defer select.reset();

        while (try select.step()) |rcd| {
            std.log.info(
                \\id:{d}
                \\name:{s} prenom: {s}
                \\rue1:{s} rue2:{s}
                \\ville:{s} pays:{s}
                \\base:{s} taxe:{s} htx:{s} ttc:{s} nbritem:{s}
                \\date:{s}
                \\ok:{}
                , .{rcd.id orelse 0,
                    rcd.name.data, rcd.prenom.data, rcd.rue1.data, rcd.rue2.data, rcd.ville.data, rcd.pays.data,
                    rcd.base.data, rcd.taxe.data, rcd.htx.data, rcd.ttc.data, rcd.nbritem.data,
                    rcd.date.data , rcd.ok.data} );
             
        }


    }
     
    zfld.deinitZfld();
    dcml.deinitDcml();
    pause("stop");
}


fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
   	var buf : [3]u8  =	[_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}

