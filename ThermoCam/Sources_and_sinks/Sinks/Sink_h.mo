within ThermoCam.Sources_and_sinks.Sinks;

model Sink_h
  //Sink model, required to specify the enthalpy
  //Flow medium
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  Interfaces.Inflow inflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {82, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {82, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Medium.SpecificEnthalpy h_su(start = h_su_start);
  Medium.AbsolutePressure p_su(start = p_su_start);
  Medium.ThermodynamicState FluidIn(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the fluid at the outlet - isentropic";
  Medium.MassFraction X[Medium.nXi];
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  parameter Medium.MassFraction Xnom[Medium.nX] = Medium.reference_X;
  parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pTX(p_su_start, T_su_start, Xnom) "Inlet enthalpy start value";
  
equation
  if size(X,1) > 0 then
    FluidIn = Medium.setState_phX(p_su, h_su, X);
  else 
    FluidIn = Medium.setState_phX(p_su, h_su, Xnom);
  end if;
  h_su = inflow.h_outflow;
  p_su = inflow.p;
  X = inflow.Xi_outflow;
  annotation(
    Icon(graphics = {Polygon(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-60, 70}, {60, 0}, {-60, -68}, {-60, 70}})}));

end Sink_h;