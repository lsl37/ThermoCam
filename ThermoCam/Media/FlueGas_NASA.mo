within ThermoCam.Media;
package FlueGas_NASA "flue gas"
  extends Modelica.Media.IdealGases.Common.MixtureGasNasa(mediumName = "FlueGas", data = {Modelica.Media.IdealGases.Common.SingleGasesData.O2, Modelica.Media.IdealGases.Common.SingleGasesData.H2O, Modelica.Media.IdealGases.Common.SingleGasesData.Ar, Modelica.Media.IdealGases.Common.SingleGasesData.N2, Modelica.Media.IdealGases.Common.SingleGasesData.CO2}, fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.O2, Modelica.Media.IdealGases.Common.FluidData.H2O, Modelica.Media.IdealGases.Common.FluidData.Ar, Modelica.Media.IdealGases.Common.FluidData.N2, Modelica.Media.IdealGases.Common.FluidData.CO2}, substanceNames = {"Oxygen", "Water", "Argon", "Nitrogen","Carbondioxide"}, reference_X = {0.1135, 0.0638, 0.0014, 0.7448, 0.0765}, referenceChoice = Modelica.Media.Interfaces.Choices.ReferenceEnthalpy.ZeroAt25C);
  //0.1135, 0.0014, 0.0638, 0.0765, 0.7448  Typical flue gas mixture
  //0.23,0.02,0.01,0.04,0.7 Normal air
end FlueGas_NASA;
