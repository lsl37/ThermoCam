within ThermoCam.Tests.GT_ORC_architectures;

model condenser_test

  package Medium_ORC = ThermoCam.Media.Benzene_CP;
  package Medium_condenser_cooling = ThermoCam.Media.Air_CP;
  Sources_and_sinks.Sources.Source_pT coldsource(redeclare package Medium = Medium_condenser_cooling, p_su=101325.0,T_su=288.15) annotation(
    Placement(visible = true, transformation(origin = {-122, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink coldsink(redeclare package Medium = Medium_condenser_cooling) annotation(
    Placement(visible = true, transformation(origin = {98, 18}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Sources_and_sinks.Sinks.Sink hotsink(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-114, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector coldsourceconnec(redeclare package Medium = Medium_condenser_cooling) annotation(
    Placement(visible = true, transformation(origin = {-86, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector coldsinkconnec(redeclare package Medium = Medium_condenser_cooling) annotation(
    Placement(visible = true, transformation(origin = {54, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector hotsourceconnec(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {56, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector hotsinkconnec(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-74, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_T hotsource(redeclare package Medium = Medium_ORC, T_su = 60.0 + 273.15,m_flow=10.0) annotation(
    Placement(visible = true, transformation(origin = {96, -12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Condenser condenser(redeclare package Medium_cold = Medium_condenser_cooling, redeclare package Medium_hot = Medium_ORC, DPhot=0.0,DPcold=0.0,DTpinch= 10.0,T_cond = 288.15 + 10.0+10.0) annotation(
    Placement(visible = true, transformation(origin = {-16, -4}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
equation
  connect(coldsource.outflow, coldsourceconnec.inflow) annotation(
    Line(points = {{-112, 16}, {-96, 16}, {-96, 12}}));
  connect(coldsinkconnec.outflow, coldsink.inflow) annotation(
    Line(points = {{64, 14}, {90, 14}, {90, 18}}));
  connect(hotsinkconnec.outflow, hotsink.inflow) annotation(
    Line(points = {{-84, -16}, {-106, -16}, {-106, -12}}));
  connect(hotsource.outflow, hotsourceconnec.inflow) annotation(
    Line(points = {{86, -12}, {66, -12}, {66, -10}}));
  connect(hotsourceconnec.outflow, condenser.inflow_hot) annotation(
    Line(points = {{46, -10}, {2, -10}, {2, -14}}));
  connect(condenser.outflow_hot, hotsinkconnec.inflow) annotation(
    Line(points = {{-34, -12}, {-48, -12}, {-48, -16}, {-64, -16}}));
  connect(coldsourceconnec.outflow, condenser.inflow_cold) annotation(
    Line(points = {{-76, 12}, {-56, 12}, {-56, 2}, {-34, 2}}));
  connect(condenser.outflow_cold, coldsinkconnec.inflow) annotation(
    Line(points = {{0, 2}, {20, 2}, {20, 14}, {44, 14}}));
end condenser_test;