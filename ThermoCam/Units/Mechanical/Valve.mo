within ThermoCam.Units.Mechanical;

model Valve
  //Model for a valve, it works in the same was as an Streamconnector and does therefore not have to be connected to a Streamconnector
  //Flow medium
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  //Specify mass flow through components
  parameter Modelica.SIunits.MassFlowRate m_flow = 1.0 "unit=kg/s";
  //Pressure drop through valve.
  Modelica.SIunits.PressureDifference DP "unit=Pa";
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  Medium.MassFraction Xnom[Medium.nX] = Medium.reference_X "Nominal composition";
  /*FluidState */
  Medium.ThermodynamicState fluidState(p(start = p_nom), T(start = T_nom));
  Interfaces.Inflow inflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-102, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-102, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {106, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Set outflow mass flow equal to source.
  inflow.m_dot = m_flow;
/*Mass balance*/
  inflow.m_dot + outflow.m_dot = 0;
/*Fluid properties */
  fluidState = Medium.setState_phX(inflow.p, inStream(inflow.h_outflow),Xnom);
/*Momentum balance*/
  DP = outflow.p - inflow.p;
/*Energy balance, Assumed to be isenthalpic*/
  inflow.h_outflow = outflow.h_outflow;
// Boundary conditions, enthalpy stays constant
  inflow.h_outflow = inStream(outflow.h_outflow);
  inStream(inflow.h_outflow) = outflow.h_outflow;
  annotation(
    Icon(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-80, 40}, {-80, -40}, {0, 0}, {-80, 40}}), Rectangle(fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, 40}}), Line(points = {{0, 40}, {0, 0}}, thickness = 0.5)}),
    Diagram(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-80, 40}, {-80, -40}, {0, 0}, {-80, 40}}), Rectangle(fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, 40}}), Line(points = {{0, 40}, {0, 0}}, thickness = 0.5)}));

end Valve;