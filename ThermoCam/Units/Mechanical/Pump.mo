within ThermoCam.Units.Mechanical;

model Pump
  //Pump model with isentropic efficiency as input
  extends Compressor;
  annotation(
    Icon(graphics = {Polygon(origin = {1, -69}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, points = {{-51, 31}, {51, 31}, {67, -31}, {-65, -31}, {-67, -29}, {-51, 31}}), Ellipse(origin = {2, 19}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-78, 79}, {78, -79}})}));

end Pump;