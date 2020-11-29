#!/bin/bash -eux

mkdir -p $HOME/.config/texlive
cd $HOME/.config/texlive

wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xvzf install-tl-unx.tar.gz
rm install-tl-unx.tar.gz

cd install-tl-*

cat << EOF > texlive.profile
# texlive.profile written on Fri Sep  4 15:24:23 2020 UTC
# It will NOT be updated and reflects only the
# installation profile at installation time.
selected_scheme scheme-basic
TEXDIR /home/ubuntu/.local/texlive/2020
TEXMFCONFIG ~/.texlive2020/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL /home/ubuntu/.local/texlive/texmf-local
TEXMFSYSCONFIG /home/ubuntu/.local/texlive/2020/texmf-config
TEXMFSYSVAR /home/ubuntu/.local/texlive/2020/texmf-var
TEXMFVAR ~/.texlive2020/texmf-var
binary_x86_64-linux 1
instopt_adjustpath 0
instopt_adjustrepo 1
instopt_letter 0
instopt_portable 0
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 1
tlpdbopt_file_assocs 1
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_post_code 1
tlpdbopt_sys_bin /usr/local/bin
tlpdbopt_sys_info /usr/local/share/info
tlpdbopt_sys_man /usr/local/share/man
tlpdbopt_w32_multi_user 1
EOF

# install basic scheme without documentation and source in $HOME/.local
sudo perl install-tl \
    -profile texlive.profile \
    -repository https://ftp.rrze.uni-erlangen.de/ctan/systems/texlive/tlnet

# optional:
# tlmgr repository add https://www.komascript.de/repository/texlive/2020 KOMA
# tlmgr pinning add KOMA koma-script

PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH

sudo tlmgr install koma-script amsfonts helvetic psnfss lh latexmk \
              cmap babel-german babel-russian hyphen-german hyphen-russian \
              cm cm-super cyrillic microtype caption pdfpages pgf pdflscape \
              xstring

export DEBIAN_FRONTEND="noninteractive"
sudo -E apt-get -qq install kile