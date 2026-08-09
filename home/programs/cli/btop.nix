{theme, ...}: let
  c = theme.colors;
in {
  programs.btop = {
    enable = true;
    package = null;
    settings = {
      color_theme = "custom";
      theme_background = true;
      truecolor = true;
      force_tty = false;
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      vim_keys = false;
      rounded_corners = true;
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";
      shown_boxes = "cpu mem net proc";
      update_ms = 100;
      proc_sorting = "memory";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;
      proc_filter_kernel = false;
      proc_aggregate = false;
      cpu_graph_upper = "Auto";
      cpu_graph_lower = "Auto";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_uptime = true;
      show_cpu_watts = true;
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      cpu_core_map = "";
      temp_scale = "celsius";
      base_10_sizes = false;
      show_cpu_freq = true;
      clock_format = "%X";
      background_update = true;
      custom_cpu_name = "";
      disks_filter = "";
      mem_graphs = true;
      mem_below_net = false;
      zfs_arc_cached = true;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = true;
      use_fstab = true;
      zfs_hide_datasets = false;
      disk_free_priv = false;
      show_io_stat = true;
      io_mode = true;
      io_graph_combined = false;
      io_graph_speeds = "";
      net_download = 100;
      net_upload = 100;
      net_auto = false;
      net_sync = true;
      net_iface = "";
      base_10_bitrate = "Auto";
      show_battery = true;
      selected_battery = "Auto";
      show_battery_watts = true;
      log_level = "WARNING";
    };
  };

  xdg.configFile."btop/themes/custom.theme".text = ''
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="${c.base}"

    # Main text color
    theme[main_fg]="${c.text}"

    # Title color for boxes
    theme[title]="${c.text}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${c.blue}"

    # Background color of selected item in processes box
    theme[selected_bg]="${c.surface1}"

    # Foreground color of selected item in processes box
    theme[selected_fg]="${c.blue}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${c.surface1}"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="${c.flamingo}"

    # Background color of the percentage meters
    theme[meter_bg]="${c.surface1}"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="${c.surface1}"

    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="${c.mauve}"
    theme[mem_box]="${c.green}"
    theme[net_box]="${c.maroon}"
    theme[proc_box]="${c.blue}"

    # Box divider line and small boxes line color
    theme[div_line]="${c.overlay0}"

    # Temperature graph color (Green -> Yellow -> Red)
    theme[temp_start]="${c.green}"
    theme[temp_mid]="${c.yellow}"
    theme[temp_end]="${c.red}"

    # CPU graph colors (Teal -> Sky -> Lavender)
    theme[cpu_start]="${c.teal}"
    theme[cpu_mid]="${c.sky}"
    theme[cpu_end]="${c.lavender}"

    # Mem/Disk free meter (Mauve -> Lavender -> Blue)
    theme[free_start]="${c.mauve}"
    theme[free_mid]="${c.lavender}"
    theme[free_end]="${c.blue}"

    # Mem/Disk cached meter (Sky -> Blue -> Lavender)
    theme[cached_start]="${c.sky}"
    theme[cached_mid]="${c.blue}"
    theme[cached_end]="${c.lavender}"

    # Mem/Disk available meter (Peach -> Maroon -> Red)
    theme[available_start]="${c.peach}"
    theme[available_mid]="${c.maroon}"
    theme[available_end]="${c.red}"

    # Mem/Disk used meter (Green -> Teal -> Sapphire)
    theme[used_start]="${c.green}"
    theme[used_mid]="${c.teal}"
    theme[used_end]="${c.sapphire}"

    # Download graph colors (Peach -> Maroon -> Red)
    theme[download_start]="${c.peach}"
    theme[download_mid]="${c.maroon}"
    theme[download_end]="${c.red}"

    # Upload graph colors (Green -> Teal -> Sapphire)
    theme[upload_start]="${c.green}"
    theme[upload_mid]="${c.teal}"
    theme[upload_end]="${c.sapphire}"

    # Process box color gradient for threads, mem and cpu usage (Sky -> Lavender -> Mauve)
    theme[process_start]="${c.sky}"
    theme[process_mid]="${c.lavender}"
    theme[process_end]="${c.mauve}"
  '';
}
