within ThermoCam.Interfaces;

partial connector Port  
  //Thermodynamic state of a fluid before or after component.
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  
  //Mass flow variable
  flow Modelica.SIunits.MassFlowRate m_dot "unit=kg/s";
  
  //Thermodynamic pressure in the connection point
  Medium.AbsolutePressure p "unit = Pa";
  
  //Specific thermodynamic enthalpy close to the connection point if m_flow < 0
  stream Medium.SpecificEnthalpy h_outflow "unit = J/kg";
  
  //stream Medium.MassFraction Xi_outflow[Medium.nXi] "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
  annotation(
    Icon(graphics = {Rectangle(fillColor = {159, 159, 223}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, 40}, {80, -40}})}),
    Diagram(graphics = {Rectangle(fillColor = {159, 159, 223}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-80, 40}, {80, -40}})}));
end Port;