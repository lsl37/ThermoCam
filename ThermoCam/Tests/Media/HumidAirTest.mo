within ThermoCam.Tests.Media;

model HumidAirTest

  parameter Real X[2] = {0.03,0.97};
  package Medium = ThermoCam.Media.HumidAir;
  parameter Medium.MassFraction Xnom[Medium.nX] = X;

  ThermoCam.Sources_and_sinks.Sinks.Sink sink(redeclare package Medium = Medium,Xnom=Xnom) annotation(
    Placement(visible = true, transformation(origin = {66, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT source(redeclare package Medium = Medium,Xnom=Xnom ,m_flow=1.0, p_su=101325.0, T_su=500.0) annotation(
    Placement(visible = true, transformation(origin = {-76, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecSourceandSink(redeclare package Medium = Medium,Xnom=Xnom) annotation(
    Placement(visible = true, transformation(origin = {2, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));equation
  connect(source.outflow, connecSourceandSink.inflow) annotation(
    Line(points = {{-66, -2}, {-8, -2}, {-8, -4}}));
  connect(connecSourceandSink.outflow, sink.inflow) annotation(
    Line(points = {{12, -4}, {58, -4}, {58, 0}}));
end HumidAirTest;