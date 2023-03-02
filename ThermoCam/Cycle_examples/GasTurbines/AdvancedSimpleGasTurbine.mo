within ThermoCam.Cycle_examples.GasTurbines;

model AdvancedSimpleGasTurbine

//Declare inputs
  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
  parameter Medium_in.MassFraction Xnom[Medium_in.nX] = Medium_in.reference_X "Nominal gas composition";
  parameter Medium_out.MassFraction Xnom_out[Medium_out.nX] = Medium_out.reference_X "Nominal gas composition";
  
  //Ambient conditions
  parameter Real Tcold = 288.15 "unit=K";
  parameter Real pcold = 101325.0 "unit=Pa";
  //Specify added heat in the combustion chamber
  parameter Real Q_hot = 1000000.0 "unit=W";
  //Compressor pressure ratio
  parameter Real ph_pc = 16.0;
  Real phot "unit=Pa";
  //Massflow in gas turbine
  parameter Real massflow_air = 1.0 "unit =kg/s";
  //Massflow fuel
  parameter Real massflow_fuel = 0.0 "unit=kg/s";
  //Polytropic effiency compressor
  parameter Real epsilon_comp = 0.9 "unit = -";
  //Polytropic efficiency turbine
  parameter Real epsilon_turb = 0.9 "unit = -";
  //Number of compressor stages
  parameter Integer n_stages_comp = 20;
  //Number of turbine stages
  parameter Integer n_stages_turb = 9;
  //Cooling fraction
  parameter Real cooling_fraction = 0.2;
  



//Declare class instances (must redeclare medium in all instances)
  ThermoCam.Sources_and_sinks.Sources.Source_pT airin(redeclare package Medium = Medium_in, p_su=pcold, T_su=Tcold,m_flow=massflow_air,X=Xnom) annotation(
    Placement(visible = true, transformation(origin = {-190, -4}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandComp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-150, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Combustionchamber combustionchamber(redeclare package Medium_in = Medium_in, redeclare package Medium_out =Medium_out,Q_add = Q_hot, m_fuel = massflow_fuel,p_su=phot) annotation(
    Placement(visible = true, transformation(origin = {-13, -3}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p airout(redeclare package Medium = Medium_out, p_su = pcold) annotation(
    Placement(visible = true, transformation(origin = {158, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecTurbandOut(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {124, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor_polytropic compressor(redeclare package Medium = Medium_in, epsilon_p = epsilon_comp, n_stages = n_stages_comp) annotation(
    Placement(visible = true, transformation(origin = {-109, -3}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine_polytropic turbine(redeclare package Medium = Medium_out, epsilon_p = epsilon_turb, n_stages = n_stages_turb, p_su = phot) annotation(
    Placement(visible = true, transformation(origin = {92, 0}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Mixers_and_Separators.Massflow_Separator separator(redeclare package Medium_in = Medium_in, redeclare package Medium_out1 = Medium_in, redeclare package Medium_out2 = Medium_in, m_fraction1 = cooling_fraction) annotation(
    Placement(visible = true, transformation(origin = {-66, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompSeparator(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-86, -4}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecSeparatorComb(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-42, -4}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecSeparatorMixer(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-14, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mixers_and_Separators.Massflow_Mixer mixer(redeclare package Medium_in1 = Medium_out, redeclare package Medium_in2 = Medium_in, redeclare package Medium_out= Medium_out) annotation(
    Placement(visible = true, transformation(origin = {42, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCombMixer(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {17, -3}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecMixerTurbine(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {64, -2}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
equation
//Momentum balance
  phot = ph_pc*pcold;
  connect(airin.outflow, connecInandComp.inflow) annotation(
    Line(points = {{-173, -4}, {-161, -4}}));
  connect(connecTurbandOut.outflow, airout.inflow) annotation(
    Line(points = {{134, 0.4}, {150, 0.4}}));
  connect(connecInandComp.outflow, compressor.inflow) annotation(
    Line(points = {{-140, -4}, {-127, -4}, {-127, -3}, {-124, -3}}));
  connect(turbine.outflow, connecTurbandOut.inflow) annotation(
    Line(points = {{105, 0}, {114, 0}}));
  connect(compressor.outflow, connecCompSeparator.inflow) annotation(
    Line(points = {{-96, -2}, {-92, -2}, {-92, -4}}));
  connect(connecCompSeparator.outflow, separator.inflow) annotation(
    Line(points = {{-80, -4}, {-76, -4}}));
  connect(separator.outflow_2, connecSeparatorComb.inflow) annotation(
    Line(points = {{-56, -4}, {-50, -4}}));
  connect(connecSeparatorComb.outflow, combustionchamber.inflow) annotation(
    Line(points = {{-34, -4}, {-30, -4}, {-30, -2}}));
  connect(separator.outflow_1, connecSeparatorMixer.inflow) annotation(
    Line(points = {{-66, 6}, {-66, 42}, {-24, 42}}));
  connect(combustionchamber.outflow, connecCombMixer.inflow) annotation(
    Line(points = {{4, -2}, {10, -2}}));
  connect(connecCombMixer.outflow, mixer.inflow1) annotation(
    Line(points = {{24, -2}, {32, -2}}));
  connect(connecSeparatorMixer.outflow, mixer.inflow2) annotation(
    Line(points = {{-4, 42}, {42, 42}, {42, 8}}));
  connect(mixer.outflow, connecMixerTurbine.inflow) annotation(
    Line(points = {{52, -2}, {58, -2}}));
  connect(connecMixerTurbine.outflow, turbine.inflow) annotation(
    Line(points = {{70, -2}, {78, -2}, {78, 0}}));
  annotation(
    Icon);
end AdvancedSimpleGasTurbine;