within ThermoCam.Tests.Mixers_and_separators;

model MixerTest

  package Medium_in1 = ThermoCam.Media.Air_NASA;
  package Medium_in2 = ThermoCam.Media.FlueGas_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
  parameter Medium_in1.MassFraction Xin1[Medium_in1.nX] = Medium_in1.reference_X "Nominal gas composition";
  parameter Medium_in2.MassFraction Xin2[Medium_in2.nX] = Medium_in2.reference_X "Nominal gas composition";
  
  parameter Real m_flow1 = 1.0;
  parameter Real m_flow2 = 1.0;
  
  
  ThermoCam.Units.Mixers_and_Separators.Massflow_Mixer mixer(redeclare package Medium_in1 = Medium_in1, redeclare package Medium_in2 = Medium_in2, redeclare package Medium_out= Medium_out) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT source1(redeclare package Medium = Medium_in1, p_su = 2e5, T_su=600.0, m_flow=m_flow1,X=Xin1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT source2(redeclare package Medium = Medium_in2, p_su = 3e5, T_su=400.0,m_flow=m_flow2,X=Xin2) annotation(
    Placement(visible = true, transformation(origin = {0, 68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Units.Streamconnector.Streamconnector connecsource1mixer(redeclare package Medium = Medium_in1) annotation(
    Placement(visible = true, transformation(origin = {-46, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecsource2mixer(redeclare package Medium = Medium_in2) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  ThermoCam.Units.Streamconnector.Streamconnector connecmixersink(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p sink_p(redeclare package Medium = Medium_out, p_su=101325.0) annotation(
    Placement(visible = true, transformation(origin = {74, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(source1.outflow, connecsource1mixer.inflow) annotation(
    Line(points = {{-70, 0}, {-56, 0}}));
  connect(connecsource1mixer.outflow, mixer.inflow1) annotation(
    Line(points = {{-36, 0}, {-16, 0}}));
  connect(source2.outflow, connecsource2mixer.inflow) annotation(
    Line(points = {{0, 58}, {0, 50}}));
  connect(connecsource2mixer.outflow, mixer.inflow2) annotation(
    Line(points = {{0, 30}, {0, 16}}));
  connect(mixer.outflow, connecmixersink.inflow) annotation(
    Line(points = {{16, 0}, {30, 0}}));
  connect(connecmixersink.outflow, sink_p.inflow) annotation(
    Line(points = {{50, 0}, {66, 0}}));
end MixerTest;