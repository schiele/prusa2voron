$fa=1;
$fs=0.5;
type=350; // [120, "mk52", 250, 300, 350]
size=(type=="mk52")?[250, 210]:[type, type];
eps=1/128;

function logodata(a=1) = [for(p=[for(i=[0:2], j=[-1, 1]) [i-1, (i%2+1)*j],
            for(i=[-2.5:2.5], j=[i>1?0:1, i<-1?0:-1])
                [i/2/sqrt(3), 0]+j*(1/3+sqrt(3)/50)*[1, 3]])
        a/2*[p.x, p.y/sqrt(3)]];
        
module solid(s) mirror([0, 0, 1]) linear_extrude(1)
    for(i=[0, 1]) mirror([i, 0]) difference() {
        offset(r=-2.5) offset(r=5) polygon([
            [s.x/2, -s.y/2],
            [s.x/2, s.y/2],
            [ 0,  s.y/2],
            [ 0, -s.y/2-10],
            [size.x>150?40:20, -s.y/2-10],
            [size.x>150?50:30, -s.y/2]]);
        translate([37.5/(size.x>150?1:2), -s.y/2-9.5]) circle(1);
    };

module mk52() mirror([0, 0, 1]) linear_extrude(1)
    offset(r=1) offset(r=-2) offset(r=1) difference() {
        translate([0, -1.5]) offset(r=5) square([244, 231], center=true);
        for(i=[-1, 1]) translate([145.5/2*i, -234/2]) circle(d=3.5);
        hull() for(i=[-1, 1]) translate([71*i, 238/2])
            rotate(30) circle(r=4, $fn=3);
    }

function join(s, sep = "") = 
    len(s) == 0 ? "" : 
    len(s) == 1 ? str(s[0]) : 
    str(s[0], sep, join([for (i = [1 : len(s)-1]) s[i]], sep));
    
module clippv(c, s) if($preview) color(c)
    linear_extrude(eps, center=true) intersection() {
        square(s, center=true);
        translate(-s/2) children();
    }
    
module line(p1, p2, w, s) {
    echo(str("  <line x1='", p1.x, "' x2='", p2.x,
                   "' y1='", s.y-p1.y, "' y2='", s.y-p2.y,
                   "' style='fill: none; stroke: white; ",
                     "stroke-miterlimit: 10; stroke-width: ", w, ";'/>"));
    clippv("white", s) translate(p1) rotate(atan2(p2.y-p1.y, p2.x-p1.x))
        translate([0, -w/2]) square([norm(p2-p1), w]);
}

module poly(p, s) {
    echo(str("  <polygon points='", join([for(i=p) str(i.x, ",", s.y-i.y)], " "),
             "' fill='red' stroke='none' />"));
    clippv("red", s) polygon(p);
}

module svg(s) let(ld=logodata(35)) {
    echo("<?xml version='1.0' encoding='UTF-8'?>");
    echo(str("<svg id='l1' xmlns='http://www.w3.org/2000/svg' width='", s.x,
        "mm' height='", s.y, "mm' viewBox='0 0 ", s.x, " ", s.y, "'>"));
    for(i=[0, s.x]) line([i, 0], [i, s.y], 2, s);
    for(i=[10:10:s.x-eps]) {
        line([i, 0], [i, ((i>s.x-25+ld[0].x && i<s.x-25+ld[5].x)?
            (25+ld[2].y+(i-s.x+25)/sqrt(3)*sign(i-s.x+25)):s.y)],
            (i%50)?0.25:0.5, s);
        if(i>s.x-25+ld[0].x && i<s.x-25+ld[5].x)
            line([i, 25+ld[3].y-(i-s.x+25)/sqrt(3)*sign(i-s.x+25)], [i, s.y],
                (i%50)?0.25:0.5, s);
    }
    for(i=[0, s.y]) line([0, i], [s.x, i], 2, s);
    for(i=[10:10:s.y-eps]) {
        line([0, i], [s.x-((i>25+ld[2].y && i<25+ld[3].y)?
            (25+((i>25+ld[0].y && i<25+ld[5].y)?
            ld[5].x:2*ld[5].x-(i-25)*sqrt(3)*sign(i-25))):0), i],
            (i%50)?0.25:0.5, s);
        if(i>25+ld[2].y && i<25+ld[3].y)
            line([s.x-(25+((i>25+ld[0].y && i<25+ld[5].y)?
                ld[0].x:2*ld[0].x+(i-25)*sqrt(3)*sign(i-25))), i], [s.x, i],
                (i%50)?0.25:0.5, s);
        }
    for(i=[6:4:14]) poly([for(p=[for(j=[0, 1, 3, 2]) ld[i+j]]) [s.x-25, 25]+p], s);
    echo("</svg>");
}

color("#3f3f3f") if(type=="mk52") mk52(); else solid(size);
svg(size);
