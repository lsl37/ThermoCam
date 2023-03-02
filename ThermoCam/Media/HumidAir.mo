within ThermoCam.Media;
package HumidAir "Humid air as mixture of O2, N2, Ar, H2O and CO2 (dummy variable)"
  extends Modelica.Media.IdealGases.Common.MixtureGasNasa(mediumName = "HumidAir", data = {Modelica.Media.IdealGases.Common.SingleGasesData.O2, Modelica.Media.IdealGases.Common.SingleGasesData.H2O, Modelica.Media.IdealGases.Common.SingleGasesData.Ar, Modelica.Media.IdealGases.Common.SingleGasesData.N2, Modelica.Media.IdealGases.Common.SingleGasesData.CO2}, fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.O2, Modelica.Media.IdealGases.Common.FluidData.H2O, Modelica.Media.IdealGases.Common.FluidData.Ar, Modelica.Media.IdealGases.Common.FluidData.N2,Modelica.Media.IdealGases.Common.FluidData.CO2}, substanceNames = {"Oxygen", "Water", "Argon", "Nitrogen","Carbondioxide"}, reference_X = {0.23, 0.015, 0.005, 0.75,0.0}, referenceChoice = Modelica.Media.Interfaces.Choices.ReferenceEnthalpy.ZeroAt25C);
end HumidAir;

