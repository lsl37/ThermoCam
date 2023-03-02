within ThermoCam.Tests.Mixers_and_separators;

model SeparatorTest

  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out1 = ThermoCam.Media.Air_NASA;
  package Medium_out2 = ThermoCam.Media.Air_NASA;
  
  Sources_and_sinks.Sources.Source_pT source_pT(redeclare package Medium = Medium_in,T_su=288.15,p_su=101325.0, m_flow = 1.0) annotation(
    Placement(visible = true, transformation(origin = {-72, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink sink1(redeclare package Medium = Medium_out1) annotation(
    Placement(visible = true, transformation(origin = {-6, 54}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  ThermoCam.Sources_and_sinks.Sinks.Sink sink2(redeclare package Medium = Medium_out2) annotation(
    Placement(visible = true, transformation(origin = {50, -4}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Mixers_and_Separators.Massflow_Separator separator(redeclare package Medium_in = Medium_in, redeclare package Medium_out1 = Medium_out1, redeclare package Medium_out2 = Medium_out2, m_fraction1 = 0.2) annotation(
    Placement(visible = true, transformation(origin = {-8, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecinflowseparator(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-40, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector conncseparatoroutflow2(redeclare package Medium = Medium_out2) annotation(
    Placement(visible = true, transformation(origin = {18, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecseparatoroutflow1(redeclare package Medium = Medium_out1) annotation(
    Placement(visible = true, transformation(origin = {-6, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));equation
  connect(source_pT.outflow, connecinflowseparator.inflow) annotation(
    Line(points = {{-62, -6}, {-50, -6}}));
  connect(connecinflowseparator.outflow, separator.inflow) annotation(
    Line(points = {{-30, -6}, {-18, -6}, {-18, -4}}));
  connect(separator.outflow_2, conncseparatoroutflow2.inflow) annotation(
    Line(points = {{2, -4}, {8, -4}}));
  connect(conncseparatoroutflow2.outflow, sink2.inflow) annotation(
    Line(points = {{28, -4}, {42, -4}}));
  connect(separator.outflow_1, connecseparatoroutflow1.inflow) annotation(
    Line(points = {{-8, 6}, {-6, 6}, {-6, 14}}));
  connect(connecseparatoroutflow1.outflow, sink1.inflow) annotation(
    Line(points = {{-6, 34}, {-6, 46}}));
end SeparatorTest;