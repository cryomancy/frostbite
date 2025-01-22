scoped: pkgs: {
  alt ? "",
  class ? "",
  dependencies ? [],
  name ? "customWaybarModule",
  percentage ? "",
  script ? "",
  text ? "",
  tooltip ? "",
}: {
  inherit name;
  dependencies = [pkgs.jq] ++ dependencies;
  script = ''
    ${script}
    jq -cn \
      --arg text "${text}" \
      --arg tooltip "${tooltip}" \
      --arg alt "${alt}" \
      --arg class "${class}" \
      --arg percentage "${percentage}" \
      '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
  '';
}
