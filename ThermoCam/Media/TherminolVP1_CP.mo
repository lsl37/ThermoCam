within ThermoCam.Media;
package TherminolVP1_CP "Therminol VP-1 properties from Coolprop"
  extends ExternalMedia.Media.IncompressibleCoolPropMedium(mediumName = "TVP1", substanceNames = {"TVP1|debug=0|calc_transport=1|enable_TTSE=0"}, ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.pT);
end TherminolVP1_CP;