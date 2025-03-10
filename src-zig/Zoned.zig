//----------------------
//---test zoned field---
//----------------------



const std = @import("std");
const zfld = @import("zfield").ZFIELD;
const dcml = @import("decimal").DCMLFX;
pub const dte = @import("datetime").DATE;
pub const dtm = @import("datetime").DTIME;
pub const tmz = @import("timezones");
pub const idm = @import("datetime").DATE.Idiom;
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();
const allocSQL = std.heap.page_allocator;
pub const contact = struct {
  name      : zfld,
  prenom    : zfld,
  rue1      : zfld,
  rue2      : zfld,
  ville     : zfld,
  pays      : zfld,
  base      : dcml,
  taxe      : dcml,
  htx       : dcml,
  ttc       : dcml,
  nbritem   : dcml,
  dfacture  : dte,
 

  // defined structure and set ""
    pub fn initRecord() contact {

        
        const rcd = contact {
            .name   = zfld.init(30) ,      
            .prenom = zfld.init(20) ,
            .rue1   = zfld.init(30) ,
            .rue2   = zfld.init(30) ,
            .ville  = zfld.init(20) ,
            .pays   = zfld.init(15) ,
            .base   = dcml.init(13,2) ,      
            .taxe   = dcml.init(1,2)  ,
            .htx    = dcml.init(25,2) ,
            .ttc    = dcml.init(25,2)  ,
            .nbritem  = dcml.init(15,0) ,
            .dfacture = dte.nowDate(tmz.Europe.Paris),
        };
        
        return rcd;      
    }

    pub fn deinitRecord( r : *contact) void {
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
        r.dfacture.dateOff();
    }


};
    
pub fn main() !void {
stdout.writeAll("\x1b[2J") catch {};
stdout.writeAll("\x1b[3J") catch {};



var friend  = contact.initRecord();

    pause("start");

    friend.name.setZfld("AS400JPLPC");
    friend.prenom.setZfld("Jean-Pierre");
    friend.rue1.setZfld(" 01 rue du sud-ouest");
    friend.ville.setZfld("Narbonne");
    friend.pays.setZfld("France");
    friend.base.setDcml("10000");
    friend.nbritem.setDcml("1");
    friend.taxe.setDcml("1.20");
    
    
    pause("setp-1   INIT value"); 

    var xx = friend.name.string();
    pause(xx);


    friend.ttc.rate(friend.base,friend.nbritem,friend.taxe) ;

    xx = friend.ttc.string();

    friend.htx.multTo(friend.base,friend.nbritem) ;
    xx = friend.ttc.string();
    pause(xx);

    xx = friend.dfacture.stringFR(allocSQL);
    pause(xx);

    xx = friend.dfacture.dateExt(allocSQL,idm.fr);
    pause(xx);

    //friend.deinitRecord();  //Test erreur
    xx = friend.dfacture.string(allocSQL);
    pause(xx);
    

    xx = friend.dfacture.dateExt(allocSQL,idm.fr);
    pause(xx);

    if (!friend.dfacture.status) std.debug.print("date de facture {}\n",.{null});
    zfld.deinitZfld();
    dcml.deinitDcml();

    friend  = contact.initRecord();
    xx = friend.dfacture.stringFR(allocSQL);
    pause(xx);
    
    pause("stop");
}




fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
   	var buf : [3]u8  =	[_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}

