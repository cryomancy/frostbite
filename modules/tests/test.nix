{pkgs, ...}:
pkgs.testers.runNixOSTest {
  name = "Preliminary";
  nodes = {
    machine1 = {pkgs, ...}: {};
  };
}
