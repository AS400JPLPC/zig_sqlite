//----------------------
//---test zoned field---
//----------------------



const std = @import("std");
const zfld = @import("zfield");
const dcml = @import("decimal");

const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub const contact = struct {
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
  nbritem   : dcml.DCMLFX  ,
  

  // defined structure and set ""
    pub fn initRecord() contact {

        
        const rcd = contact {
            .name   = zfld.ZFIELD.init(30) ,      
            .prenom = zfld.ZFIELD.init(20) ,
            .rue1   = zfld.ZFIELD.init(30) ,
            .rue2   = zfld.ZFIELD.init(30) ,
            .ville  = zfld.ZFIELD.init(20) ,
            .pays   = zfld.ZFIELD.init(15) ,
            .base   = dcml.DCMLFX.init(13,2) ,      
            .taxe   = dcml.DCMLFX.init(1,2)  ,
            .htx    = dcml.DCMLFX.init(25,2) ,
            .ttc    = dcml.DCMLFX.init(25,2)  ,
            .nbritem  = dcml.DCMLFX.init(15,0) ,
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
    }


};
    
pub fn main() !void {
stdout.writeAll("\x1b[2J") catch {};
stdout.writeAll("\x1b[3J") catch {};



var friend  = contact.initRecord();

    pause("start");

    friend.name.setZfld("AS400JPLPC") catch unreachable;
    friend.prenom.setZfld("Jean-Pierre") catch unreachable;
    friend.rue1.setZfld(" 01 rue du sud-ouest") catch unreachable;
    friend.ville.setZfld("Narbonne") catch unreachable;
    friend.pays.setZfld("France") catch unreachable;
    friend.base.setDcml("10000") catch unreachable;
    friend.nbritem.setDcml("1") catch unreachable;
    friend.taxe.setDcml("1.20") catch unreachable;
    
    
    pause("setp-1   INIT value"); 

    var xx = friend.name.string();
    pause(xx);


    friend.ttc.rate(friend.base,friend.nbritem,friend.taxe) catch | err | dcml.dsperr(err);

    xx = friend.ttc.string();

    friend.htx.multTo(friend.base,friend.nbritem) catch | err | dcml.dsperr(err);
    xx = friend.ttc.string();
    pause(xx);

    
    zfld.deinitZfld();
    dcml.deinitDcml();
    pause("stop");
}




fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
   	var buf : [3]u8  =	[_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}

