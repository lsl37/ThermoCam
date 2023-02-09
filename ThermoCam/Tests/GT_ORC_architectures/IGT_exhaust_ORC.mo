within ThermoCam.Tests.GT_ORC_architectures;

model IGT_exhaust_ORC

  //Model for a intercooled gas turbine where the cooling medium is water, with an ORC coupled to the exhaust
  ////////////////////////////////////////////////////////////////////////////////
  //Declare inputs
  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
  package Medium_intercooling = ThermoCam.Media.Water_CP;
  package Medium_oil = ThermoCam.Media.TherminolVP1_CP;
  package Medium_ORC = ThermoCam.Media.Benzene_CP;
  package Medium_condenser_cooling = ThermoCam.Media.Air_CP;
  //////////////////////////////////////////////////////////////
  //Ambient conditions
  parameter Real Tcold = 288.15 "unit=K";
  parameter Real pcold = 101325.0 "unit=Pa";
  //Exhaust temperature stack limit of exhaust gas
  parameter Real Tstack = 105.0 + 273.15 "unit=K";
  //Specify added heat in the combustion chamber
  parameter Real Q_hot = 233.49e6 "unit=W";
  //Low pressure compressor pressure ratio
  parameter Real ph_pc_lp = 3.925;
  //High pressure compressor pressure ratio
  parameter Real ph_pc_hp = 12.25;
  Real phot_lp "unit=Pa";
  Real phot_hp "unit=Pa";
  //Available power from hot source, Qhot = m_hot * Delta(h_hot)
  //Massflow in gas turbine
  parameter Real massflow_air = 215.0 "unit =kg/s";
  //Massflow fuel
  parameter Real massflow_fuel = 5.0 "unit=kg/s";
  //Isentropic effiency low pressure compressor
  parameter Real epsilon_comp_lp = 0.86 "unit = -";
  //Isentropic effiency high pressure compressor
  parameter Real epsilon_comp_hp = 0.86 "unit = -";
  //Isentropic efficiency turbine
  parameter Real epsilon_turb = 0.888 "unit = -";
  //Isentropic efficiency for oil pump
  parameter Real epsilon_pump_oil = 0.7 "unit=-";
  //Isentropic efficiency for expander
  parameter Real epsilon_exp = 0.85 "unit=-";
  //Isentropic efficiency for pump ORC
  parameter Real epsilon_pump_orc = 0.7 "unit=-";
  ////////////////////////////////////////////////////////////////
  //Heat exchanger (intercooler) inputs
  //Admissible pressure drop hot side
  parameter Real DPhot_intercooling = 0.5e5 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_intercooling = 0.5e5 "unit=Pa";
  //Minimum admissible temperature difference
  parameter Real DTpinch_intercooling = 123.0 "unit=K";
  //Desired decrease in temperature of the hot fluid
  parameter Real DThot_intercooling = 141.0 "unit=K";
  //Incoming temperature cooling medium
  parameter Real Tcool_intercooling = 288.15 "unit=K";
  //Incoming pressure cooling medium
  parameter Real pcool_intercooling = 5.0e5 "unit=Pa";
  /////////////////////////////////////////////////////////////////
  //HRB
  parameter Real DPhot_hru = 5000.0 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_hru = 0.0 "unit=Pa";
  //Minimum admissible temperature difference
  parameter Real DTpinch_hru = 60.0 "unit=K";
  /////////////////////////////////////////////////////////////////
  parameter Real p_oil = 10.0e5 "unit=Pa";
  /////////////////////////////////////////////////////////////////
  //Condenser inputs
  parameter Real DPhot_condenser = 5000.0 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_condenser = 500.0 "unit=Pa";
  //Minimum admissible temperature difference
  parameter Real DTpinch_condenser = 20.0 "unit=K";
  //Determine temperature above cooling medium + pinch point temperature difference to condense fluid at
  parameter Real DTcond = 5.0 "unit=K";
  //Incoming temperature cooling medium
  parameter Real Tcool_condenser_cooling = 288.15 "unit=K";
  //Incoming pressure cooling medium
  parameter Real pcool_condenser_cooling = 101325.0 "unit=Pa";
  /////////////////////////////////////////////////////////////////
  //Evaporator inputs
  //ORC turbine inlet pressure
  parameter Real p_orc_exp = 2.0e5 "unit=Pa";
  parameter Real DTpinch_evap = 20.0 "unit=K";
  parameter Real DPhot_evap = 0.0 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_evap = 5000.0 "unit=Pa";
  /////////////////////////////////////////////////////////////////




//Declare class instances (must redeclare medium in all instances)
  ThermoCam.Sources_and_sinks.Sources.Source_pT airin(redeclare package Medium = Medium_in, p_su=pcold, T_su=Tcold,m_flow=massflow_air) annotation(
    Placement(visible = true, transformation(origin = {-190, -78}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandComp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-144, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor_lp(redeclare package Medium = Medium_in, epsilon_s = epsilon_comp_lp) annotation(
    Placement(visible = true, transformation(origin = {-113, -75}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Combustionchamber combustionchamber(redeclare package Medium_in = Medium_in, redeclare package Medium_out =Medium_out,Q_add = Q_hot, m_fuel = massflow_fuel,p_su=phot_hp) annotation(
    Placement(visible = true, transformation(origin = {87, -71}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCombandTurb(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {128, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine turbine(redeclare package Medium = Medium_out, epsilon_s=epsilon_turb) annotation(
    Placement(visible = true, transformation(origin = {170, -68}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Intercooler intercooler(redeclare package Medium_cold = Medium_intercooling, redeclare package Medium_hot = Medium_in, DPhot=DPhot_intercooling,DPcold=DPcold_intercooling,DThot=DThot_intercooling,DTpinch=DTpinch_intercooling,p_su_hot=phot_lp) annotation(
    Placement(visible = true, transformation(origin = {-52, -128}, extent = {{-28, -28}, {28, 28}}, rotation = 180)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandIntercooler(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-88, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT waterin(redeclare package Medium = Medium_intercooling, p_su=pcool_intercooling,T_su=Tcool_intercooling) annotation(
    Placement(visible = true, transformation(origin = {14, -136}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecWaterinandIntercooler(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-12, -136}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerandWaterout(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-92, -136}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor_hp(redeclare package Medium = Medium_in,epsilon_s=epsilon_comp_hp) annotation(
    Placement(visible = true, transformation(origin = {23, -73}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerandCompressor_hp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-10, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandComb(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {54, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Intercooler HRU(redeclare package Medium_cold = Medium_oil, redeclare package Medium_hot = Medium_out,DPhot=DPhot_hru,DPcold=DPcold_hru,DTpinch=DTpinch_hru,p_su_cold = p_oil) annotation(
    Placement(visible = true, transformation(origin = {235, -29}, extent = {{27, -27}, {-27, 27}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecTurbandHRU(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {200, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecHRUandOut(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {278, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Evaporator evaporator(redeclare package Medium_cold = Medium_ORC,redeclare package Medium_hot=Medium_oil,p_evap=p_orc_exp,DPhot=DPhot_evap,DPcold=DPcold_evap,DTpinch=DTpinch_evap) annotation(
    Placement(visible = true, transformation(origin = {18, 18}, extent = {{-34, -34}, {34, 34}}, rotation = 0)));
  ThermoCam.Units.LoopBreaker.ClosedLoopConnector closedLoopConnectorOil(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {-96, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecHRUandEvaporator(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {94, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecEvaporatorandLoopconnector(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {-40, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecLoopconnectorandPump(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {-64, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Pump pumpOil(redeclare package Medium = Medium_oil, epsilon_s= epsilon_pump_oil) annotation(
    Placement(visible = true, transformation(origin = {-22, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecPumpandHRU(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {18, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecEvaporatorandExpander(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {70, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecPumpORCandCondenser(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-74, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Sources_and_sinks.Sources.Source_T ORCin(redeclare package Medium = Medium_ORC,T_su = 20.0 + 273.15) annotation(
    Placement(visible = true, transformation(origin = {-134, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink ORCout(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {160, 48}, extent = {{10, 10}, {-10, -10}}, rotation = 0)));
  Sources_and_sinks.Sinks.Sink waterout(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {-126, -134}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_pT fluegasOut(redeclare package Medium = Medium_out, T_su = Tstack,p_su = pcold) annotation(
    Placement(visible = true, transformation(origin = {322, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
//Momentum balance
  phot_lp = ph_pc_lp*pcold;
  phot_hp = ph_pc_hp*phot_lp;
  connect(airin.outflow, connecInandComp.inflow) annotation(
    Line(points = {{-173.44, -78}, {-164.44, -78}, {-164.44, -76}, {-155.44, -76}}));
  connect(combustionchamber.outflow, connecCombandTurb.inflow) annotation(
    Line(points = {{103.38, -70.16}, {117.38, -70.16}}));
  connect(connecCombandTurb.outflow, turbine.inflow) annotation(
    Line(points = {{138, -69.6}, {152, -69.6}, {152, -67.6}}));
  connect(connecInandComp.outflow, compressor_lp.inflow) annotation(
    Line(points = {{-134, -75.6}, {-132, -75.6}, {-132, -73.6}, {-130, -73.6}}));
  connect(compressor_lp.outflow, connecCompandIntercooler.inflow) annotation(
    Line(points = {{-98.18, -75}, {-98.18, -95}}));
  connect(connecCompandIntercooler.outflow, intercooler.inflow_hot) annotation(
    Line(points = {{-78, -93.6}, {-75, -93.6}, {-75, -114.6}}));
  connect(waterin.outflow, connecWaterinandIntercooler.inflow) annotation(
    Line(points = {{4.8, -136}, {-1.2, -136}}));
  connect(connecWaterinandIntercooler.outflow, intercooler.inflow_cold) annotation(
    Line(points = {{-22, -135.6}, {-26, -135.6}}));
  connect(intercooler.outflow_cold, connecIntercoolerandWaterout.inflow) annotation(
    Line(points = {{-74.96, -135.28}, {-82.96, -135.28}}));
  connect(intercooler.outflow_hot, connecIntercoolerandCompressor_hp.inflow) annotation(
    Line(points = {{-29.6, -113.44}, {-23.6, -113.44}, {-23.6, -100.44}, {-20.6, -100.44}, {-20.6, -74.44}}));
  connect(connecIntercoolerandCompressor_hp.outflow, compressor_hp.inflow) annotation(
    Line(points = {{0, -73.6}, {3, -73.6}, {3, -72.6}, {4, -72.6}}));
  connect(compressor_hp.outflow, connecCompandComb.inflow) annotation(
    Line(points = {{39.38, -73}, {42.88, -73}, {42.88, -74}, {43.38, -74}}));
  connect(connecCompandComb.outflow, combustionchamber.inflow) annotation(
    Line(points = {{64, -73.6}, {70, -73.6}, {70, -69.6}}));
  connect(turbine.outflow, connecTurbandHRU.inflow) annotation(
    Line(points = {{186.28, -68}, {190.28, -68}, {190.28, -58}}));
  connect(connecTurbandHRU.outflow, HRU.inflow_hot) annotation(
    Line(points = {{210, -57.6}, {212, -57.6}, {212, -41.6}}));
  connect(HRU.outflow_hot, connecHRUandOut.inflow) annotation(
    Line(points = {{256.6, -43.04}, {268.6, -43.04}, {268.6, -61.04}}));
  connect(HRU.outflow_cold, connecHRUandEvaporator.inflow) annotation(
    Line(points = {{212.86, -21.98}, {130.86, -21.98}, {130.86, 0.02}, {104.86, 0.02}}));
  connect(connecHRUandEvaporator.outflow, evaporator.inflow_hot) annotation(
    Line(points = {{84, 0.4}, {64, 0.4}, {64, 6.4}, {44, 6.4}}));
  connect(evaporator.outflow_hot, connecEvaporatorandLoopconnector.inflow) annotation(
    Line(points = {{-5.12, 5.76}, {-29.12, 5.76}}));
  connect(connecEvaporatorandLoopconnector.outflow, closedLoopConnectorOil.inflow) annotation(
    Line(points = {{-50, 6.4}, {-118, 6.4}, {-118, -25.6}, {-104, -25.6}}));
  connect(closedLoopConnectorOil.outflow, connecLoopconnectorandPump.inflow) annotation(
    Line(points = {{-87.8, -26}, {-73.8, -26}}));
  connect(connecLoopconnectorandPump.outflow, pumpOil.inflow) annotation(
    Line(points = {{-54, -25.6}, {-46, -25.6}, {-46, -31.6}, {-30, -31.6}}));
  connect(pumpOil.outflow, connecPumpandHRU.inflow) annotation(
    Line(points = {{-14.2, -32}, {7.8, -32}}));
  connect(connecPumpandHRU.outflow, HRU.inflow_cold) annotation(
    Line(points = {{28, -31.6}, {198, -31.6}, {198, -3.6}, {276, -3.6}, {276, -21.6}, {260, -21.6}}));
  connect(evaporator.outflow_cold, connecEvaporatorandExpander.inflow) annotation(
    Line(points = {{42.48, 27.52}, {60.48, 27.52}}));
  connect(connecPumpORCandCondenser.outflow, evaporator.inflow_cold) annotation(
    Line(points = {{-64, 34}, {-8, 34}, {-8, 28}}));
  connect(ORCin.outflow, connecPumpORCandCondenser.inflow) annotation(
    Line(points = {{-124, 44}, {-106, 44}, {-106, 34}, {-84, 34}}));
  connect(connecEvaporatorandExpander.outflow, ORCout.inflow) annotation(
    Line(points = {{80, 28}, {142, 28}, {142, 48}, {152, 48}}));
  connect(connecIntercoolerandWaterout.outflow, waterout.inflow) annotation(
    Line(points = {{-102, -136}, {-110, -136}, {-110, -134}, {-118, -134}}));
  connect(connecHRUandOut.outflow, fluegasOut.inflow) annotation(
    Line(points = {{288, -62}, {314, -62}, {314, -60}}));
  annotation(
    Icon);
end IGT_exhaust_ORC;