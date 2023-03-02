within ThermoCam.Units.Mixers_and_Separators;

model Massflow_Mixer
  //Mix two massflows into one, no chemical mixing
  //Assumes ideal mixing of enthalpies
  //Flow medium
  replaceable package Medium_in1 = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  replaceable package Medium_in2 = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  replaceable package Medium_out = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  ThermoCam.Interfaces.Inflow inflow1(redeclare package Medium = Medium_in1) annotation(
    Placement(visible = true, transformation(origin = {-74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Interfaces.Outflow outflow(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Interfaces.Inflow inflow2(redeclare package Medium = Medium_in2) annotation(
    Placement(visible = true, transformation(origin = {0, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));


  //Mass fractions of incoming flows
  Real m_fraction1;
  Real m_fraction2;
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  parameter Medium_in1.MassFraction Xnom_in1[Medium_in1.nX] = Medium_in1.reference_X;
  parameter Medium_in2.MassFraction Xnom_in2[Medium_in2.nX] = Medium_in2.reference_X;
  Medium_out.MassFraction X_out[Medium_out.nXi];

equation
/*Mass balance*/
  m_fraction1 + m_fraction2 = 1.0;
  m_fraction1 = abs(inflow1.m_dot)/abs(outflow.m_dot);
  if inflow1.m_dot < 0 then
    outflow.m_dot = abs(inflow1.m_dot) + abs(inflow2.m_dot);
  else
    outflow.m_dot = -(abs(inflow1.m_dot) + abs(inflow2.m_dot));
  end if;
  
/*Energy balance*/
  //Assumes ideal mixing
  outflow.h_outflow = (abs(inflow1.m_dot)*inflow1.h_outflow +  abs(inflow2.m_dot)*inflow2.h_outflow)/abs(outflow.m_dot); //J/kg
/*Momentum balance*/
  //Determined by downstream pressure
  
/*Species balance*/
  X_out = (abs(inflow1.m_dot)*inflow1.Xi_outflow + abs(inflow2.m_dot)*inflow2.Xi_outflow)/(abs(outflow.m_dot));
  outflow.Xi_outflow = X_out;
  annotation(
    Icon(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-80, 40}, {-80, -40}, {0, 0}, {-80, 40}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}}), Polygon( rotation = 90,lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}})}));
annotation(
    Icon(graphics = {Polygon(rotation = 90, lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-80, 40}, {-80, -40}, {0, 0}, {-80, 40}})}));
end Massflow_Mixer;