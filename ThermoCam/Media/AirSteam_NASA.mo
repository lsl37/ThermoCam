within ThermoCam.Media;
package AirSteam_NASA "Air and steam mixture (no condensation!, pseudo-mixture)"
  extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
     mediumName="MoistAir",
     data={Modelica.Media.IdealGases.Common.SingleGasesData.H2O, Modelica.Media.IdealGases.Common.SingleGasesData.Air},
    fluidConstants={Modelica.Media.IdealGases.Common.SingleGasesData.H2O,
      Modelica.Media.IdealGases.Common.SingleGasesData.Air},
     substanceNames = {"Water","Air"},
     reference_X={0.0,1.0},referenceChoice = Modelica.Media.Interfaces.Choices.ReferenceEnthalpy.ZeroAt25C);
  annotation (Documentation(info="<html>

</html>"));
end AirSteam_NASA;
