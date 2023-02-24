within ThermoCam.Cycle_examples.GasTurbines;

model RecuperatedGasTurbine

//Declare inputs
  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
  //Medium_in.MassFraction Xnom[Medium_in.nX] = Medium_in.reference_X "Nominal gas composition";
  //Medium_out.MassFraction Xnom_out[Medium_out.nX] = Medium_out.reference_X "Nominal gas composition";
  
  //Ambient conditions
  parameter Real Tcold = 288.15 "unit=K";
  parameter Real pcold = 101325.0 "unit=Pa";
  //Specify added heat in the combustion chamber
  parameter Real Q_hot = 215.0*1.065e6 "unit=W";
  //Compressor pressure ratio
  parameter Real ph_pc = 16.0;
  Real phot "unit=Pa";
  //Massflow in gas turbine
  parameter Real massflow_air = 215.0 "unit =kg/s";
  //Massflow fuel
  parameter Real massflow_fuel = 5.0 "unit=kg/s";
  //Isentropic effiency compressor
  parameter Real epsilon_comp = 0.86 "unit = -";
  //Isentropic efficiency turbine
  parameter Real epsilon_turb = 0.888 "unit = -";


  //recuperator inputs
  //Admissible pressure drop hot side
  parameter Real DPhot_recup = 500.0 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_recup = 500.0 "unit=Pa";
  //Desired decrease in temperature of the hot fluid
  parameter Real DThot_recup = 0.0 "unit=K";




//Declare class instances (must redeclare medium in all instances)
  ThermoCam.Sources_and_sinks.Sources.Source_pT airin(redeclare package Medium = Medium_in, p_su=pcold, T_su=Tcold,m_flow=massflow_air) annotation(
    Placement(visible = true, transformation(origin = {-200, -4}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandComp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-146, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor(redeclare package Medium = Medium_in, epsilon_s = epsilon_comp) annotation(
    Placement(visible = true, transformation(origin = {-109, -3}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Combustionchamber combustionchamber(redeclare package Medium_in = Medium_in, redeclare package Medium_out =Medium_out,Q_add = Q_hot, m_fuel = massflow_fuel, p_su=phot) annotation(
    Placement(visible = true, transformation(origin = {-1, -3}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCombandTurb(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine turbine(redeclare package Medium = Medium_out, epsilon_s=epsilon_turb) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p airout(redeclare package Medium = Medium_out, p_su = pcold) annotation(
    Placement(visible = true, transformation(origin = {162, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Recuperator recuperator(redeclare package Medium_cold = Medium_in, redeclare package Medium_hot = Medium_out,DPhot = DPhot_recup, DPcold = DPcold_recup, DThot = DThot_recup) annotation(
    Placement(visible = true, transformation(origin = {-55, 45}, extent = {{-23, 23}, {23, -23}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandRecuperator(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-78, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecRecuperatorandCombustionchamber(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-36, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecTurbineandRecuperator(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {38, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecRecuperatorandOut(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {134, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Momentum balance
  phot = ph_pc*pcold;
  connect(airin.outflow, connecInandComp.inflow) annotation(
    Line(points = {{-183, -4}, {-157, -4}}));
  connect(connecInandComp.outflow, compressor.inflow) annotation(
    Line(points = {{-136, -4}, {-105, -4}, {-105, -3}, {-126, -3}}));
  connect(combustionchamber.outflow, connecCombandTurb.inflow) annotation(
    Line(points = {{15.38, -2.16}, {29.38, -2.16}}));
  connect(connecCombandTurb.outflow, turbine.inflow) annotation(
    Line(points = {{50, -1.6}, {64, -1.6}, {64, 0.4}}));
  connect(compressor.outflow, connecCompandRecuperator.inflow) annotation(
    Line(points = {{-94, -2}, {-88, -2}, {-88, -4}}));
  connect(connecCompandRecuperator.outflow, recuperator.inflow_cold) annotation(
    Line(points = {{-68, -4}, {-68, 28}, {-84, 28}, {-84, 38}, {-76, 38}}));
  connect(recuperator.outflow_cold, connecRecuperatorandCombustionchamber.inflow) annotation(
    Line(points = {{-36, 40}, {-32, 40}, {-32, 8}, {-54, 8}, {-54, -2}, {-46, -2}}));
  connect(connecRecuperatorandCombustionchamber.outflow, combustionchamber.inflow) annotation(
    Line(points = {{-26, -2}, {-18, -2}}));
  connect(turbine.outflow, connecTurbineandRecuperator.inflow) annotation(
    Line(points = {{98, 0}, {108, 0}, {108, 34}, {48, 34}}));
  connect(connecTurbineandRecuperator.outflow, recuperator.inflow_hot) annotation(
    Line(points = {{28, 34}, {-18, 34}, {-18, 56}, {-36, 56}}));
  connect(recuperator.outflow_hot, connecRecuperatorandOut.inflow) annotation(
    Line(points = {{-74, 56}, {-102, 56}, {-102, 78}, {118, 78}, {118, 0}, {124, 0}}));
  connect(connecRecuperatorandOut.outflow, airout.inflow) annotation(
    Line(points = {{144, 0}, {154, 0}}));
  annotation(
    Icon);
end RecuperatedGasTurbine;