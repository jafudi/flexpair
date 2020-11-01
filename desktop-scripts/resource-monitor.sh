#!/usr/bin/env bash

echo "Running script resource-monitor.sh..."
echo

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -qq install --no-install-recommends \
conky-all

# https://wiki.ubuntuusers.de/Conky/

# Quoting EOF turns of variable substitution on purpose
cat << 'EOF' > $HOME/.conkyrc
conky.config = {
    alignment = 'top_right',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    use_xft = true,
    font = 'DejaVu Sans Mono:size=12',
    gap_x = 5,
    gap_y = 60,
    minimum_height = 5,
    minimum_width = 5,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_stderr = false,
    extra_newline = false,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'normal',
    stippled_borders = 0,
    update_interval = 3.0,
    uppercase = false,
    use_spacer = 'none',
    show_graph_scale = false,
    show_graph_range = false
}

conky.text = [[
${color grey}Uptime:$color $uptime
${color grey}Frequency (in GHz):$color $freq_g
${color grey}RAM Usage:$color $mem/$memmax - $memperc% ${membar 4}
${color grey}Swap Usage:$color $swap/$swapmax - $swapperc% ${swapbar 4}
${color grey}CPU Usage:$color $cpu% ${cpubar 4}
$hr
${color grey}File systems:
 / $color${fs_used /}/${fs_size /} ${fs_bar 6 /}
$hr
${color grey}Current network traffic:
Up:$color ${upspeed ens3} ${color grey} - Down:$color ${downspeed ens3}
$hr
Press Alt+Ctrl+Shift for
- main menu and settings
- file upload and download
- editing clipboard content
- using a screen keyboard
- zooming in and out
]]
EOF

mkdir -p  $HOME/.config/autostart
cat << EOF > $HOME/.config/autostart/conky.desktop
[Desktop Entry]
Type=Application
Name=conky
Exec=conky --daemonize --pause=5
StartupNotify=false
Terminal=false
EOF

