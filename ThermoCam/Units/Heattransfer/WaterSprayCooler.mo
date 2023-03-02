within ThermoCam.Units.Heattransfer;

model WaterSprayCooler

  //Water sprayed cooler modelled for ideal gas behaviour of Air_NASA and Fluegas_NASA
  
  //Flow media
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  //Water
  replaceable package Medium_water = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  //Water vapour as ideal gas at its own partial pressure
  replaceable package Medium_waterg = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  
  //Nominal mass fractions
  parameter Medium.MassFraction Xnom[Medium.nX] = Medium.reference_X;
  parameter Medium_water.MassFraction Xnom_water[Medium_water.nX] = Medium_water.reference_X;
  parameter Medium_waterg.MassFraction Xnom_waterg[Medium_waterg.nX] = Medium_waterg.reference_X;
  
  
  /*Ports */
  ThermoCam.Interfaces.Inflow inflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-76, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Interfaces.Outflow outflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Interfaces.Inflow inflow_water(redeclare package Medium = Medium_water) annotation(
    Placement(visible = true, transformation(origin = {0, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {2, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  ThermoCam.Interfaces.Outflow outflow_bypass(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {88, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {88, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  
  //Define outlet relative humidity
  parameter Real humidity_out = 1.0 "unit=-";
  //Define pressure loss percentage of inlet pressure
  parameter Real pressure_loss_factor = 0.0 "unit=-";
  //Initialisation parameters
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Pressure p_ex_start = 1.77175e6 "Outlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pTX(p_su_start, T_su_start, Xnom) "Inlet enthalpy start value";
  parameter Medium.SpecificEnthalpy h_ex_start = Medium.specificEnthalpy_pTX(p_ex_start, T_su_start, Xnom) "Outlet enthalpy start value";
  Medium.ThermodynamicState FluidIn(p(start = p_su_start), T(start = T_su_start)) "Thermodynamic state of the fluid at the inlet";
  Medium.ThermodynamicState FluidOut(p(start = p_ex_start), T(start = T_su_start)) "Thermodynamic state of the fluid at the outlet - not isentropic";
  //Fluid states of saturated liquid and vapour
  Medium_water.ThermodynamicState Fluidsatl(p(start = p_su_start), T(start = T_su_start));
  Medium_water.ThermodynamicState Fluidsatv(p(start = p_ex_start), T(start = T_su_start));
  //Inlet and outlet states of the water
  Medium_water.ThermodynamicState Fluidwaterin(p(start = p_su_start), T(start = T_su_start));
  Medium_waterg.ThermodynamicState Fluidwaterout(p(start = p_ex_start), T(start = T_su_start));
  
  
  //Variables
  //Positive is inflow, negative is outflow.
  Modelica.SIunits.HeatFlowRate Q_air(start = 1.0e6) "unit=Watt";
  Modelica.SIunits.HeatFlowRate Q_water(start = 1.0e6) "unit=Watt";
  
  //Mass flows 
  Modelica.SIunits.MassFlowRate m_flow "unit=kg/s";
  Modelica.SIunits.MassFlowRate m_flow_total "unit=kg/s";
  Modelica.SIunits.MassFlowRate m_flow_bypass "unit=kg/s";
  Modelica.SIunits.MassFlowRate m_water "unit = kg/s";
  
  
  
  Medium.SpecificEnthalpy h_su(start = h_su_start);
  Medium.SpecificEnthalpy h_ex(start = h_ex_start);
  Medium.AbsolutePressure p_su(start = p_su_start);
  Medium.AbsolutePressure p_ex(start = p_ex_start);
  Medium.Temperature T_su(start=T_su_start);
  Medium.Temperature T_ex(start=T_su_start);
  
  //Inlet temperature water
  Medium_water.Temperature T_su_water(start=T_su_start);
  //Specific heat capacities of the water (liquid and vapour)
  Medium_water.SpecificHeatCapacity Cp_lwater;
  Medium_waterg.SpecificHeatCapacity Cp_vwater;
  //Heat vaporisation
  Medium_water.SpecificEnthalpy hfg(start=h_su_start); 
  
  //Mass and Mole fractions of the humid air and fluegas
  Medium.MassFraction X_su[Medium.nXi];
  Medium.MassFraction X_ex[Medium.nXi];
  Modelica.SIunits.MoleFraction Y_su[Medium.nXi];
  Modelica.SIunits.MoleFraction Y_ex[Medium.nXi];
  Real moles_inlet;
  Real moles_outlet;
  //Water partial vapour pressure at the outlet temperature of the main fluid 
  Modelica.SIunits.Pressure p_vpout "unit=Pa";
  //Water vapour saturation pressure at the outlet temperature of the main fluid 
  Modelica.SIunits.Pressure p_vpsat "unit=Pa";

  
equation
/*equations */

  //Convert mass fractions to mole fractions (based on Air_NASA and Fluegas_NASA)
  moles_inlet = X_su[1]/32.0 + X_su[2]/18.0 + X_su[3]/40.0 + X_su[4]/28.0 + X_su[5]/44.0;
  Y_su[1] = (X_su[1]/32.0)/moles_inlet;
  Y_su[2] = (X_su[2]/18.0)/moles_inlet;
  Y_su[3] = (X_su[3]/40.0)/moles_inlet;
  Y_su[4] = (X_su[4]/28.0)/moles_inlet;
  Y_su[5] = (X_su[5]/44.0)/moles_inlet;
  
  //Convert mass fractions to mole fractions (based on Air_NASA and Fluegas_NASA)
  moles_outlet = X_ex[1]/32.0 + X_ex[2]/18.0 + X_ex[3]/40.0 + X_ex[4]/28.0 + X_ex[5]/44.0;
  Y_ex[1] = (X_ex[1]/32.0)/moles_outlet;
  Y_ex[2] = (X_ex[2]/18.0)/moles_outlet;
  Y_ex[3] = (X_ex[3]/40.0)/moles_outlet;
  Y_ex[4] = (X_ex[4]/28.0)/moles_outlet;
  Y_ex[5] = (X_ex[5]/44.0)/moles_outlet;
  
//Fluid properties

  //Air
  if size(inflow.Xi_outflow,1) > 0 then
    FluidIn = Medium.setState_phX(p_su, h_su, inflow.Xi_outflow);
    FluidOut = Medium.setState_phX(p_ex, h_ex, outflow.Xi_outflow);
  else
    FluidIn = Medium.setState_phX(p_su, h_su, Xnom);
    FluidOut = Medium.setState_phX(p_ex, h_ex, Xnom);
  end if;
  
  //Water and water vapour
  if size(inflow_water.Xi_outflow,1) > 0 then
    Fluidwaterin = Medium_water.setState_phX(inflow_water.p, inflow_water.h_outflow, inflow_water.Xi_outflow);
    Fluidwaterout = Medium_waterg.setState_pTX(p_vpout, T_ex, Xnom_waterg);
  else
    Fluidwaterin = Medium_water.setState_phX(inflow_water.p, inflow_water.h_outflow, Xnom_water);
    Fluidwaterout = Medium_waterg.setState_pTX(p_vpout, T_ex, Xnom_waterg);
  end if;
  
  T_su = Medium.temperature(FluidIn);
  T_su_water = Medium_water.temperature(Fluidwaterin);
  Fluidsatl = Medium_water.setState_px(p_vpout, 0.0);
  Fluidsatv = Medium_water.setState_px(p_vpout, 1.0);
  hfg = Medium_water.specificEnthalpy(Fluidsatv) - Medium_water.specificEnthalpy(Fluidsatl);
  Cp_lwater = Medium_water.specificHeatCapacityCp(Fluidwaterin);
  Cp_vwater = Medium_waterg.specificHeatCapacityCp(Fluidwaterout);
  p_vpsat = Medium_water.saturationPressure(T_ex);
  p_vpout = humidity_out*p_vpsat;
  p_vpout = Y_ex[2]*p_ex;
      
  
/*Momentum balance*/
  p_su = inflow.p;
  inflow_water.p = p_su;
  p_ex = (1.0-pressure_loss_factor)*p_su;
  p_ex = outflow.p;
  outflow_bypass.p = p_ex;
  
/*Energy balance*/
  h_su = inflow.h_outflow;
  h_ex = outflow.h_outflow;
  outflow_bypass.h_outflow = h_ex;
  if size(inflow.Xi_outflow,1) > 0 then
    h_ex = Medium.specificEnthalpy_pTX(p_ex, T_ex, outflow.Xi_outflow);
  else 
    h_ex = Medium.specificEnthalpy_pTX(p_ex, T_ex, Xnom);
  end if;
  Q_air + Q_water = 0.0;
  Q_air = abs(m_flow)*(h_ex - h_su);
  Q_water = abs(m_water)*(Cp_vwater*T_ex + hfg - Cp_lwater*T_su_water);
  

/*Mass flows, mass balance */
  m_flow = inflow.m_dot;
  outflow.m_dot = -m_flow;
  m_water = inflow_water.m_dot;
  m_flow_bypass = m_water;
  outflow_bypass.m_dot = m_flow_bypass;
  m_flow_total = abs(m_water) + abs(m_flow);
//Species balance
  X_su = inflow.Xi_outflow;
  X_ex = outflow.Xi_outflow;
  outflow_bypass.Xi_outflow = X_ex;
  X_ex[1] = (X_su[1]*abs(m_flow))/abs(m_flow_total);
  X_ex[2] = (X_su[2]*abs(m_flow) + abs(m_water))/abs(m_flow_total);
  X_ex[3] = (X_su[3]*abs(m_flow))/abs(m_flow_total);
  X_ex[4] = (X_su[4]*abs(m_flow))/abs(m_flow_total);
  X_ex[5] = (X_su[5]*abs(m_flow))/abs(m_flow_total);
  
  
  annotation(
    Icon(graphics = {Line(origin = {36, 66}, points = {{0, 0}}), Ellipse(origin = {-43, 7}, lineColor = {28, 113, 216}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-11, 25}, {11, -25}}), Ellipse(origin = {-43, 7}, lineColor = {28, 113, 216}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-11, 25}, {11, -25}}), Ellipse(origin = {-5, 25}, lineColor = {28, 113, 216}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-11, 25}, {11, -25}}), Ellipse(origin = {-11, -35}, lineColor = {28, 113, 216}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-11, 25}, {11, -25}}), Ellipse(origin = {17, -37}, lineColor = {28, 113, 216}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-11, 25}, {11, -25}}), Ellipse(origin = {29, 19}, lineColor = {28, 113, 216}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-11, 25}, {11, -25}}), Ellipse(origin = {57, 3}, lineColor = {28, 113, 216}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-11, 25}, {11, -25}})}),
    Diagram);

end WaterSprayCooler;