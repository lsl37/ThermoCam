within ThermoCam.Units.Mechanical;

model Compressor
  //Compressor model with isentropic efficiency as input
  //Flow medium
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  //Work input (power)
  Modelica.SIunits.Power W_in "unit=Watt";
  //Specify mass flow through components
  Modelica.SIunits.MassFlowRate m_flow "unit=kg/s";
  //Isentropic efficiency
  parameter Modelica.SIunits.Efficiency epsilon_s = 1.0 "Isentropic Efficiency";
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Pressure p_ex_start = 1.77175e6 "Outlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Medium.MassFraction Xnom[Medium.nX]= Medium.reference_X;
  parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pTX(p_su_start, T_su_start, Xnom) "Inlet enthalpy start value";
  parameter Medium.SpecificEnthalpy h_ex_start = Medium.specificEnthalpy_pTX(p_ex_start, T_su_start, Xnom) "Outlet enthalpy start value";
  /****************************************** VARIABLES ******************************************/
  Medium.ThermodynamicState FluidIn "Thermodynamic state of the fluid at the inlet";
  Medium.ThermodynamicState FluidOut_isentropic "Thermodynamic state of the fluid at the outlet - isentropic";
  Medium.ThermodynamicState FluidOut "Thermodynamic state of the fluid at the outlet - not isentropic";
  Medium.SpecificEntropy s_su;
  Medium.SpecificEnthalpy h_su(start = h_su_start);
  Medium.SpecificEnthalpy h_ex(start = h_ex_start);
  Medium.AbsolutePressure p_su(start = p_su_start);
  Medium.AbsolutePressure p_ex(start = p_ex_start);
  Medium.SpecificEnthalpy h_ex_s(start = h_ex_start);
  Interfaces.Inflow inflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
/* Fluid Properties */
  if size(inflow.Xi_outflow,1) > 0 then
    FluidIn = Medium.setState_phX(p_su, h_su, inflow.Xi_outflow);
    FluidOut = Medium.setState_phX(p_ex, h_ex, outflow.Xi_outflow);
  else
    FluidIn = Medium.setState_phX(p_su, h_su, Xnom);
    FluidOut = Medium.setState_phX(p_ex, h_ex, Xnom);
  end if;

  s_su = Medium.specificEntropy(FluidIn);
//Implicit assumption that it is isentropic
  if size(outflow.Xi_outflow,1) > 0 then
    FluidOut_isentropic = Medium.setState_psX(p_ex, s_su, outflow.Xi_outflow);
  else
    FluidOut_isentropic = Medium.setState_psX(p_ex, s_su, Xnom);
  end if;
  h_ex_s = Medium.specificEnthalpy(FluidOut_isentropic);
/*equations */
/*Energy balance*/
  h_ex = h_su + (h_ex_s - h_su)/epsilon_s;
  W_in = abs(m_flow)*(h_ex - h_su) "Consumed Power";
//BOUNDARY CONDITIONS //
/* Enthalpies */
  h_su = inflow.h_outflow;
  outflow.h_outflow = h_ex;
  
/*Species balance*/
  inflow.Xi_outflow = outflow.Xi_outflow;

/*Mass flows, mass balance */
  m_flow = inflow.m_dot;
  outflow.m_dot = -m_flow;
/*pressures*/
  p_su = inflow.p;
  p_ex = outflow.p;
  annotation(
    Icon(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 76}, {-30, 56}, {-24, 56}, {-24, 82}, {-60, 82}, {-60, 76}, {-30, 76}}), Rectangle(fillColor = {160, 160, 164}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, 8}, {60, -8}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{24, 26}, {30, 26}, {30, 76}, {60, 76}, {60, 82}, {24, 82}, {24, 26}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 60}, {-30, -60}, {30, -26}, {30, 26}, {-30, 60}})}),
    Diagram(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 76}, {-30, 56}, {-24, 56}, {-24, 82}, {-60, 82}, {-60, 76}, {-30, 76}}), Rectangle(fillColor = {160, 160, 164}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, 8}, {60, -8}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{24, 26}, {30, 26}, {30, 76}, {60, 76}, {60, 82}, {24, 82}, {24, 26}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 60}, {-30, -60}, {30, -26}, {30, 26}, {-30, 60}})}));
end Compressor;