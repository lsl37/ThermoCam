within ThermoCam.Units.Streamconnector;

model Streamconnector
  //Created to connect stream nodes.
  
  //Includes mass fractions
  
  //Flow medium
  replaceable package Medium = ThermoCam.Media.DummyFluid constrainedby Modelica.Media.Interfaces.PartialMedium "Medium model" annotation(
     choicesAllMatching = true);
  /*Ports */
  //Initialisation variables
  parameter Modelica.SIunits.Pressure p_nom = 1e5 "Nominal inlet pressure";
  parameter Modelica.SIunits.Temperature T_nom = 423.15 "Nominal inlet temperature";
  parameter Medium.MassFraction Xnom[Medium.nX] = Medium.reference_X; 
  
  /*FluidState */
  Medium.ThermodynamicState fluidState(p(start = p_nom), T(start = T_nom));
  Interfaces.Inflow inflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {-108, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-108, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Outflow outflow(redeclare package Medium = Medium) annotation(
    Placement(visible = true, transformation(origin = {100, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
/*Mass balance*/
  inflow.m_dot + outflow.m_dot = 0;
/*Fluid properties */
  if size(inflow.Xi_outflow,1) > 0 then
    fluidState = Medium.setState_phX(inflow.p, inStream(inflow.h_outflow), inStream(inflow.Xi_outflow));
  else
    fluidState = Medium.setState_phX(inflow.p, inStream(inflow.h_outflow), Xnom);
  end if;
/*Energy balance*/
  inflow.h_outflow = outflow.h_outflow;
/*Species balance*/
  inflow.Xi_outflow = outflow.Xi_outflow;
/*Momentum balance*/
  inflow.p = outflow.p;
// Boundary conditions, enthalpy stays constant
  inflow.h_outflow = inStream(outflow.h_outflow);
  inStream(inflow.h_outflow) = outflow.h_outflow;
  
  inflow.Xi_outflow = inStream(outflow.Xi_outflow);
  inStream(inflow.Xi_outflow) = outflow.Xi_outflow;
  
  annotation(
    Icon(graphics = {Line(origin = {9.58, 43.96}, points = {{-73.5811, 2.04043}, {-57.5811, 10.0404}, {-35.5811, -1.95957}, {-7.58112, 10.0404}, {18.4189, -5.95957}, {50.4189, 4.04043}, {74.4189, -9.95957}, {72.4189, -9.95957}}, color = {85, 170, 255}, thickness = 0.5), Line(origin = {8.09, 3.02}, points = {{-78.0915, -3.01942}, {-42.0915, 6.98058}, {-8.09153, -7.01942}, {19.9085, 4.98058}, {43.9085, -7.01942}, {65.9085, 6.98058}, {77.9085, -5.01942}, {77.9085, -5.01942}}, color = {85, 170, 255}, thickness = 0.5), Line(origin = {7.72, 17.76}, points = {{-73.7156, -3.76482}, {-39.7156, 8.23518}, {-1.71565, -5.76482}, {38.2844, 8.23518}, {74.2844, -5.76482}, {72.2844, -7.76482}}, color = {85, 170, 255}, thickness = 0.5), Line(origin = {12.69, -27.02}, points = {{-78.6937, 3.01916}, {-46.6937, -6.98084}, {-16.6937, 7.01916}, {15.3063, -6.98084}, {41.3063, 3.01916}, {67.3063, -6.98084}, {79.3063, 3.01916}, {77.3063, 3.01916}}, color = {85, 170, 255}, thickness = 0.5)}),
    Diagram(graphics = {Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{80, 40}, {0, 0}, {80, -40}, {80, 40}}), Polygon(lineColor = {128, 128, 128}, fillColor = {159, 159, 223}, fillPattern = FillPattern.Solid, lineThickness = 0.5, points = {{-80, 40}, {-80, -40}, {0, 0}, {-80, 40}}), Rectangle(fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, 40}}), Line(points = {{0, 40}, {0, 0}}, thickness = 0.5)}));
end Streamconnector;