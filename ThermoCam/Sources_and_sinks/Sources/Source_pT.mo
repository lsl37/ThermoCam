within ThermoCam.Sources_and_sinks.Sources;

model Source_pT
  //Source model, required to specify pressure, temperature and composition
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  //Specify mass flow through components
  Modelica.SIunits.MassFlowRate m_flow "unit=kg/s";
  //Specify temperature and pressure
  parameter Medium.Temperature T_su(start = T_su_start);
  parameter Medium.AbsolutePressure p_su(start = p_su_start);
  parameter Medium.MassFraction X[Medium.nXi];
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  parameter Medium.MassFraction Xnom[Medium.nX] = Medium.reference_X;
  
  
  
  Medium.ThermodynamicState FluidOut(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the fluid at the outlet - isentropic";
  Interfaces.Outflow outflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
   //Boundary conditions
  if size(X,1) > 0 then
    FluidOut = Medium.setState_pTX(p_su, T_su, X);
  else 
    FluidOut = Medium.setState_pTX(p_su, T_su, Xnom); 
  end if;
  outflow.m_dot = m_flow;
  outflow.h_outflow = Medium.specificEnthalpy(FluidOut);
  outflow.p = p_su;
  outflow.Xi_outflow = X; 
  annotation(
    Icon(graphics = {Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{36, 45}, {100, -45}}), Text(visible = false, extent = {{-155, -98}, {-35, -126}}, textString = "C"), Text(textColor = {255, 0, 0}, extent = {{-54, 32}, {16, -30}}, textString = "m"), Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 80}, {60, -80}}), Ellipse(lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-26, 30}, {-18, 22}}), Text(visible = false, extent = {{-153, -44}, {-33, -72}}, textString = "X"), Text(visible = false, extent = {{-113, 72}, {-73, 38}}, textString = "h"), Polygon(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-60, 70}, {60, 0}, {-60, -68}, {-60, 70}})}),
    Diagram);

end Source_pT;