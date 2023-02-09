within ThermoCam.Units.Heattransfer;

model Condenser
  
  //The model includes the precooling and condensing stage, but not the subcooling stage
  
  //Flow media
  replaceable package Medium_hot = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  replaceable package Medium_cold = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  parameter Medium_hot.MassFraction Xnom_hot[Medium_hot.nX] = Medium_hot.reference_X "Nominal composition";
  parameter Medium_cold.MassFraction Xnom_cold[Medium_cold.nX] = Medium_cold.reference_X "Nominal composition";
  /*Ports */
  Interfaces.Inflow inflow_cold(redeclare package Medium = Medium_cold) annotation(
    Placement(visible = true, transformation(origin = {-82, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-82, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow_cold(redeclare package Medium = Medium_cold) annotation(
    Placement(visible = true, transformation(origin = {76, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {76, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Interfaces.Inflow inflow_hot(redeclare package Medium = Medium_hot) annotation(
    Placement(visible = true, transformation(origin = {76, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {86, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow_hot(redeclare package Medium = Medium_hot) annotation(
    Placement(visible = true, transformation(origin = {-82, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-82, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  
  
  //Positive is inflow, negative is outflow.
  Modelica.SIunits.HeatFlowRate Q_dot_hot(start = 1.0e6) "unit=Watt";
  //Heat outflow of source/sink in outer loop;
  Modelica.SIunits.HeatFlowRate Q_dot_cold(start = 1.0e6) "unit=Watt";
  //Specify mass flow through components
  Modelica.SIunits.MassFlowRate m_flow_hot(start = 1.0) "unit=kg/s";
  //Mass flow through outer loop
  Modelica.SIunits.MassFlowRate m_flow_cold(start = 1.0) "unit=kg/s";
  //Set pinch temperature difference
  parameter Modelica.SIunits.TemperatureDifference DTpinch "unit=K";
  //Set pressure drop inside
  parameter Modelica.SIunits.PressureDifference DPhot "unit=Pa";
  //Set pressure drop outside
  parameter Modelica.SIunits.PressureDifference DPcold "unit=Pa";
  //Set temperature at which the fluid is supposed condense
  parameter Modelica.SIunits.Temp_K T_cond "unit=K";


  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Pressure p_ex_start = 1.77175e6 "Outlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  parameter Medium_hot.SpecificEnthalpy h_su_start = Medium_hot.specificEnthalpy_pTX(p_su_start, T_su_start, Xnom_hot) "Inlet enthalpy start value";
  parameter Medium_hot.SpecificEnthalpy h_ex_start = Medium_hot.specificEnthalpy_pTX(p_ex_start, T_su_start, Xnom_hot) "Outlet enthalpy start value";
  /****************************************** VARIABLES ******************************************/
  Medium_hot.ThermodynamicState FluidInHot(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the fluid at the inlet";
  Medium_hot.ThermodynamicState FluidOutHot(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the fluid at the outlet - isentropic";
  Medium_hot.SpecificEnthalpy h_su_hot(start = h_su_start);
  Medium_hot.SpecificEnthalpy h_ex_hot(start = h_ex_start);
  Medium_hot.AbsolutePressure p_su_hot(start = p_su_start);
  Medium_hot.AbsolutePressure p_ex_hot(start = p_ex_start);
  
  //Condenser specific variables
  Medium_hot.Temperature T_su_hot(start = T_su_start);
  Medium_cold.Temperature T_ex_cold(start = T_su_start);
  Medium_hot.SpecificEnthalpy h_inter_hot(start = h_su_start);
  Medium_hot.Temperature T_inter_hot(start = T_su_start);
  Medium_cold.Temperature T_inter_cold(start = T_su_start);
  Medium_cold.Temperature T_su_cold(start = T_su_start);
  Medium_hot.ThermodynamicState FluidInterHot(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the working fluid at the inlet of the Condenser";
  Real slope_outer(start = 1.0);
  Real slope_inner(start = 1.1);
  
 
equation

  /* Fluid Properties */
  FluidInHot = Medium_hot.setState_phX(p_su_hot, inflow_hot.h_outflow, Xnom_hot);
  h_su_hot = Medium_hot.specificEnthalpy(FluidInHot);
  h_ex_hot = Medium_hot.specificEnthalpy(FluidOutHot);
/*equations */
/*Momentum balance*/
  p_ex_hot = p_su_hot - DPhot;
  inflow_cold.p = outflow_cold.p + DPcold;
/*Energy balance*/
  if m_flow_hot < 0.0 then
    Q_dot_hot = abs(m_flow_hot)*(h_ex_hot - h_su_hot) "Total heat flow";
  else
    Q_dot_hot = m_flow_hot*(h_ex_hot - h_su_hot) "Total heat flow";
  end if;
//BOUNDARY CONDITIONS //
/* Enthalpies */
  outflow_hot.h_outflow = h_ex_hot;
/*Mass flows, mass balance */
  m_flow_hot = inflow_hot.m_dot;
  outflow_hot.m_dot = -m_flow_hot;
  m_flow_cold = inflow_cold.m_dot;
  outflow_cold.m_dot = -m_flow_cold;
/*pressures*/
  inflow_hot.p = p_su_hot;
  outflow_hot.p = p_ex_hot;

  p_ex_hot = Medium_hot.saturationPressure(T_cond);
  FluidOutHot = Medium_hot.setState_px(p_ex_hot, 0.0);
  FluidInterHot = Medium_hot.setState_px(p_ex_hot, 1.0);
  T_su_hot = Medium_hot.temperature_phX(p_su_hot, h_su_hot, Xnom_hot);
  h_inter_hot = Medium_hot.specificEnthalpy(FluidInterHot);
  T_inter_hot = Medium_hot.temperature_phX(p_ex_hot, h_inter_hot, Xnom_hot);
  T_su_cold = Medium_cold.temperature_phX(outflow_cold.p, inflow_cold.h_outflow, Xnom_cold);
////////////////////////////////////////
  T_inter_cold = T_inter_hot - DTpinch;
  slope_outer = (T_inter_cold - T_su_cold)/(h_inter_hot - h_ex_hot);
  slope_inner = (T_su_hot - T_inter_hot)/(h_su_hot - h_inter_hot);
  if abs(slope_outer) > abs(slope_inner) then
    T_ex_cold = T_su_cold + slope_inner*(h_su_hot - h_ex_hot);
  else
    T_ex_cold = T_su_cold + slope_outer*(h_su_hot - h_ex_hot);
  end if;
  T_ex_cold = Medium_cold.temperature_phX(outflow_cold.p, outflow_cold.h_outflow, Xnom_cold);
///////////////////////////////////////
  Q_dot_cold = -Q_dot_hot;
  Q_dot_cold = abs(m_flow_cold)*(outflow_cold.h_outflow - inflow_cold.h_outflow);
  
annotation(
    Icon(graphics = {Line(origin = {2, -35}, points = {{54, -1}, {-54, 1}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}, arrowSize = 10), Line(origin = {2, 48}, points = {{-52, 0}, {52, 0}}, color = {85, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}, arrowSize = 10), Line(origin = {8.01, -11.26}, points = {{-72.0094, -6.7437}, {-60.0094, 1.2563}, {-38.0094, -6.7437}, {-24.0094, 5.2563}, {-6.00941, -2.7437}, {11.9906, 7.2563}, {29.9906, -4.7437}, {45.9906, 7.2563}, {61.9906, -6.7437}, {71.9906, 1.2563}}, color = {255, 0, 0}, thickness = 0.5), Text(origin = {8, 8}, extent = {{-58, 38}, {58, -38}}, textString = "Condenser"), Line(origin = {3.4, 22.23}, points = {{-68.0272, -5.73184}, {-50.0272, 4.26816}, {-34.0272, -5.73184}, {-14.0272, 4.26816}, {-0.0272067, -5.73184}, {21.9728, 6.26816}, {37.9728, -5.73184}, {57.9728, 4.26816}, {67.9728, -5.73184}, {67.9728, -5.73184}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open})}),
    Diagram);

  
  
end Condenser;