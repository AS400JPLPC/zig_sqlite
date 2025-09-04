//----------------------
//---test Sqlite     ---
//----------------------

const std = @import("std");
const zfld = @import("zfield").ZFIELD;
const dcml = @import("decimal").DCMLFX;
pub const dte = @import("datetime").DATE;
pub const dtm = @import("datetime").DTIME;
pub const Idm = @import("datetime").DATE.Idiom;
pub const Tmz = @import("timezones");
const sql3 = @import("sqlite");

const allocSQL = std.heap.page_allocator;


//============================================================================================
var out = std.fs.File.stdout().writerStreaming(&.{});
pub inline fn Print( comptime format: []const u8, args: anytype) void {
    out.interface.print(format, args) catch return;
}
pub inline fn WriteAll( args: anytype) void {
    out.interface.writeAll(args) catch return;
}


fn Pause(msg : [] const u8 ) void{

    Print("\nPause  {s}\r\n",.{msg});
    var stdin = std.fs.File.stdin();
    var buf: [16]u8 =  [_]u8{0} ** 16;
    var c  : usize = 0;
    while (c == 0) {
        c = stdin.read(&buf) catch unreachable;
   }
}   
//============================================================================================

pub const contact = struct {
  id        : i32,
  name      : zfld ,
  prenom    : zfld ,
  rue1      : zfld ,
  rue2      : zfld ,
  ville     : zfld ,
  pays      : zfld ,
  base      : dcml ,
  taxe      : dcml ,
  htx       : dcml ,
  ttc       : dcml ,
  date      : dte  ,
  nbritem   : dcml ,
  ok        : bool,
  

   // defined structure and set ""
    pub fn initRecord() contact {

        
        const rcd = contact {
            .id = 0,
            .name   = zfld.init(30) ,      
            .prenom = zfld.init(20) ,
            .rue1   = zfld.init(30) ,
            .rue2   = zfld.init(30) ,
            .ville  = zfld.init(20) ,
            .pays   = zfld.init(15) ,
            .base   = dcml.init(5,2) ,      
            .taxe   = dcml.init(1,2)  ,
            .htx    = dcml.init(11,2) ,
            .ttc    = dcml.init(30,4)  ,
            .nbritem  = dcml.init(5,0) ,
            .date   = dte.nowDate(Tmz.Europe.Paris),
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
        r.date.dateOff();
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
WriteAll("\x1b[2J");
WriteAll("\x1b[3J");



    var client  = contact.initRecord();

    Pause("start");
    client.name.setZfld("AS400JPLPC");
    client.prenom.setZfld("Jean-Pierre");
    client.rue1.setZfld(" 01 rue du sud-ouest");
    client.ville.setZfld("Narbonne");
    client.pays.setZfld("France");
    client.base.setDcml("126.12");
    client.nbritem.setDcml("12345");
    client.taxe.setDcml("1.25");

    
    const db = try sql3.open("sqlite", "db.REPzoned", sql3.Mode.ReadWrite);
    defer db.close();

// To work in extended digital (DCML) put the TEXT fields
    if (! db.istable("Zoned")) {

        Pause("isTable");
        try db.exec(
        \\ CREATE TABLE "Zoned" (
    	\\ "id"      INTEGER,
    	\\ "name"    TEXT NOT NULL,
    	\\ "prenom"  TEXT NOT NULL,
    	\\ "rue1"    TEXT NOT NULL,
    	\\ "rue2"    TEXT,
    	\\ "ville"   TEXT NOT NULL,
    	\\ "pays"    TEXT NOT NULL,
    	\\ "base"    NUMERIC,
    	\\ "taxe"    NUMERIC,
    	\\ "htx"     NUMERIC,
    	\\ "ttc"     NUMERIC,
    	\\ "nbritem" NUMERIC,
    	\\ "date"    DATE,
    	\\ "ok" BOOL CHECK("ok" IN (0, 1)),
    	\\ PRIMARY KEY("id" AUTOINCREMENT))
        , .{});
    }

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

    if (db.istable("Zoned")) {

        // autoincrement
        // We describe all the fields except the one that increments.
        // Otherwise no need to describe the fields: by default all.
        const insert = try db.prepare(
            clientSql,
            void,
        \\INSERT INTO Zoned (id, name,prenom,rue1,rue2,ville,pays,base,taxe,htx,ttc,nbritem,date,ok)
        \\VALUES(:id, :name, :prenom, :rue1, :rue2, :ville, :pays, :base, :taxe, :htx, :ttc, :nbritem, :date, :ok)
        ,);
        defer insert.finalize();   
 
       
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




    client.ttc.setZeros();
    client.ok = false;
   // UPDATE  where name ="AS400JPLPC"
    {
        // for test value ttc big decimal check finance Force quoted values for DCML  
        const sqlUpdate : []const u8 = std.fmt.allocPrint(allocSQL,
            "UPDATE Zoned SET (ttc,ok)=(\"{s}\",{d}) WHERE name='{s}'",
                .{client.ttc.string(),sql3.cbool(client.ok),client.name.string(),})
                catch {@panic("init Update invalide");};
        defer allocSQL.free(sqlUpdate);
        Pause(sqlUpdate);
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

             std.log.info("--------------------------",.{});       
        }


    }


    client.ttc.rate(client.base,client.nbritem,client.taxe);
    client.ok = true;
    client.date.dateOff();

    // UPDATEd id = 1
    {
        // for test value ttc big decimal check finance Force quoted values for DCML  
   client.ttc.setDcml("912345678901234567890123456789.0123");
        const sqlUpdate : []const u8 = std.fmt.allocPrint(allocSQL,
            "UPDATE Zoned SET (name,ttc,date,ok)=('{s}', \"{s}\", \"{s}\", {d}) WHERE id='{d}'",
                .{"COUCOU",client.ttc.string(),client.date.string(),sql3.cbool(client.ok),1,})
                catch {@panic("init Update invalide");};
        defer allocSQL.free(sqlUpdate);
        Pause(sqlUpdate);
        try db.exec(sqlUpdate,.{});

        std.log.info("--------------------------",.{});
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

        try select.bind(.{.key = 1});
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
        std.log.info("--------------------------",.{}); 
    }




    zfld.deinitZfld();
    dcml.deinitDcml();
    dte.deinitDate();
    Pause("stop");
}

