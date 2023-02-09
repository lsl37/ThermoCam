within ThermoCam.Tests.GasTurbines;

model SimpleGasTurbine

//Declare inputs
  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
  Medium_in.MassFraction Xnom[Medium_in.nX] = Medium_in.reference_X "Nominal gas composition";
  Medium_out.MassFraction Xnom_out[Medium_out.nX] = Medium_out.reference_X "Nominal gas composition";
  
  //Ambient conditions
  parameter Real Tcold = 288.15 "unit=K";
  parameter Real pcold = 101325.0 "unit=Pa";
  //Specify added heat in the combustion chamber
  parameter Real Q_hot = 100000.0 "unit=W";
  //Compressor pressure ratio
  parameter Real ph_pc = 16.0;
  Real phot "unit=Pa";
  //Massflow in gas turbine
  parameter Real massflow_air = 1.0 "unit =kg/s";
  //Massflow fuel
  parameter Real massflow_fuel = 0.0 "unit=kg/s";
  //Isentropic effiency compressor
  parameter Real epsilon_comp = 1.0 "unit = -";
  //Isentropic efficiency turbine
  parameter Real epsilon_turb = 1.0 "unit = -";





//Declare class instances (must redeclare medium in all instances)
  ThermoCam.Sources_and_sinks.Sources.Source_pT airin(redeclare package Medium = Medium_in, p_su=pcold, T_su=Tcold,m_flow=massflow_air) annotation(
    Placement(visible = true, transformation(origin = {-152, -4}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandComp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-118, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor(redeclare package Medium = Medium_in, epsilon_s = epsilon_comp) annotation(
    Placement(visible = true, transformation(origin = {-83, -3}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandComb(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-48, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Combustionchamber combustionchamber(redeclare package Medium_in = Medium_in, redeclare package Medium_out =Medium_out,Q_add = Q_hot, m_fuel = massflow_fuel,p_su=phot) annotation(
    Placement(visible = true, transformation(origin = {-1, -3}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCombandTurb(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {40, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine turbine(redeclare package Medium = Medium_out, epsilon_s=epsilon_turb) annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p airout(redeclare package Medium = Medium_out, p_su = pcold) annotation(
    Placement(visible = true, transformation(origin = {158, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecTurbandOut(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {124, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  //Momentum balance
  phot = ph_pc*pcold;
  connect(airin.outflow, connecInandComp.inflow) annotation(
    Line(points = {{-135.44, -4}, {-127.44, -4}}));
  connect(connecInandComp.outflow, compressor.inflow) annotation(
    Line(points = {{-108, -3.6}, {-105, -3.6}, {-105, -1.6}, {-100, -1.6}}));
  connect(compressor.outflow, connecCompandComb.inflow) annotation(
    Line(points = {{-68.18, -3}, {-58.18, -3}, {-58.18, -5}}));
  connect(connecCompandComb.outflow, combustionchamber.inflow) annotation(
    Line(points = {{-38, -3.6}, {-18, -3.6}, {-18, -1.6}}));
  connect(combustionchamber.outflow, connecCombandTurb.inflow) annotation(
    Line(points = {{15.38, -2.16}, {29.38, -2.16}}));
  connect(connecCombandTurb.outflow, turbine.inflow) annotation(
    Line(points = {{50, -1.6}, {64, -1.6}, {64, 0.4}}));
  connect(turbine.outflow, connecTurbandOut.inflow) annotation(
    Line(points = {{98.28, 0}, {114.28, 0}}));
  connect(connecTurbandOut.outflow, airout.inflow) annotation(
    Line(points = {{134, 0.4}, {150, 0.4}}));
  annotation(
    Icon);
end SimpleGasTurbine;