$fn = 10;
include<honeycomb.scad>
include<nutsnbolts/cyl_head_bolt.scad>

parts = "usb-drawer";
keyring = false;
length = 85;        //space between the screws
width = 30;
thickness = 3.5;    //thickness of the main parts

//bevel of main part
bevel_height = 1.2;
bevel_offset = 1.2;
//bevel of finger holes
finger_bevel_height = 1.2;
finger_bevel_offset = 1.2;
middle_hole_bevel = true;

honeycomb_pattern_offset = 8;
hex_segments = 6;
hex_pattern_thickness = 1;
hex_pattern_width = 18.9;

//indented or outdented
usb_text_style = "out";

//epsilon (prevents flickering), don't change unless you know what you're doing
e = 0.001;

your_text = "free as in freedom (CC-BY-SA)";

module FlashDriveDrawer() {
    //a is the legth of one side of the hexagon of the main parts
    a = width*sin(30);
    echo(str("a = ", a));
    dx = cos(30)*(a/2);
    echo(str("dx = ", dx));
    dy = sin(30)*(a/2);

    difference()
    {
        cylinder(6.6, d=width, $fn=6);
        translate([0,0,-e])cylinder(thickness*2,d=4);
        translate([-5.95,0,1])cube([11.9,20,4.6]);
        if(usb_text_style == "indented" || usb_text_style == "in")
        {
          translate([width/2-dy,dx,3.3]) rotate([90,0,120])translate([0,0,-0.49])linear_extrude(height = .5)text("USB",4,halign="center", valign="center");
          translate([-width/2+dy,dx,3.3])rotate([90,0,-120])translate([0,0,-0.49])linear_extrude(height = 0.5)text("USB",4,halign="center", valign="center");
        }
    }
    if(usb_text_style == "outdented" || usb_text_style == "out")
    {
      translate([width/2-dy,dx,3.3]) rotate([90,0,120])translate([0,0,0])linear_extrude(height = .5)text("USB",4,halign="center", valign="center");
      translate([-width/2+dy,dx,3.3])rotate([90,0,-120])translate([0,0,0])linear_extrude(height = 0.5)text("USB",4,halign="center", valign="center");
    }

}

module MainPart(part)
{
  difference() {
      union()
      {
        //main part
        hull()
        {
          //big lower part of bevel
          translate([0,0,0])cylinder(thickness-bevel_height, d=width, $fn=6);
          translate([0,length,0])cylinder(thickness-bevel_height, d=width, $fn=6);
          //small upper part of bevel
          translate([0,0,thickness-bevel_height])cylinder(bevel_height, d=width-2*bevel_offset, $fn=6);
          translate([0,length,thickness-bevel_height])cylinder(bevel_height, d=width-2*bevel_offset, $fn=6);
        }
        //keyring
        if(part == "upper" && keyring==true) translate([-17,-6,0])cylinder(3.5, d=17, $fn=6);
      }
      //screw holes
      translate([0,0,-e])cylinder(8, d=3);
      translate([0,length,-e])cylinder(8, d=3);


      //holes for the upper part like nut holes and finger holes
      if(part == "upper")
      {
        //nut holes
        hull()translate([0,length,thickness+.1])nut("M3");
        hull()translate([0,0,thickness+.1])nut("M3");

        //keyring hole
        translate([-17,-6,-e])cylinder(thickness*2, d=9, $fn=6);

        //finger holes
        translate([-14,length*(2/3),-e])cylinder(thickness*2, d=17, $fn=6);
        translate([14,length*(1/3),-e])cylinder(thickness*2, d=17, $fn=6);
        translate([0,length/2,-e])cylinder(thickness*2, d=14, $fn=6);
        //finger hole bevels
        finger_hole_bevel_height = thickness-finger_bevel_height;
        hull(){
          translate([-14,length*(2/3),finger_hole_bevel_height])cylinder(-e, d=17, $fn=6);
          translate([-14,length*(2/3),thickness])cylinder(-e, d=17+2*bevel_offset, $fn=6);
        }
        hull(){
          translate([14,length*(1/3),finger_hole_bevel_height])cylinder(-e, d=17, $fn=6);
          translate([14,length*(1/3),thickness])cylinder(-e, d=17+2*bevel_offset, $fn=6);
        }
        if(middle_hole_bevel == true)
        {
          hull(){
            translate([0,length/2,finger_hole_bevel_height])cylinder(-e, d=14, $fn=6);
            translate([0,length/2,thickness])cylinder(-e, d=14+2*bevel_offset, $fn=6);
          }
        }
      }
      //holes for the lower part like hex-pattern
      if(part == "lower")
      {
        hex_element_size =(length-2*honeycomb_pattern_offset-(hex_segments+1)*hex_pattern_thickness)/hex_segments;
        translate([-hex_pattern_width/2,honeycomb_pattern_offset,0])
          antiHoneycomb(hex_pattern_width, length-2*honeycomb_pattern_offset, 10, hex_element_size
          , hex_pattern_thickness);
        translate([-10.5,length/2,0.49])rotate([0,180,90])linear_extrude(height = 0.5) text("Designed by Mattis Männel",4,"Ubuntu",halign="center");

        translate([10.4,length/2,0.49])rotate([0,180,90])linear_extrude(height = 0.5) text(your_text,3.8,"Ubuntu Mono",halign="center", valign="top");
        //screw head spaces
        translate([0,0,-e])cylinder(2, d2=3, d1=6);
        translate([0,length,-e])cylinder(2, d2=3, d1=6);
      }
  }
}

if(parts == "usb-drawer" || parts == "usb_drawer")
{
  FlashDriveDrawer();
}

if(parts == "upper" || parts == "lower")
{
  MainPart(parts);
}

if(parts ==  "all")
{
  translate([-width/2-3,0,0])MainPart("upper");
  translate([width/2+3,0,0])MainPart("lower");
  translate([0,-width,0])FlashDriveDrawer();
}
