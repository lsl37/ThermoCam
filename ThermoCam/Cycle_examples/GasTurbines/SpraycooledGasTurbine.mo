within ThermoCam.Cycle_examples.GasTurbines;

model SpraycooledGasTurbine

//Declare inputs
  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
  package Medium_watervapour = ThermoCam.Media.WaterVapour;
  package Medium_intercooling = ThermoCam.Media.Water_CP;
  parameter Medium_in.MassFraction Xnom[Medium_in.nX] = Medium_in.reference_X "Nominal gas composition";
  parameter Medium_out.MassFraction Xnom_out[Medium_out.nX] = Medium_out.reference_X "Nominal gas composition";
  //parameter Medium_intercooling.MassFraction Xnom_intercooling[Medium_intercooling.nX] = Medium_intercooling.reference_X "Nominal composition";
  parameter Real Xnom_intercooling[0];
  
  
  //Ambient conditions
  parameter Real Tcold = 288.15 "unit=K";
  parameter Real pcold = 101325.0 "unit=Pa";
  //Specify added heat in the combustion chamber
  parameter Real Q_hot = 100000.0 "unit=W";
  //Compressor pressure ratio
  parameter Real ph_pc_lp = 4.0;
  parameter Real ph_pc_hp = 4.0;
  Real phot_lp "unit=Pa";
  Real phot_hp "unit=Pa";
  //Massflow in gas turbine
  parameter Real massflow_air = 1.0 "unit =kg/s";
  //Massflow fuel
  parameter Real massflow_fuel = 0.0 "unit=kg/s";
  //Polytropic effiency compressor_lp
  parameter Real epsilon_comp_lp = 0.9 "unit = -";
  //Number of stages low pressure compressor
  parameter Integer n_stages_comp_lp = 4 "unit=-";
  //Polytropic effiency compressor_hp
  parameter Real epsilon_comp_hp = 0.9 "unit = -";
  //Number of stages low pressure compressor
  parameter Integer n_stages_comp_hp = 16 "unit=-";
  //Polytropic efficiency turbine
  parameter Real epsilon_turb = 0.9 "unit = -";
  //Number of stages turbine
  parameter Integer n_stages_turb = 9 "unit=-";
  //Isentropic efficiecy of pump
  parameter Real epsilon_pump = 0.7 "unit=-";
  
  
  //Incoming temperature cooling medium
  parameter Real Tcool = 293.15 "unit=K";
  //Incoming pressure cooling medium
  parameter Real pcool = 101325.0 "unit=Pa";
  //Outlet humidity
  parameter Real humidity_out = 0.95 "unit=-";
  //Pressure loss factor in spray intercooler
  parameter Real spray_loss_factor = 0.005 "unit=-";

  //Cooling fraction
  parameter Real cooling_fraction = 0.2;




//Declare class instances (must redeclare medium in all instances)
  ThermoCam.Sources_and_sinks.Sources.Source_pT airin(redeclare package Medium = Medium_in, p_su=pcold, T_su=Tcold,m_flow=massflow_air,X=Xnom) annotation(
    Placement(visible = true, transformation(origin = {-254, 16}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandComp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-202, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompressorntercooler(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-135, 15}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.WaterSprayCooler waterSprayCooler(redeclare package Medium = Medium_in, redeclare package Medium_water = Medium_intercooling, redeclare package Medium_waterg = Medium_watervapour, humidity_out=humidity_out, pressure_loss_factor = spray_loss_factor, p_su = phot_lp) annotation(
    Placement(visible = true, transformation(origin = {-90, 16}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT waterin(redeclare package Medium = Medium_intercooling, p_su = pcool, T_su = Tcool, X = Xnom_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-106, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  ThermoCam.Units.Streamconnector.Streamconnector connecWaterPump(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-109, -65}, extent = {{-3, 3}, {3, -3}}, rotation = 90)));
  ThermoCam.Units.Mechanical.Pump pump(redeclare package Medium = Medium_intercooling, epsilon_s = epsilon_pump) annotation(
    Placement(visible = true, transformation(origin = {-108, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  ThermoCam.Units.Streamconnector.Streamconnector connecPumpIntercooler(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-108, -26}, extent = {{-6, -6}, {6, 6}}, rotation = 90)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerBypassSink(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-56, -24}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink bypassSink(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-26, -24}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor_polytropic compressor_lp(redeclare package Medium = Medium_in, n_stages = n_stages_comp_lp, epsilon_p = epsilon_comp_lp) annotation(
    Placement(visible = true, transformation(origin = {-167, 17}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor_polytropic compressor_hp(redeclare package Medium = Medium_in, n_stages = n_stages_comp_hp, epsilon_p = epsilon_comp_hp) annotation(
    Placement(visible = true, transformation(origin = {-8, 16}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerCompressor(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-50, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecTurbandOut(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {248, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecMixerTurbine(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {188, 18}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine_polytropic turbine(redeclare package Medium = Medium_out, epsilon_p = epsilon_turb, n_stages = n_stages_turb, p_su = phot_hp) annotation(
    Placement(visible = true, transformation(origin = {216, 20}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Mixers_and_Separators.Massflow_Separator separator(redeclare package Medium_in = Medium_in, redeclare package Medium_out1 = Medium_in, redeclare package Medium_out2 = Medium_in ,m_fraction1 = cooling_fraction) annotation(
    Placement(visible = true, transformation(origin = {58, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecSeparatorComb(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {82, 16}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  ThermoCam.Units.Mixers_and_Separators.Massflow_Mixer mixer(redeclare package Medium_in1 = Medium_out, redeclare package Medium_in2 = Medium_in, redeclare package Medium_out = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {166, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCombMixer(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {141, 17}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Combustionchamber combustionchamber(redeclare package Medium_in = Medium_in, redeclare package Medium_out = Medium_out,Q_add = Q_hot, m_fuel = massflow_fuel, p_su = phot_hp) annotation(
    Placement(visible = true, transformation(origin = {111, 17}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecSeparatorMixer(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {110, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p airout(redeclare package Medium = Medium_out,p_su = pcold) annotation(
    Placement(visible = true, transformation(origin = {282, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecCompressorhpMixer(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {28, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Momentum balance
  phot_lp = ph_pc_lp*pcold;
  phot_hp = ph_pc_hp*phot_lp;
  connect(airin.outflow, connecInandComp.inflow) annotation(
    Line(points = {{-237, 16}, {-216.33, 16}, {-216.33, 14}, {-213, 14}}));
  connect(connecCompressorntercooler.outflow, waterSprayCooler.inflow) annotation(
    Line(points = {{-128, 15}, {-112, 15}, {-112, 16}, {-108, 16}}));
  connect(waterin.outflow, connecWaterPump.inflow) annotation(
    Line(points = {{-106, -77}, {-106, -73}, {-109, -73}, {-109, -68}}));
  connect(pump.outflow, connecPumpIntercooler.inflow) annotation(
    Line(points = {{-108, -38}, {-108, -32}}));
  connect(connecPumpIntercooler.outflow, waterSprayCooler.inflow_water) annotation(
    Line(points = {{-108, -20}, {-108, -11}, {-90, -11}, {-90, -2}}));
  connect(waterSprayCooler.outflow_bypass, connecIntercoolerBypassSink.inflow) annotation(
    Line(points = {{-68, 6}, {-62, 6}, {-62, -24}}));
  connect(connecWaterPump.outflow, pump.inflow) annotation(
    Line(points = {{-109, -62}, {-109, -60}, {-108, -60}, {-108, -55}}));
  connect(connecIntercoolerBypassSink.outflow, bypassSink.inflow) annotation(
    Line(points = {{-50, -24}, {-41, -24}, {-41, -25}, {-34, -25}}));
  connect(connecInandComp.outflow, compressor_lp.inflow) annotation(
    Line(points = {{-192, 14}, {-192, 19}, {-189.5, 19}, {-189.5, 17}}));
  connect(compressor_lp.outflow, connecCompressorntercooler.inflow) annotation(
    Line(points = {{-147.5, 17}, {-142.25, 17}, {-142.25, 15}, {-143, 15}}));
  connect(waterSprayCooler.outflow, connecIntercoolerCompressor.inflow) annotation(
    Line(points = {{-68, 16}, {-60, 16}}));
  connect(connecIntercoolerCompressor.outflow, compressor_hp.inflow) annotation(
    Line(points = {{-40, 16}, {-28, 16}}));
  connect(combustionchamber.outflow, connecCombMixer.inflow) annotation(
    Line(points = {{127.38, 17.84}, {133.38, 17.84}}));
  connect(connecTurbandOut.outflow, airout.inflow) annotation(
    Line(points = {{258, 20.4}, {274, 20.4}}));
  connect(separator.outflow_2, connecSeparatorComb.inflow) annotation(
    Line(points = {{67.4, 16}, {73.4, 16}}));
  connect(connecMixerTurbine.outflow, turbine.inflow) annotation(
    Line(points = {{194, 18.24}, {202, 18.24}, {202, 20.24}}));
  connect(turbine.outflow, connecTurbandOut.inflow) annotation(
    Line(points = {{229.32, 20}, {238.32, 20}}));
  connect(connecCombMixer.outflow, mixer.inflow1) annotation(
    Line(points = {{148, 17.28}, {156, 17.28}}));
  connect(connecSeparatorComb.outflow, combustionchamber.inflow) annotation(
    Line(points = {{90, 16.32}, {94, 16.32}, {94, 18.32}}));
  connect(separator.outflow_1, connecSeparatorMixer.inflow) annotation(
    Line(points = {{58, 25.2}, {58, 61.2}, {100, 61.2}}));
  connect(mixer.outflow, connecMixerTurbine.inflow) annotation(
    Line(points = {{175.2, 18}, {181.2, 18}}));
  connect(connecSeparatorMixer.outflow, mixer.inflow2) annotation(
    Line(points = {{120, 62.4}, {166, 62.4}, {166, 28.4}}));
  connect(compressor_hp.outflow, connecCompressorhpMixer.inflow) annotation(
    Line(points = {{10, 16}, {18, 16}}));
  connect(connecCompressorhpMixer.outflow, separator.inflow) annotation(
    Line(points = {{38, 16}, {48, 16}}));
  annotation(
    Icon);
end SpraycooledGasTurbine;