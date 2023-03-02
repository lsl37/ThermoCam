within ThermoCam.Units.Heattransfer;

model Combustionchamber
   //Model for the Combustion Chamber
  //Ingoing flow medium
  replaceable package Medium_in = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  //Outgoing flow Medium
  replaceable package Medium_out = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  //Heat input (power)
  parameter Modelica.SIunits.Power Q_add "unit=Watt";
  //Specify mass flow through components
  Modelica.SIunits.MassFlowRate m_flow "unit=kg/s";
  //Extra mass flow coming from the fuel
  parameter Modelica.SIunits.MassFlowRate m_fuel "unit=kg/s";
  //Specify outlet gas composition
  Medium_out.MassFraction X_out[Medium_out.nXi];
  //Outlet massflow
  Modelica.SIunits.MassFlowRate m_total "unit=kg/s";
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Pressure p_ex_start = 1.77175e6 "Outlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Medium_out.MassFraction Xnom_out[Medium_out.nX] = Medium_out.reference_X;
  parameter Medium_in.MassFraction Xnom_in[Medium_in.nX] = Medium_in.reference_X;
  parameter Medium_in.SpecificEnthalpy h_su_start = Medium_in.specificEnthalpy_pTX(p_su_start, T_su_start, Xnom_in) "Inlet enthalpy start value";
  parameter Medium_out.SpecificEnthalpy h_ex_start = Medium_out.specificEnthalpy_pTX(p_ex_start, T_su_start, Xnom_out) "Outlet enthalpy start value";
  /****************************************** VARIABLES ******************************************/
  Medium_in.ThermodynamicState FluidIn "Thermodynamic state of the fluid at the inlet";
  Medium_out.ThermodynamicState FluidOut "Thermodynamic state of the fluid at the outlet - isentropic";
  Medium_in.SpecificEnthalpy h_su(start = h_su_start);
  Medium_out.SpecificEnthalpy h_ex(start = h_ex_start);
  Medium_in.AbsolutePressure p_su(start = p_su_start);
  Medium_out.AbsolutePressure p_ex(start = p_ex_start);
  Interfaces.Inflow inflow(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-82, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-82, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {78, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {78, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  
  

equation
  //To account for changes with respect to the nominal gas composition
  //Original built to accomodate humid air into the Combustionchamber
  for i in 1:Medium_out.nXi loop 
      X_out[i] = (Xnom_out[i]*abs(m_flow) - Xnom_in[i]*abs(m_flow) + inflow.Xi_outflow[i]*abs(m_flow))/abs(m_flow);
  end for;
 

/* Fluid Properties */
  FluidIn = Medium_in.setState_phX(p_su, h_su, inflow.Xi_outflow);
  FluidOut = Medium_out.setState_phX(p_ex, h_ex, outflow.Xi_outflow);
//Momentum balance (assumes negligible pressure drop)
  p_su = p_ex;
  p_su = inflow.p;
  p_ex = outflow.p;
/*Mass flows, mass balance */
  m_flow = inflow.m_dot;
  if m_flow < 0.0 then
    outflow.m_dot = (-m_flow) + m_fuel;
  else
    outflow.m_dot = -(m_flow + m_fuel);
  end if;
  m_total = abs(outflow.m_dot);
//Energy balance
  h_su = inflow.h_outflow;
  h_ex = outflow.h_outflow;
//Species balance
  outflow.Xi_outflow = X_out;
//Exit enthalpy
//Determined by added heat
  Q_add = abs(m_flow)*(h_ex - h_su);
  annotation(
    Icon(graphics = {Ellipse(origin = {0, 11}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Solid, extent = {{-78, 79}, {78, -79}}), Line(origin = {-0.97, 11.39}, points = {{0.97109, 60.6121}, {8.97109, 40.6121}, {26.9711, 52.6121}, {26.9711, 34.6121}, {46.9711, 26.6121}, {34.9711, 16.6121}, {54.9711, -9.38788}, {32.9711, -9.38788}, {44.9711, -43.3879}, {18.9711, -31.3879}, {8.97109, -61.3879}, {-7.02891, -35.3879}, {-31.0289, -51.3879}, {-23.0289, -23.3879}, {-55.0289, -21.3879}, {-31.0289, 4.61212}, {-53.0289, 20.6121}, {-27.0289, 30.6121}, {-39.0289, 58.6121}, {-7.02891, 46.6121}, {0.97109, 58.6121}, {0.97109, 60.6121}, {8.97109, 40.6121}}, color = {255, 170, 0}, thickness = 2), Line(origin = {2.04, 18.27}, points = {{-6.04274, 17.7308}, {3.95726, 25.7308}, {7.95726, 9.73083}, {23.9573, 13.7308}, {13.9573, 3.73083}, {25.9573, -6.26917}, {11.9573, -6.26917}, {15.9573, -22.2692}, {-0.0427421, -10.2692}, {-4.04274, -26.2692}, {-8.04274, -6.26917}, {-22.0427, -16.2692}, {-14.0427, -0.269167}, {-26.0427, 7.73083}, {-10.0427, 9.73083}, {-18.0427, 23.7308}, {-6.04274, 17.7308}, {-6.04274, 17.7308}}, color = {255, 0, 0}, thickness = 2)}),
    Diagram);

end Combustionchamber;