within ThermoCam.Tests.Compressor_polytropic;

model CompressorPolytropicTest

  package Medium = ThermoCam.Media.Air_NASA;
  parameter Medium.MassFraction Xnom[Medium.nX] = Medium.reference_X;
  
  parameter Real m_flow = 1.0 "unit=kg/s";
  parameter Real Tin = 288.15 "unit=K";
  parameter Real pin = 101325.0 "unit=K";
  parameter Real p_ratio = 12.0 "unit=-";
  parameter Real epsilon_comp = 0.9 "unit=-";
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
  ThermoCam.Units.Mechanical.Compressor_polytropic compressor_polytropic(redeclare package Medium = Medium, Xnom = Xnom, epsilon_p = epsilon_comp, n_stages=n_stages) annotation(
    Placement(visible = true, transformation(origin = {-8, -2.66454e-15}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
equation
  pout = pin*p_ratio;
  connect(source.outflow, connecInandCompressor.inflow) annotation(
    Line(points = {{-82, 0}, {-62, 0}}));
  connect(connecCompressorandOut.outflow, sink.inflow) annotation(
    Line(points = {{46, 0}, {53, 0}, {53, 2}, {60, 2}}));
  connect(connecInandCompressor.outflow, compressor_polytropic.inflow) annotation(
    Line(points = {{-42, 0}, {-20, 0}}));
  connect(compressor_polytropic.outflow, connecCompressorandOut.inflow) annotation(
    Line(points = {{2, 0}, {26, 0}}));
end CompressorPolytropicTest;