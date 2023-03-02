within ThermoCam.Units.Heattransfer;

model Evaporator
  //The model includes the preheater and evaporation stage, but not the superheating stage
  //Flow media
  replaceable package Medium_cold = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  replaceable package Medium_hot = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  parameter Medium_cold.MassFraction Xnom_cold[Medium_cold.nX] = Medium_cold.reference_X;
  parameter Medium_hot.MassFraction Xnom_hot[Medium_hot.nX] = Medium_hot.reference_X;
  /*Ports */
  Interfaces.Inflow inflow_cold(redeclare package Medium = Medium_cold) annotation(
    Placement(visible = true, transformation(origin = {-76, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-76, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow_cold(redeclare package Medium = Medium_cold) annotation(
    Placement(visible = true, transformation(origin = {72, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Inflow inflow_hot(redeclare package Medium = Medium_hot) annotation(
    Placement(visible = true, transformation(origin = {78, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {78, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow_hot(redeclare package Medium = Medium_hot) annotation(
    Placement(visible = true, transformation(origin = {-72, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-68, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Positive is inflow, negative is outflow.
  Modelica.SIunits.HeatFlowRate Q_dot_cold(start = 1.0e6) "unit=Watt";
  //Heat outflow of source/sink in outer loop;
  Modelica.SIunits.HeatFlowRate Q_dot_hot(start = 1.0e6) "unit=Watt";
  //Specify mass flow through components
  Modelica.SIunits.MassFlowRate m_flow_cold(start = 1.0) "unit=kg/s";
  Modelica.SIunits.MassFlowRate m_flow_hot(start = 1.0) "unit=kg/s";
  //Set pinch temperature difference
  parameter Modelica.SIunits.TemperatureDifference DTpinch "unit=K";
  //Set pressure drop cold side
  parameter Modelica.SIunits.PressureDifference DPcold "unit=Pa";
  //Set pressure drop hot side
  parameter Modelica.SIunits.PressureDifference DPhot "unit=Pa";
  //Evaporator sets the pressure at which the fluid evaporates
  parameter Modelica.SIunits.Pressure p_evap(start = p_ex_start) "unit=Pa";
  
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Pressure p_ex_start = 1.77175e6 "Outlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  parameter Medium_cold.SpecificEnthalpy h_su_start = Medium_cold.specificEnthalpy_pTX(p_su_start, T_su_start, Xnom_cold) "Inlet enthalpy start value";
  parameter Medium_cold.SpecificEnthalpy h_ex_start = Medium_hot.specificEnthalpy_pTX(p_ex_start, T_su_start, Xnom_cold) "Outlet enthalpy start value";
  /****************************************** VARIABLES ******************************************/
  //Inter refers to the condition just before evaporation (saturated liquid)
  
  
  Medium_cold.ThermodynamicState FluidInCold(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the fluid at the inlet";
  Medium_cold.ThermodynamicState FluidOutCold(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the fluid at the outlet - isentropic";
  
  Medium_cold.SpecificEnthalpy h_su_cold(start = h_su_start);
  Medium_cold.SpecificEnthalpy h_ex_cold(start = h_ex_start);
  Medium_hot.AbsolutePressure p_su_hot(start = p_su_start);
  Medium_hot.AbsolutePressure p_ex_hot(start = p_ex_start);
  Medium_cold.AbsolutePressure p_su_cold(start = p_su_start);
  Medium_cold.AbsolutePressure p_ex_cold(start = p_ex_start);
  Medium_cold.Temperature T_su_cold(start = T_su_start);
  Medium_cold.Temperature T_inter_cold(start = T_su_start);
  Medium_hot.Temperature T_su_hot(start = T_su_start);
  Medium_hot.Temperature T_inter_hot(start = T_su_start);
  Medium_hot.Temperature T_ex_hot(start = T_su_start);
  Medium_cold.SpecificEnthalpy h_inter_cold(start = h_su_start);
  Medium_cold.ThermodynamicState FluidInterCold(p(start = p_nom), T(start = T_nom)) "Thermodynamic state of the working fluid at the inlet of the Evaporator";
  Real slope_outer(start = 1.0);
  Real slope_inner(start = 1.1);
equation

  /* Fluid Properties */
  if size(inflow_cold.Xi_outflow, 1) > 0 then
    FluidInCold = Medium_cold.setState_phX(p_su_cold, inflow_cold.h_outflow, inflow_cold.Xi_outflow);
  else
    FluidInCold = Medium_cold.setState_phX(p_su_cold, inflow_cold.h_outflow, Xnom_cold);
  end if;
  h_su_cold = Medium_cold.specificEnthalpy(FluidInCold);
  h_ex_cold = Medium_cold.specificEnthalpy(FluidOutCold);
  
/*equations */
/*Momentum balance*/
  p_ex_cold = p_su_cold - DPcold;
  inflow_hot.p = outflow_hot.p + DPhot;
  p_su_hot = inflow_hot.p;
  p_ex_hot = outflow_hot.p;
/*Energy balance*/
  if m_flow_cold < 0.0 then
    Q_dot_cold = abs(m_flow_cold)*(h_ex_cold - h_su_cold) "Total heat flow";
  else
    Q_dot_cold = m_flow_cold*(h_ex_cold - h_su_cold) "Total heat flow";
  end if;

//BOUNDARY CONDITIONS //
/* Enthalpies */
  outflow_cold.h_outflow = h_ex_cold;

/*Mass flows, mass balance */
  m_flow_cold = inflow_cold.m_dot;
  outflow_cold.m_dot = -m_flow_cold;
  m_flow_hot = inflow_hot.m_dot;
  outflow_hot.m_dot = -m_flow_hot;
/*pressures*/
  inflow_cold.p = p_su_cold;
  outflow_cold.p = p_ex_cold;


/*Equations specific to the Evaporator*/
  p_ex_cold = p_evap;
  FluidOutCold = Medium_cold.setState_px(p_ex_cold, 1.0);
  FluidInterCold = Medium_cold.setState_px(p_ex_cold, 0.0);
  h_inter_cold = Medium_cold.specificEnthalpy(FluidInterCold);
  if size(inflow_cold.Xi_outflow, 1) > 0 then
    T_su_cold = Medium_cold.temperature_phX(p_su_cold, h_su_cold, inflow_cold.Xi_outflow);
    T_inter_cold = Medium_cold.temperature_phX(p_ex_cold, h_inter_cold, inflow_cold.Xi_outflow);
  else
    T_su_cold = Medium_cold.temperature_phX(p_su_cold, h_su_cold, Xnom_cold);
    T_inter_cold = Medium_cold.temperature_phX(p_ex_cold, h_inter_cold, Xnom_cold);
  end if;
  if size(inflow_hot.Xi_outflow, 1) > 0 then
    T_su_hot = Medium_hot.temperature_phX(inflow_hot.p, inflow_hot.h_outflow, inflow_hot.Xi_outflow);
  else 
    T_su_hot = Medium_hot.temperature_phX(inflow_hot.p, inflow_hot.h_outflow, Xnom_hot);
  end if;
  T_inter_hot = T_inter_cold + DTpinch;
  slope_outer = (T_inter_hot - T_su_hot)/(h_ex_cold - h_inter_cold);
  slope_inner = (T_su_cold - T_inter_cold)/(h_inter_cold - h_su_cold);
  if abs(slope_outer) > abs(slope_inner) then
    T_ex_hot = T_su_hot + slope_inner*(h_ex_cold - h_su_cold);
  else
    T_ex_hot = T_su_hot + slope_outer*(h_ex_cold - h_su_cold);
  end if;
  if size(outflow_hot.Xi_outflow, 1) > 0 then
    T_ex_hot = Medium_hot.temperature_phX(outflow_hot.p, outflow_hot.h_outflow, outflow_hot.Xi_outflow);
  else
    T_ex_hot = Medium_hot.temperature_phX(outflow_hot.p, outflow_hot.h_outflow, Xnom_hot);
  end if;
//Energy balance at Evaporator
  Q_dot_hot = -Q_dot_cold;
  if m_flow_hot < 0.0 then
    Q_dot_hot = abs(m_flow_hot)*(outflow_hot.h_outflow - inflow_hot.h_outflow);
  else
    Q_dot_hot = m_flow_hot*(outflow_hot.h_outflow - inflow_hot.h_outflow);
  end if;
  
//Species balance
  inflow_cold.Xi_outflow = outflow_cold.Xi_outflow;
  inflow_hot.Xi_outflow = outflow_hot.Xi_outflow;
  
  annotation(
    Icon(graphics = {Line(origin = {36, 66}, points = {{0, 0}}), Line(origin = {2, 48}, points = {{-52, 0}, {52, 0}}, color = {85, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}, arrowSize = 10), Line(origin = {3.4, 22.23}, points = {{-68.0272, -5.73184}, {-50.0272, 4.26816}, {-34.0272, -5.73184}, {-14.0272, 4.26816}, {-0.0272067, -5.73184}, {21.9728, 6.26816}, {37.9728, -5.73184}, {57.9728, 4.26816}, {67.9728, -5.73184}, {67.9728, -5.73184}}, color = {0, 85, 255}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}), Line(origin = {2, -35}, points = {{54, -1}, {-54, 1}}, color = {255, 0, 0}, thickness = 0.5, arrow = {Arrow.None, Arrow.Open}, arrowSize = 10), Line(origin = {8.01, -11.26}, points = {{-72.0094, -6.7437}, {-60.0094, 1.2563}, {-38.0094, -6.7437}, {-24.0094, 5.2563}, {-6.00941, -2.7437}, {11.9906, 7.2563}, {29.9906, -4.7437}, {45.9906, 7.2563}, {61.9906, -6.7437}, {71.9906, 1.2563}}, color = {255, 0, 0}, thickness = 0.5), Text(origin = {8, 8}, extent = {{-58, 38}, {58, -38}}, textString = "Evaporator")}),
    Diagram(graphics = {Line(origin = {0.273333, -1.91444}, points = {{-45.686, -56.7833}, {46.314, 57.2167}, {4.31401, 47.2167}, {6.31401, 47.2167}}, color = {250, 49, 14}, thickness = 0.5), Line(origin = {-17.4167, 37.3056}, points = {{-14, 0}, {14, 0}, {14, 0}}, color = {0, 85, 255}, thickness = 0.5), Line(origin = {0.273333, -1.91444}, points = {{-45.686, -56.7833}, {46.314, 57.2167}, {4.31401, 47.2167}, {6.31401, 47.2167}}, color = {250, 49, 14}, thickness = 0.5), Line(origin = {0.273333, -1.91444}, points = {{-45.686, -56.7833}, {46.314, 57.2167}, {4.31401, 47.2167}, {6.31401, 47.2167}}, color = {250, 49, 14}, thickness = 0.5), Line(origin = {48.5833, 37.3056}, points = {{0, 16}, {0, -16}, {0, -16}}, color = {255, 8, 0}, thickness = 0.5), Line(origin = {6.69333, -12.0744}, points = {{43.8942, -46.6232}, {-38.1058, 47.3768}, {-44.1058, 21.3768}, {-44.1058, 21.3768}}, color = {0, 85, 255}, thickness = 0.5), Line(origin = {0.273333, -1.91444}, points = {{-45.686, -56.7833}, {46.314, 57.2167}, {4.31401, 47.2167}, {6.31401, 47.2167}}, color = {250, 49, 14}, thickness = 0.5), Line(origin = {48.5833, 37.3056}, points = {{0, 16}, {0, -16}, {0, -16}}, color = {255, 8, 0}, thickness = 0.5)}));

end Evaporator;