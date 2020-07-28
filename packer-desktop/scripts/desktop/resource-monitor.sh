#!/usr/bin/env bash

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade conky-all

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
${color grey}Networking:
Up:$color ${upspeed eth0} ${color grey} - Down:$color ${downspeed eth0}
${color grey}Latency:$color 8.8.8.8 (10 pings)
${exec ping -l 3 -c 10 -w 2 -i 0,2 8.8.8.8 | tail -1 | cut -c 5-49}
$hr
For high-quality AUDIO INPUT
download Mumble client from:
www.mumble.info/downloads
and connect on port 64738 to
tryno3.theworkpc.com
$hr
For menu press Ctrl+Alt+Shift
]]
EOF
chown ubuntu $HOME/.conkyrc

mkdir -p  $HOME/.config/autostart
cat << EOF > $HOME/.config/autostart/conky.desktop
[Desktop Entry]
Type=Application
Name=conky
Exec=conky --daemonize --pause=5
StartupNotify=false
Terminal=false
EOF
chown ubuntu -R  $HOME/.config/autostart