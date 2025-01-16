//----------------------
//---test zoned field---
//----------------------



const std = @import("std");
const zfld = @import("zfield");

const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub const contact = struct {
  name      : zfld.ZFIELD  ,
  prenom    : zfld.ZFIELD  ,
  rue1      : zfld.ZFIELD  ,
  rue2      : zfld.ZFIELD  ,
  ville     : zfld.ZFIELD  ,
  pays      : zfld.ZFIELD  ,
  

  // defined structure and set ""
    pub fn initRecord() contact {

        
        const rcd = contact {
            .name   = zfld.ZFIELD.init(30) ,
            .prenom = zfld.ZFIELD.init(20) ,
            .rue1   = zfld.ZFIELD.init(30) ,
            .rue2   = zfld.ZFIELD.init(30) ,
            .ville  = zfld.ZFIELD.init(20) ,
            .pays   = zfld.ZFIELD.init(15) ,
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
    pause("setp-1   INIT value"); 

    var xx = friend.name.string();
    pause(xx);
    xx = friend.prenom.string();
    pause(xx);
    xx = friend.rue1.string();
    pause(xx);
    xx = friend.ville.string();
    pause(xx);
    xx = friend.pays.string();
    pause(xx);
    
    pause("step-2");

    friend.name.uppercase();
    xx = friend.name.string();
    pause(xx);

    friend.name.debugContext();

    friend.name.clear();
    friend.name.debugContext();
    pause("step-X");
    friend.name.setZfld("AS400JPLPC") catch unreachable;

    std.debug.print("{} cmpeql\n",.{friend.name.cmpeql("test")});
    
    std.debug.print("{} cmpxx\n",.{friend.name.cmpxx("test")});

    std.debug.print("name check:{}\n",.{friend.name.check()});
    
    xx = friend.prenom.getSubstr(1,4) catch | err | { std.debug.print("{}",.{err}) ; return ; };
    std.debug.print("{s}  getSubstr:{s} \n",.{friend.prenom.string(),xx});

    friend.ville.concat(" 11100") catch | err | { std.debug.print("{}",.{err}); return; };

    std.debug.print("{s} ville  check:{} \n",.{friend.ville.string(), friend.ville.check()});
    friend.ville.debugContext();
      

    friend.name.setFull("AS400JPLPC111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111") catch unreachable;
    friend.prenom.debugContext();
     _=friend.prenom.replace("Jean",friend.name.string()) catch | err | { std.debug.print("{}",.{err}); return; };
    pause("replace prenom");
     std.debug.print("prenom check:{} \n",.{friend.prenom.check()});
    friend.prenom.debugContext();
    std.debug.print("{s}  prenom check:{} \n",.{friend.prenom.string(),friend.prenom.check()});
    //the string normalize function always
    xx = friend.prenom.string();
    pause(xx);
    friend.prenom.setZfld("Jean-Pierre") catch unreachable;




    
    friend.deinitRecord();

    pause("step-3  deinitRecord");

    zfld.deinitZfld();
 
    // zfld.ZFIELD.arenaZfld.deinit();
    pause("stop");
}




fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
   	var buf : [3]u8  =	[_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}
