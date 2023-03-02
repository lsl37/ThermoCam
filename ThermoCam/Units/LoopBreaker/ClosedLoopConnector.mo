within ThermoCam.Units.LoopBreaker;

model ClosedLoopConnector
//Additional component required to make closed loops work
  //Flow medium
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  Interfaces.Inflow inflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-80, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Medium.MassFraction X[Medium.nXi];


equation
  inflow.p = outflow.p;
  inflow.h_outflow = outflow.h_outflow;
  inflow.Xi_outflow = outflow.Xi_outflow;
  inflow.Xi_outflow = X;
  //On purpose no equation for mass flows (for closed loops)
  annotation(
    Icon(graphics = {Rectangle(origin = {4, 3}, fillColor = {255, 170, 255}, fillPattern = FillPattern.Cross, extent = {{-46, 31}, {46, -31}})}));

end ClosedLoopConnector;