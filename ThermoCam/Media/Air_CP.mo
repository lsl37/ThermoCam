within ThermoCam.Media;
package Air_CP "Air - ThermoCam"
  extends ExternalMedia.Media.CoolPropMedium(mediumName = "Air", substanceNames = {"Air|debug=0|calc_transport=1|enable_TTSE=0"}, ThermoStates = Modelica.Media.Interfaces.Choices.IndependentVariables.ph);


  annotation ();
end Air_CP;