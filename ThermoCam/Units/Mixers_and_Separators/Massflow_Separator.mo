within ThermoCam.Units.Mixers_and_Separators;

model Massflow_Separator
  //Separate massflow in two fractions, no chemical separation
  
  //Flow medium
  replaceable package Medium_in = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  replaceable package Medium_out1 = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  replaceable package Medium_out2 = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  
  /*Ports */
  ThermoCam.Interfaces.Inflow inflow(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-64, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Interfaces.Outflow outflow_1(redeclare package Medium = Medium_out1) annotation(
    Placement(visible = true, transformation(origin = {0, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  ThermoCam.Interfaces.Outflow outflow_2(redeclare package Medium = Medium_out2) annotation(
    Placement(visible = true, transformation(origin = {76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  
  //Specify mass fractions in each outflow
  parameter Real m_fraction1;
  Real m_fraction2;
  
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  parameter Medium_in.MassFraction Xnom_in[Medium_in.nX] = Medium_in.reference_X;
  parameter Medium_out1.MassFraction Xnom_out1[Medium_out1.nX] = Medium_out1.reference_X;
  parameter Medium_out2.MassFraction Xnom_out2[Medium_out2.nX] = Medium_out2.reference_X;
  
  
equation
/*Mass balance*/
  m_fraction1 + m_fraction2 = 1.0;
  inflow.m_dot + outflow_1.m_dot + outflow_2.m_dot = 0;
  outflow_1.m_dot = -m_fraction1*inflow.m_dot;
/*Energy balance*/
  inflow.h_outflow = outflow_1.h_outflow;
  inflow.h_outflow = outflow_2.h_outflow;
/*Momentum balance*/
  inflow.p = outflow_1.p;
  inflow.p = outflow_2.p;
//Species balance
  inflow.Xi_outflow = outflow_1.Xi_outflow;
  inflow.Xi_outflow = outflow_2.Xi_outflow;

   
  annotation(
    Icon(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-80, 40}, {-80, -40}, {0, 0}, {-80, 40}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}}), Polygon( rotation = 90,lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}})}));
end Massflow_Separator;