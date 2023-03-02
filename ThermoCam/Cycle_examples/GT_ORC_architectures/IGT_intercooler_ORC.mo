within ThermoCam.Cycle_examples.GT_ORC_architectures;

model IGT_intercooler_ORC

  //Model for a intercooled gas turbine where the cooling medium is water, with an ORC coupled to the exhaust
  ////////////////////////////////////////////////////////////////////////////////
  //Declare inputs
  package Medium_in = ThermoCam.Media.Air_NASA;
  package Medium_out = ThermoCam.Media.FlueGas_NASA;
  package Medium_intercooling = ThermoCam.Media.Water_CP;
  package Medium_oil = ThermoCam.Media.TherminolVP1_CP;
  package Medium_ORC = ThermoCam.Media.Toluene_CP;
  package Medium_condenser_cooling = ThermoCam.Media.Air_CP;
  
  parameter Medium_in.MassFraction Xnom[Medium_in.nX] = Medium_in.reference_X "Nominal gas composition";
  parameter Medium_out.MassFraction Xnom_out[Medium_out.nX] = Medium_out.reference_X "Nominal gas composition";
  parameter Real Xnom_intercooling[0];
  parameter Real Xnom_oil[0];
  parameter Real Xnom_ORC[0];
  parameter Real Xnom_condenser_cooling[0];
  //////////////////////////////////////////////////////////////
  //Ambient conditions
  parameter Real Tcold = 288.15 "unit=K";
  parameter Real pcold = 101325.0 "unit=Pa";
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
  parameter Real DPhot_intercooling = 0.25e5 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_intercooling = 0.5e5 "unit=Pa";
  //Minimum admissible temperature difference
  parameter Real DTpinch_intercooling = 40.0 "unit=K";
  //Desired decrease in temperature of the hot fluid
  parameter Real DThot_intercooling = 58.0 "unit=K";
  //Incoming temperature cooling medium
  parameter Real Tcool_intercooling = 288.15 "unit=K";
  //Incoming pressure cooling medium
  parameter Real pcool_intercooling = 5.0e5 "unit=Pa";
  /////////////////////////////////////////////////////////////////
  //ORC intercooler
  parameter Real DPhot_intercoolingORC = 0.25e5 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_intercoolingORC = 0.5e5 "unit=Pa";
  //Minimum admissible temperature difference
  parameter Real DTpinch_intercoolingORC = 40.0 "unit=K";
  //Desired decrease in temperature of the hot fluid
  parameter Real DThot_intercoolingORC = 83.0 "unit=K";
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
  parameter Real p_orc_exp = 0.1e5 "unit=Pa";
  parameter Real DTpinch_evap = 5.0 "unit=K";
  parameter Real DPhot_evap = 50.0 "unit=Pa";
  //Admissible pressure drop cold side
  parameter Real DPcold_evap = 5000.0 "unit=Pa";
  /////////////////////////////////////////////////////////////////




//Declare class instances (must redeclare medium in all instances)
  ThermoCam.Sources_and_sinks.Sources.Source_pT airin(redeclare package Medium = Medium_in, p_su=pcold, T_su=Tcold,m_flow=massflow_air,X=Xnom) annotation(
    Placement(visible = true, transformation(origin = {-232, 138}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecInandComp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-186, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor_lp(redeclare package Medium = Medium_in, epsilon_s = epsilon_comp_lp) annotation(
    Placement(visible = true, transformation(origin = {-155, 141}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Combustionchamber combustionchamber(redeclare package Medium_in = Medium_in, redeclare package Medium_out =Medium_out,Q_add = Q_hot, m_fuel = massflow_fuel,p_su=phot_hp) annotation(
    Placement(visible = true, transformation(origin = {225, 115}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCombandTurb(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {266, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Turbine turbine(redeclare package Medium = Medium_out, epsilon_s=epsilon_turb) annotation(
    Placement(visible = true, transformation(origin = {308, 118}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Intercooler intercooler(redeclare package Medium_cold = Medium_intercooling, redeclare package Medium_hot = Medium_in, DPhot=DPhot_intercooling,DPcold=DPcold_intercooling,DThot=DThot_intercooling,DTpinch=DTpinch_intercooling,p_su_hot=phot_lp) annotation(
    Placement(visible = true, transformation(origin = {86, 58}, extent = {{-28, -28}, {28, 28}}, rotation = 180)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT waterin(redeclare package Medium = Medium_intercooling, p_su=pcool_intercooling,T_su=Tcool_intercooling,X=Xnom_intercooling) annotation(
    Placement(visible = true, transformation(origin = {152, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecWaterinandIntercooler(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {126, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerandWaterout(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {46, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Compressor compressor_hp(redeclare package Medium = Medium_in,epsilon_s=epsilon_comp_hp) annotation(
    Placement(visible = true, transformation(origin = {161, 113}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolerandCompressor_hp(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {128, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandComb(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {192, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Evaporator evaporator(redeclare package Medium_cold = Medium_ORC,redeclare package Medium_hot=Medium_oil,p_evap=p_orc_exp,DPhot=DPhot_evap,DPcold=DPcold_evap,DTpinch=DTpinch_evap) annotation(
    Placement(visible = true, transformation(origin = {-126, -128}, extent = {{-34, -34}, {34, 34}}, rotation = 0)));
  ThermoCam.Units.LoopBreaker.ClosedLoopConnector closedLoopConnectorOil(redeclare package Medium = Medium_oil, X=Xnom_oil) annotation(
    Placement(visible = true, transformation(origin = {-240, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecHRUandEvaporator(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {-38, -138}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecEvaporatorandLoopconnector(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {-184, -140}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecLoopconnectorandPump(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {-208, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Pump pumpOil(redeclare package Medium = Medium_oil, epsilon_s= epsilon_pump_oil) annotation(
    Placement(visible = true, transformation(origin = {-166, -178}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecPumpandHRU(redeclare package Medium = Medium_oil) annotation(
    Placement(visible = true, transformation(origin = {-126, -178}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Expander expander(redeclare package Medium = Medium_ORC,epsilon_s=epsilon_exp) annotation(
    Placement(visible = true, transformation(origin = {-46, -58}, extent = {{-34, -34}, {34, 34}}, rotation = 90)));
  ThermoCam.Units.Streamconnector.Streamconnector connecEvaporatorandExpander(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-74, -118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Condenser condenser(redeclare package Medium_cold = Medium_condenser_cooling, redeclare package Medium_hot=Medium_ORC,DPhot=DPhot_condenser,DPcold=DPcold_condenser,DTpinch=DTpinch_condenser,T_cond = Tcool_condenser_cooling + DTcond + DTpinch_condenser) annotation(
    Placement(visible = true, transformation(origin = {-183, 15}, extent = {{-43, -43}, {43, 43}}, rotation = 0)));
  ThermoCam.Units.LoopBreaker.ClosedLoopConnector closedLoopConnectorORC(redeclare package Medium = Medium_ORC, X=Xnom_ORC) annotation(
    Placement(visible = true, transformation(origin = {-300, -12}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
  ThermoCam.Units.Mechanical.Pump pumpORC(redeclare package Medium = Medium_ORC, epsilon_s = epsilon_pump_orc) annotation(
    Placement(visible = true, transformation(origin = {-321, -65}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sources.Source_pT condensercoolerin(redeclare package Medium = Medium_condenser_cooling, p_su=pcool_condenser_cooling,T_su= Tcool_condenser_cooling,X=Xnom_condenser_cooling) annotation(
    Placement(visible = true, transformation(origin = {-336, 34}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCondenserandCoolerout(redeclare package Medium = Medium_condenser_cooling) annotation(
    Placement(visible = true, transformation(origin = {-104, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCoolerinandCondenser(redeclare package Medium = Medium_condenser_cooling) annotation(
    Placement(visible = true, transformation(origin = {-278, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCondenserandLoopconnector(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-234, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecExpanderandCondenser(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-68, -14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecLoopconnectorandPumpORC(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-354, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecPumpORCandCondenser(redeclare package Medium = Medium_ORC) annotation(
    Placement(visible = true, transformation(origin = {-254, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink waterout(redeclare package Medium = Medium_intercooling) annotation(
    Placement(visible = true, transformation(origin = {14, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink condersercoolerout(redeclare package Medium = Medium_condenser_cooling) annotation(
    Placement(visible = true, transformation(origin = {-66, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Sources_and_sinks.Sinks.Sink_p FluegasOut(redeclare package Medium = Medium_out,p_su=pcold) annotation(
    Placement(visible = true, transformation(origin = {392, 120}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecCompandORCintercooler(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {-103, 99}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  ThermoCam.Units.Heattransfer.Intercooler intercoolerorc(redeclare package Medium_cold = Medium_oil, redeclare package Medium_hot = Medium_in,DPhot=DPhot_intercoolingORC,DPcold=DPcold_intercoolingORC,DThot=DThot_intercoolingORC,DTpinch=DTpinch_intercoolingORC,p_su_cold=p_oil) annotation(
    Placement(visible = true, transformation(origin = {-43, 83}, extent = {{33, 33}, {-33, -33}}, rotation = 0)));
  ThermoCam.Units.Streamconnector.Streamconnector connecIntercoolers(redeclare package Medium = Medium_in) annotation(
    Placement(visible = true, transformation(origin = {26, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Units.Streamconnector.Streamconnector connecTurbandOut(redeclare package Medium = Medium_out) annotation(
    Placement(visible = true, transformation(origin = {354, 118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Momentum balance
  phot_lp = ph_pc_lp*pcold;
  phot_hp = ph_pc_hp*phot_lp;
  connect(airin.outflow, connecInandComp.inflow) annotation(
    Line(points = {{-215.44, 138}, {-206.44, 138}, {-206.44, 140}, {-197.44, 140}}));
  connect(combustionchamber.outflow, connecCombandTurb.inflow) annotation(
    Line(points = {{241.38, 115.84}, {255.38, 115.84}}));
  connect(connecCombandTurb.outflow, turbine.inflow) annotation(
    Line(points = {{276, 116.4}, {290, 116.4}, {290, 118}}));
  connect(connecInandComp.outflow, compressor_lp.inflow) annotation(
    Line(points = {{-176, 140.4}, {-174, 140.4}, {-174, 142.4}, {-172, 142.4}}));
  connect(waterin.outflow, connecWaterinandIntercooler.inflow) annotation(
    Line(points = {{142.8, 50}, {136.8, 50}}));
  connect(connecWaterinandIntercooler.outflow, intercooler.inflow_cold) annotation(
    Line(points = {{116, 50.4}, {112, 50.4}}));
  connect(intercooler.outflow_cold, connecIntercoolerandWaterout.inflow) annotation(
    Line(points = {{63.04, 50.72}, {55.04, 50.72}}));
  connect(intercooler.outflow_hot, connecIntercoolerandCompressor_hp.inflow) annotation(
    Line(points = {{108.4, 72.56}, {114.4, 72.56}, {114.4, 85.56}, {117.4, 85.56}, {117.4, 111.56}}));
  connect(connecIntercoolerandCompressor_hp.outflow, compressor_hp.inflow) annotation(
    Line(points = {{138, 112.4}, {141, 112.4}, {141, 113.4}, {142, 113.4}}));
  connect(compressor_hp.outflow, connecCompandComb.inflow) annotation(
    Line(points = {{177.38, 113}, {180.88, 113}, {180.88, 112}, {181.38, 112}}));
  connect(connecCompandComb.outflow, combustionchamber.inflow) annotation(
    Line(points = {{202, 112.4}, {208, 112.4}, {208, 116.4}}));
  connect(connecHRUandEvaporator.outflow, evaporator.inflow_hot) annotation(
    Line(points = {{-48, -137.6}, {-68, -137.6}, {-68, -139.6}, {-99, -139.6}}));
  connect(evaporator.outflow_hot, connecEvaporatorandLoopconnector.inflow) annotation(
    Line(points = {{-149.12, -140.24}, {-173.12, -140.24}}));
  connect(connecEvaporatorandLoopconnector.outflow, closedLoopConnectorOil.inflow) annotation(
    Line(points = {{-194, -139.6}, {-262, -139.6}, {-262, -171.6}, {-248, -171.6}}));
  connect(closedLoopConnectorOil.outflow, connecLoopconnectorandPump.inflow) annotation(
    Line(points = {{-231.8, -172}, {-218.8, -172}}));
  connect(connecLoopconnectorandPump.outflow, pumpOil.inflow) annotation(
    Line(points = {{-198, -171.6}, {-190, -171.6}, {-190, -177.6}, {-175, -177.6}}));
  connect(pumpOil.outflow, connecPumpandHRU.inflow) annotation(
    Line(points = {{-158.2, -178}, {-137.2, -178}}));
  connect(evaporator.outflow_cold, connecEvaporatorandExpander.inflow) annotation(
    Line(points = {{-101.52, -118.48}, {-84.52, -118.48}}));
  connect(connecEvaporatorandExpander.outflow, expander.inflow) annotation(
    Line(points = {{-64, -117.6}, {-45, -117.6}, {-45, -84.6}}));
  connect(condensercoolerin.outflow, connecCoolerinandCondenser.inflow) annotation(
    Line(points = {{-321.28, 34}, {-290.28, 34}, {-290.28, 32}, {-289.28, 32}}));
  connect(condenser.outflow_hot, connecCondenserandLoopconnector.inflow) annotation(
    Line(points = {{-218.26, 1.24}, {-223.52, 1.24}, {-223.52, -9.52}}));
  connect(expander.outflow, connecExpanderandCondenser.inflow) annotation(
    Line(points = {{-46, -32.84}, {-46, -13.84}, {-57, -13.84}}));
  connect(connecExpanderandCondenser.outflow, condenser.inflow_hot) annotation(
    Line(points = {{-78, -13.6}, {-89, -13.6}, {-89, -5}, {-146, -5}}));
  connect(connecPumpORCandCondenser.outflow, evaporator.inflow_cold) annotation(
    Line(points = {{-244, -109.6}, {-152, -109.6}, {-152, -117.6}}));
  connect(connecIntercoolerandWaterout.outflow, waterout.inflow) annotation(
    Line(points = {{36, 50.4}, {23, 50.4}, {23, 51}, {22, 51}}));
  connect(connecCondenserandCoolerout.outflow, condersercoolerout.inflow) annotation(
    Line(points = {{-94, 16.4}, {-74, 16.4}, {-74, 11.4}}));
  connect(pumpORC.outflow, connecPumpORCandCondenser.inflow) annotation(
    Line(points = {{-307.74, -65}, {-289.74, -65}, {-289.74, -110}, {-265, -110}}));
  connect(connecLoopconnectorandPumpORC.outflow, pumpORC.inflow) annotation(
    Line(points = {{-344, -29.6}, {-336, -29.6}, {-336, -63.6}}));
  connect(connecCondenserandLoopconnector.outflow, closedLoopConnectorORC.outflow) annotation(
    Line(points = {{-244, -9.6}, {-280, -9.6}, {-280, -11.6}}));
  connect(closedLoopConnectorORC.inflow, connecLoopconnectorandPumpORC.inflow) annotation(
    Line(points = {{-319.2, -11.52}, {-363.4, -11.52}, {-363.4, -29.04}}));
  connect(compressor_lp.outflow, connecCompandORCintercooler.inflow) annotation(
    Line(points = {{-140.18, 141}, {-124.18, 141}, {-124.18, 99}}));
  connect(connecCompandORCintercooler.outflow, intercoolerorc.inflow_hot) annotation(
    Line(points = {{-84, 99.76}, {-70, 99.76}, {-70, 97.76}}));
  connect(intercoolerorc.outflow_hot, connecIntercoolers.inflow) annotation(
    Line(points = {{-16.6, 100.16}, {16.4, 100.16}, {16.4, 86.16}}));
  connect(connecIntercoolers.outflow, intercooler.inflow_hot) annotation(
    Line(points = {{36, 86.4}, {48, 86.4}, {48, 70.4}, {64, 70.4}}));
  connect(intercoolerorc.outflow_cold, connecHRUandEvaporator.inflow) annotation(
    Line(points = {{-70.06, 74.42}, {-104.06, 74.42}, {-104.06, 40.42}, {-18.06, 40.42}, {-18.06, -137.58}, {-28.06, -137.58}}));
  connect(connecPumpandHRU.outflow, intercoolerorc.inflow_cold) annotation(
    Line(points = {{-116, -177.6}, {-14, -177.6}, {-14, 74.4}}));
  connect(connecCoolerinandCondenser.outflow, condenser.inflow_cold) annotation(
    Line(points = {{-268, 32.4}, {-218, 32.4}, {-218, 28.4}}));
  connect(condenser.outflow_cold, connecCondenserandCoolerout.inflow) annotation(
    Line(points = {{-150.32, 27.9}, {-122.32, 27.9}, {-122.32, 15.9}, {-114.32, 15.9}}));
  connect(turbine.outflow, connecTurbandOut.inflow) annotation(
    Line(points = {{324, 118}, {344, 118}}));
  connect(connecTurbandOut.outflow, FluegasOut.inflow) annotation(
    Line(points = {{364, 118}, {373, 118}, {373, 120}, {384, 120}}));
  annotation(
    Icon);
end IGT_intercooler_ORC;