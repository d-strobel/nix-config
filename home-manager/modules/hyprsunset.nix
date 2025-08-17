{pkgs, ...}: {
  services.hyprsunset = {
    enable = true;
    package = with pkgs; hyprsunset;
    settings = {
      max-gamma = 150;

      profile = [
        {
          time = "7:30";
          identity = true;
        }
        {
          time = "21:00";
          temperature = 5500;
          gamma = 0.9;
        }
      ];
    };
  };
}
