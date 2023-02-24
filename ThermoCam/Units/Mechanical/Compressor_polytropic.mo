within ThermoCam.Units.Mechanical;

model Compressor_polytropic
  //Compressor model with polytropic efficiency as input
  //Flow medium
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  //Work input (power)
  Modelica.SIunits.Power W_in "unit=Watt";
  //Specify mass flow through components
  Modelica.SIunits.MassFlowRate m_flow "unit=kg/s";
  //Total pressure ratio
  Real PR;
  //Pressure ratio per stage
  Real PR_perstage;
  //Polytropic efficiency
  parameter Modelica.SIunits.Efficiency epsilon_p = 1.0 "Polytropic Efficiency";
  //Number of stages
  parameter Integer n_stages = 1 "number of stages";
  //Array to keep track of temperature per stage
  Modelica.SIunits.Temperature T_stage[n_stages];
  //Array to keep track of specific heat ratio per stage
  Modelica.SIunits.RatioOfSpecificHeatCapacities gamma_stage[n_stages];
  //Array to keep track of thermodynamic state per stage
  Medium.ThermodynamicState FluidStateInArray[n_stages];
  //Array to keep track of pressure per stage
  Modelica.SIunits.Pressure p_stage[n_stages];
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_su_start = 2.339e5 "Inlet pressure start value";
  parameter Modelica.SIunits.Pressure p_ex_start = 1.77175e6 "Outlet pressure start value";
  parameter Modelica.SIunits.Temperature T_su_start = 293.15 "Inlet temperature start value";
  parameter Medium.MassFraction Xnom[Medium.nX]= Medium.reference_X;
  parameter Medium.SpecificEnthalpy h_su_start = Medium.specificEnthalpy_pTX(p_su_start, T_su_start, Xnom) "Inlet enthalpy start value";
  parameter Medium.SpecificEnthalpy h_ex_start = Medium.specificEnthalpy_pTX(p_ex_start, T_su_start, Xnom) "Outlet enthalpy start value";
  /****************************************** VARIABLES ******************************************/
  Medium.ThermodynamicState FluidIn "Thermodynamic state of the fluid at the inlet";
  Medium.ThermodynamicState FluidOut "Thermodynamic state of the fluid at the outlet - not isentropic";
  Medium.SpecificEnthalpy h_su(start = h_su_start);
  Medium.SpecificEnthalpy h_ex(start = h_ex_start);
  Medium.AbsolutePressure p_su(start = p_su_start);
  Medium.AbsolutePressure p_ex(start = p_ex_start);
  Medium.Temperature T_su(start=T_su_start);
  Medium.Temperature T_ex(start=T_su_start);
  Interfaces.Inflow inflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation



/* Fluid Properties */
   FluidIn = Medium.setState_phX(p_su, h_su, Xnom);
   T_su = Medium.temperature(FluidIn);
/* Pressure ratio per stage */
   // Total pressure ratio
   PR = p_ex/p_su;
   // Pressure ratio per stage
   PR_perstage = PR^(1.0/n_stages);
   for i in 1:n_stages loop
     if i == 1 then
        FluidStateInArray[i] = FluidIn;
        gamma_stage[i] = Medium.isentropicExponent(FluidIn);
        T_stage[i] =  T_su*((PR_perstage)^((gamma_stage[i]-1.0)/(epsilon_p*gamma_stage[i])));
        p_stage[i] = PR_perstage*p_su;
     else
        FluidStateInArray[i] = Medium.setState_pTX(p_stage[i-1],T_stage[i-1],Xnom);
        gamma_stage[i] = Medium.isentropicExponent(FluidStateInArray[i]);
        T_stage[i] =  T_stage[i-1]*((PR_perstage)^((gamma_stage[i]-1.0)/(epsilon_p*gamma_stage[i])));
        p_stage[i] = PR_perstage*p_stage[i-1];
     end if;
   end for;
  T_ex = T_stage[n_stages];
  FluidOut = Medium.setState_pTX(p_ex, T_ex, Xnom);
  h_ex = Medium.specificEnthalpy(FluidOut);
/*equations */
/*Energy balance*/
  W_in = abs(m_flow)*(h_ex - h_su) "Consumed Power";
//BOUNDARY CONDITIONS //
/* Enthalpies */
  h_su = inflow.h_outflow;
  outflow.h_outflow = h_ex;

/*Mass flows, mass balance */
  m_flow = inflow.m_dot;
  outflow.m_dot = -m_flow;
/*pressures*/
  p_su = inflow.p;
  p_ex = outflow.p;
  annotation(
    Icon(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 76}, {-30, 56}, {-24, 56}, {-24, 82}, {-60, 82}, {-60, 76}, {-30, 76}}), Rectangle(fillColor = {160, 160, 164}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, 8}, {60, -8}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{24, 26}, {30, 26}, {30, 76}, {60, 76}, {60, 82}, {24, 82}, {24, 26}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 60}, {-30, -60}, {30, -26}, {30, 26}, {-30, 60}})}),
    Diagram(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 76}, {-30, 56}, {-24, 56}, {-24, 82}, {-60, 82}, {-60, 76}, {-30, 76}}), Rectangle(fillColor = {160, 160, 164}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-60, 8}, {60, -8}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{24, 26}, {30, 26}, {30, 76}, {60, 76}, {60, 82}, {24, 82}, {24, 26}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-30, 60}, {-30, -60}, {30, -26}, {30, 26}, {-30, 60}})}));
end Compressor_polytropic;