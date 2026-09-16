{...}: {
  xdg.configFile."labwc/rc.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <labwc_config>
      <keyboard>
        <keybind key="C-A-J"><action name="NextWindow" /></keybind>
        <keybind key="C-A-K"><action name="PreviousWindow" /></keybind>
        <keybind key="C-A-Space"><action name="ShowMenu" menu="client-list-combined-menu" /></keybind>
        <keybind key="C-A-H"><action name="SnapToEdge" direction="left" /></keybind>
        <keybind key="C-A-L"><action name="SnapToEdge" direction="right" /></keybind>
        <keybind key="C-A-F"><action name="ToggleMaximize" /></keybind>
        <keybind key="C-A-Q"><action name="Close" /></keybind>
      </keyboard>
    </labwc_config>
  '';
}
