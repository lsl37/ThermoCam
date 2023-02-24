within ThermoCam.Tests.Compressor_polytropic;

model TurbinePolytropicTest

  package Medium = ThermoCam.Media.FlueGas_NASA;
  parameter Medium.MassFraction Xnom[Medium.nX] = Medium.reference_X;
  
  parameter Real m_flow = 1.0 "unit=kg/s";
  parameter Real Tin = 1600.0 "unit=K";
  parameter Real pin = 13.0e5 "unit=K";
  parameter Real p_ratio = 12.0 "unit=-";
  parameter Real epsilon_turb = 0.9 "unit=-";
  parameter Integer n_stages = 5 "unit=-";
  Real pout;
  
  ThermoCam.Sources_and_sinks.Sources.Source_pT source(redeclare package Medium = Medium,Xnom=Xnom ,m_flow=m_flow, p_su=pin, T_su =Tin) annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandCompressor(redeclare package Medium = Medium, Xnom=Xnom) annotation(
    Placement(visible = true, transformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecCompressorandOut(redeclare package Medium = Medium, Xnom = Xnom) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sources_and_sinks.Sinks.Sink_p sink(redeclare package Medium = Medium,Xnom = Xnom, p_su = pout) annotation(
    Placement(visible = true, transformation(origin = {68, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine_polytropic turbine_polytropic(redeclare package Medium = Medium, Xnom = Xnom, epsilon_p = epsilon_turb, n_stages=n_stages) annotation(
    Placement(visible = true, transformation(origin = {-6, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  pout = pin/p_ratio;
  connect(source.outflow, connecInandCompressor.inflow) annotation(
    Line(points = {{-82, 0}, {-62, 0}}));
  connect(connecCompressorandOut.outflow, sink.inflow) annotation(
    Line(points = {{46, 0}, {53, 0}, {53, 2}, {60, 2}}));
  connect(connecInandCompressor.outflow, turbine_polytropic.inflow) annotation(
    Line(points = {{-42, 0}, {-22, 0}}));
  connect(turbine_polytropic.outflow, connecCompressorandOut.inflow) annotation(
    Line(points = {{8, 0}, {26, 0}}));
end TurbinePolytropicTest;