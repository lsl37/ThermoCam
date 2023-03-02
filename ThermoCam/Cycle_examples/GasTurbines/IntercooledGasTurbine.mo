within ThermoCam.Cycle_examples.GasTurbines;

model IntercooledGasTurbine

//Declare inputs
  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
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
  //Isentropic effiency compressor_lp
  parameter Real epsilon_comp_lp = 1.0 "unit = -";
  //Isentropic effiency compressor_hp
  parameter Real epsilon_comp_hp = 1.0 "unit = -";
  //Isentropic efficiency turbine
  parameter Real epsilon_turb = 1.0 "unit = -";
  
  //Heat exchanger inputs
  //Admissible pressure drop hot side
  parameter Real DPhot = 5000.0 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold = 5000.0 "unit=Pa";
  //Minimum admissible temperature difference
  parameter Real DTpinch = 10.0 "unit=K";
  //Desired decrease in temperature of the hot fluid
  parameter Real DThot = 50.0 "unit=K";
  //Incoming temperature cooling medium
  parameter Real Tcool = 293.15 "unit=K";
  //Incoming pressure cooling medium
  parameter Real pcool = 101325.0 "unit=Pa";





//Declare class instances (must redeclare medium in all instances)
  ThermoCam.Sources_and_sinks.Sources.Source_pT airin(redeclare package Medium = Medium_in, p_su=pcold, T_su=Tcold,m_flow=massflow_air,X=Xnom) annotation(
    Placement(visible = true, transformation(origin = {-230, 12}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandComp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-184, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor_lp(redeclare package Medium = Medium_in, epsilon_s = epsilon_comp_lp) annotation(
    Placement(visible = true, transformation(origin = {-153, 15}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Combustionchamber combustionchamber(redeclare package Medium_in = Medium_in, redeclare package Medium_out =Medium_out,Q_add = Q_hot, m_fuel = massflow_fuel,p_su=phot_hp) annotation(
    Placement(visible = true, transformation(origin = {47, 19}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCombandTurb(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {88, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine turbine(redeclare package Medium = Medium_out, epsilon_s=epsilon_turb) annotation(
    Placement(visible = true, transformation(origin = {130, 22}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p airout(redeclare package Medium = Medium_out, p_su = pcold) annotation(
    Placement(visible = true, transformation(origin = {206, 22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecTurbandOut(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {172, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Intercooler intercooler(redeclare package Medium_cold = Medium_intercooling, redeclare package Medium_hot = Medium_in, DPhot=DPhot,DPcold=DPcold,DThot=DThot,DTpinch=DTpinch,p_su_hot=phot_lp) annotation(
    Placement(visible = true, transformation(origin = {-92, -38}, extent = {{-28, -28}, {28, 28}}, rotation = 180)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandIntercooler(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-128, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT waterin(redeclare package Medium = Medium_intercooling, p_su=pcool,T_su=Tcool, X=Xnom_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-26, -46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecWaterinandIntercooler(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-52, -46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerandWaterout(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-132, -46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor_hp(redeclare package Medium = Medium_in,epsilon_s=epsilon_comp_hp) annotation(
    Placement(visible = true, transformation(origin = {-17, 17}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerandCompressor_hp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-50, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandComb(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {14, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink waterout(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-164, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Momentum balance
  phot_lp = ph_pc_lp*pcold;
  phot_hp = ph_pc_hp*phot_lp;
  connect(airin.outflow, connecInandComp.inflow) annotation(
    Line(points = {{-213.44, 12}, {-204.44, 12}, {-204.44, 14}, {-195.44, 14}}));
  connect(combustionchamber.outflow, connecCombandTurb.inflow) annotation(
    Line(points = {{63.38, 19.84}, {77.38, 19.84}}));
  connect(connecCombandTurb.outflow, turbine.inflow) annotation(
    Line(points = {{98, 20.4}, {112, 20.4}, {112, 22.4}}));
  connect(turbine.outflow, connecTurbandOut.inflow) annotation(
    Line(points = {{146.28, 22}, {162.28, 22}}));
  connect(connecTurbandOut.outflow, airout.inflow) annotation(
    Line(points = {{182, 22.4}, {198, 22.4}}));
  connect(connecInandComp.outflow, compressor_lp.inflow) annotation(
    Line(points = {{-174, 14.4}, {-172, 14.4}, {-172, 16.4}, {-170, 16.4}}));
  connect(compressor_lp.outflow, connecCompandIntercooler.inflow) annotation(
    Line(points = {{-138.18, 15}, {-138.18, -5}}));
  connect(connecCompandIntercooler.outflow, intercooler.inflow_hot) annotation(
    Line(points = {{-118, -4}, {-115, -4}, {-115, -25}}));
  connect(waterin.outflow, connecWaterinandIntercooler.inflow) annotation(
    Line(points = {{-35.2, -46}, {-41.2, -46}}));
  connect(connecWaterinandIntercooler.outflow, intercooler.inflow_cold) annotation(
    Line(points = {{-62, -45.6}, {-66, -45.6}}));
  connect(intercooler.outflow_cold, connecIntercoolerandWaterout.inflow) annotation(
    Line(points = {{-114.96, -45.28}, {-122.96, -45.28}}));
  connect(intercooler.outflow_hot, connecIntercoolerandCompressor_hp.inflow) annotation(
    Line(points = {{-70, -23}, {-64, -23}, {-64, -10}, {-61, -10}, {-61, 16}}));
  connect(connecIntercoolerandCompressor_hp.outflow, compressor_hp.inflow) annotation(
    Line(points = {{-40, 16}, {-37, 16}, {-37, 17}, {-36, 17}}));
  connect(compressor_hp.outflow, connecCompandComb.inflow) annotation(
    Line(points = {{-1, 17}, {2.5, 17}, {2.5, 16}, {3, 16}}));
  connect(connecCompandComb.outflow, combustionchamber.inflow) annotation(
    Line(points = {{24, 16}, {30, 16}, {30, 20}}));
  connect(connecIntercoolerandWaterout.outflow, waterout.inflow) annotation(
    Line(points = {{-142, -46}, {-156, -46}}));
  annotation(
    Icon);
end IntercooledGasTurbine;