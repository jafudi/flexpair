#!/usr/bin/env bash

# https://wiki.ubuntuusers.de/gPodder/
# https://gpodder.github.io/docs/user-manual.html

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
gpodder \
youtube-dl \
ffmpeg \
rtmpdump \
vlc

mkdir -p $HOME/gPodder
cat << EOF > $HOME/gPodder/Settings.json
{
  "auto": {
    "cleanup": {
      "days": 1,
      "played": true,
      "unfinished": true,
      "unplayed": false
    },
    "retries": 3,
    "update": {
      "enabled": true,
      "frequency": 20
    }
  },
  "device_sync": {
    "after_sync": {
      "delete_episodes": false,
      "mark_episodes_played": false,
      "sync_disks": false
    },
    "custom_sync_name": "{episode.sortdate}_{episode.title}",
    "custom_sync_name_enabled": false,
    "delete_played_episodes": false,
    "device_folder": "/media",
    "device_type": "none",
    "max_filename_length": 120,
    "one_folder_per_podcast": true,
    "playlists": {
      "create": true,
      "folder": "Playlists",
      "two_way_sync": false,
      "use_absolute_path": true
    },
    "skip_played_episodes": true
  },
  "downloads": {
    "chronological_order": true
  },
  "extensions": {
    "enabled": [
      "enqueue_in_mediaplayer",
      "gtk_statusicon",
      "episode_website_context_menu",
      "update_feeds_on_startup",
      "youtube-dl",
      "rename_download"
    ],
    "enqueue_in_mediaplayer": {
      "default_player": "",
      "enqueue_after_download": false
    },
    "gtk_statusicon": {
      "download_progress_bar": false
    },
    "rename_download": {
      "add_podcast_title": false,
      "add_sortdate": false
    },
    "youtube-dl": {
      "manage_channel": true,
      "manage_downloads": true
    }
  },
  "limit": {
    "bandwidth": {
      "enabled": false,
      "kbps": 500.0
    },
    "downloads": {
      "concurrent": 1,
      "concurrent_max": 16,
      "enabled": true
    },
    "episodes": 200
  },
  "mygpo": {
    "device": {
      "caption": "gPodder on desktop-1593894250",
      "type": "desktop",
      "uid": "desktop-1593894250"
    },
    "enabled": false,
    "password": "",
    "server": "gpodder.net",
    "username": ""
  },
  "player": {
    "audio": "/usr/bin/vlc --started-from-file %U",
    "video": "/usr/bin/vlc --started-from-file %U"
  },
  "software_update": {
    "check_on_startup": false
  },
  "ui": {
    "cli": {
      "colors": true
    },
    "gtk": {
      "download_list": {
        "remove_finished": true
      },
      "episode_list": {
        "columns": 6,
        "descriptions": true,
        "view_mode": 1
      },
      "html_shownotes": true,
      "live_search_delay": 200,
      "new_episodes": "show",
      "podcast_list": {
        "all_episodes": true,
        "hide_empty": false,
        "sections": true,
        "view_mode": 1
      },
      "state": {
        "config_editor": {
          "height": -1,
          "maximized": false,
          "width": -1,
          "x": -1,
          "y": -1
        },
        "episode_selector": {
          "height": 400,
          "maximized": false,
          "width": 600,
          "x": -1,
          "y": -1
        },
        "episode_window": {
          "height": 400,
          "maximized": false,
          "width": 500,
          "x": -1,
          "y": -1
        },
        "export_to_local_folder": {
          "height": 400,
          "maximized": false,
          "width": 500,
          "x": -1,
          "y": -1
        },
        "main_window": {
          "episode_column_order": [],
          "episode_column_sort_id": 12,
          "episode_column_sort_order": false,
          "episode_list_size": 200,
          "height": 500,
          "maximized": false,
          "paned_position": 200,
          "width": 700,
          "x": 360,
          "y": 335
        },
        "preferences": {
          "height": 361,
          "maximized": false,
          "width": 721,
          "x": 352,
          "y": 427
        }
      },
      "toolbar": true
    }
  },
  "vimeo": {
    "fileformat": "720p"
  },
  "youtube": {
    "preferred_fmt_id": 18,
    "preferred_fmt_ids": []
  }
}
EOF
chown ubuntu -R $HOME/gPodder