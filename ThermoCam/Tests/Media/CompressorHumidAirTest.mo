within ThermoCam.Tests.Media;

model CompressorHumidAirTest

  //Define ratio between water and air
  parameter Real X[4] = {0.23, 0.015, 0.005, 0.75};
  package Medium = ThermoCam.Media.Air_NASA;
  parameter Medium.MassFraction Xnom[Medium.nX] = X;
  
  parameter Real m_flow = 1.0 "unit=kg/s";
  parameter Real Tin = 500.0 "unit=K";
  parameter Real pin = 101325.0 "unit=K";
  parameter Real p_ratio = 12.0 "unit=-";
  parameter Real epsilon_comp = 1.0 "unit=-";
  Real pout;
  
  ThermoCam.Sources_and_sinks.Sources.Source_pT source(redeclare package Medium = Medium,Xnom=Xnom ,m_flow=m_flow, p_su=pin, T_su =Tin) annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor(redeclare package Medium = Medium, Xnom=Xnom, epsilon_s = epsilon_comp) annotation(
    Placement(visible = true, transformation(origin = {-4, 0}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandCompressor(redeclare package Medium = Medium, Xnom=Xnom) annotation(
    Placement(visible = true, transformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecCompressorandOut(redeclare package Medium = Medium, Xnom = Xnom) annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p sink(redeclare package Medium = Medium, Xnom=Xnom, p_su = pout) annotation(
    Placement(visible = true, transformation(origin = {68, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  pout = pin*p_ratio;
  connect(source.outflow, connecInandCompressor.inflow) annotation(
    Line(points = {{-82, 0}, {-62, 0}}));
  connect(connecInandCompressor.outflow, compressor.inflow) annotation(
    Line(points = {{-42, 0}, {-20, 0}}));
  connect(compressor.outflow, connecCompressorandOut.inflow) annotation(
    Line(points = {{10, 0}, {26, 0}}));
  connect(connecCompressorandOut.outflow, sink.inflow) annotation(
    Line(points = {{46, 0}, {53, 0}, {53, 2}, {60, 2}}));
end CompressorHumidAirTest;