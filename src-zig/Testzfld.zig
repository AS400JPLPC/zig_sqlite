//----------------------
//---date text----------
//----------------------



const std = @import("std");

const zfld = @import("zfield");

const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();


pub fn main() !void {



var nom = zfld.ZFIELD.init(30) ;
var nom2 = zfld.ZFIELD.init(10) ;
var xx : [] const u8 = undefined;

        try nom.setZfld("早上好 test 🔥");
        std.debug.print("setZfld {s}  len:{d}  capacity:{d}   nbrc:{d}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc()});

        try nom.setZfld("t1234567890123456789012345678Z");
        std.debug.print("setZfld {s}  len:{d}  capacity:{d}   nbrc:{d}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc()});

        try nom.setFull("t1234567890123456789012345678z1234azertyuiop");
        std.debug.print("setZfld {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc()});

        xx = nom.string();
        std.debug.print("string XX {s}  len:{d}  capacity:{d}    nbrc:{d}  \n\rXX:{s}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc(), xx});


        
        try nom.setFull("t€é1234567890123456789012345678z1234");
        std.debug.print("setZfld {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc()});

        xx = try nom.getSubstr(5,10);
        std.debug.print("getsubStr(5,10) {s} len:{d}  capacity:{d}    nbrc:{d}  \n\rXX:{s}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc(), xx});


        nom.clear();
        try nom.setZfld("t€é123456789012345678901234567");
        std.debug.print("setZfld {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc()});
        
var nom3 = try nom.clone();
        std.debug.print("clone {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom.concat(nom2.string());
        std.debug.print("concat {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc()});

        nom.reverse();
        std.debug.print("setZfld {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom.string(), nom.len(), nom.capacity(),  nom.getnbc()});

        try nom3.setZfld("jean pierre");
        nom3.uppercase();
        std.debug.print("upperStr {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        nom3.lowercase();
        std.debug.print("lowerStr {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld("pédalier");
        nom3.uppercase();
        std.debug.print("upperStr {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        nom3.lowercase();
        std.debug.print("lowerStr {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld("pédalier");
        nom3.capitalized();
        std.debug.print("toCapitalized {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld("été");
        nom3.capitalized();
        std.debug.print("toCapitalized {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        
        try nom3.setZfld("jean pierre");
        nom3.capitalized();
        std.debug.print("toCapitalized {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld(" jean pierre ");
        nom3.capitalized();
        std.debug.print("toCapitalized {s}  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld(" jean pierre ");
        nom3.trimStart(" ");
        std.debug.print("trimStart >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld(" jean pierre ");
        nom3.trimEnd(" ");
        std.debug.print("trimEnd >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld(" jean pierre ");
        nom3.trim(" ");
        std.debug.print("trim >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});


        _= try nom3.replace("pierre", "marie");
        std.debug.print("replace >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        _= try nom3.replace("pierre", "toto");
        std.debug.print("replace >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        _= try nom3.remove(1);
        std.debug.print("remove 1 >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        _= try nom3.remove(10);
        std.debug.print("remove 10 >{s}<  len:{d}  capacity:{d}    nbrc:{d}  {}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc(),try nom3.remove(10)});

        _= try nom3.remove(nom3.capacity());
        std.debug.print("remove 9 >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        _= try nom3.remove(0);
        std.debug.print("remove 1 >{s}<  len:{d}  capacity:{d}    nbrc:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc()});

        try nom3.setZfld(" jean pierre ");
        var  n = nom3.find("e") ;
        std.debug.print("find >{s}<  len:{d}  capacity:{d}    nbrc:{d} find:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc() , n});

        n = nom3.rfind("e") ;
        std.debug.print("rfind >{s}<  len:{d}  capacity:{d}    nbrc:{d} find:{d}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc() , n});

        var val : []const u8 = undefined;
        const val_else = "";
        val = nom3.pop() orelse  val_else;
        std.debug.print("pop >{s}<  len:{d}  capacity:{d}    nbrc:{d} val:{any}\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc(), val});        

        nom3.clear();
        val = nom3.pop() orelse  val_else;
        std.debug.print("pop >{s}<  len:{d}  capacity:{d}    nbrc:{d} val:>{s}<\n\r",
            .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc(), val});

pause("step-1");
zfld.deinitZfld();


var testa = zfld.ZFIELD.init(10) ;
var testb = zfld.ZFIELD.init(10) ;
xx= "coucou";

    try testa.setZfld("coucou");
    std.debug.print("cmpeql({s},{s})  {}\n\r",.{testa.string(),xx,testa.cmpeql(xx)});
    
    try testb.setZfld("coucou");
    std.debug.print("cmpeql({s},{s})  {}\n\r",.{testa.string(),testb.string(),testa.cmpeql(testb.string())});

    std.debug.print("cmpxx({s},{s})  {s}\n\r",.{testa.string(),testb.string(),@tagName(testa.cmpxx(testb.string()))});
    
    try testb.setZfld("aaaaaa");
    std.debug.print("cmpxx({s},{s})  {s}\n\r",.{testa.string(),testb.string(),@tagName(testa.cmpxx(testb.string()))});

    try testb.setZfld("yaaaaa");
    std.debug.print("cmpxx({s},{s})  {s}\n\r",.{testa.string(),testb.string(),@tagName(testa.cmpxx(testb.string()))});

    std.debug.print("chek nom3 >{s}<  len:{d}  capacity:{d}    nbrc:{d}  check:{}\n\r",
                .{nom3.string(), nom3.len(), nom3.capacity(),  nom3.getnbc(), nom3.check()});


zfld.deinitZfld();

pause("stop");

}

fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
   	var buf : [3]u8  =	[_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}
