#!/usr/bin/env bash

# https://www.mumble.info
DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
mumble \
paprefs \

mkdir -p $HOME/.config/pulse
cat << EOF > $HOME/.config/pulse/default.pa
.include /etc/pulse/default.pa

load-module module-null-sink sink_name=AllExceptMumble
update-sink-proplist AllExceptMumble device.description=AllExceptMumble
update-source-proplist AllExceptMumble.monitor device.description=AllExceptMumbleMonitor

load-module module-null-sink sink_name=MumbleNullSink
update-sink-proplist MumbleNullSink device.description=MumbleNullSink
update-source-proplist MumbleNullSink.monitor device.description=MumbleNullSinkMonitor

set-default-sink AllExceptMumble
set-default-source AllExceptMumble.monitor

load-module module-native-protocol-tcp auth-anonymous=1
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
EOF
chown ubuntu -R /home/ubuntu/.config

DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends --upgrade \
espeak-ng \
speech-dispatcher

mkdir -p $HOME/.speech-dispatcher
cp -R /etc/speech-dispatcher $HOME/.speech-dispatcher/
cat << EOF > $HOME/.speech-dispatcher/speech-dispatcher/speechd.conf
# ----- VOICE PARAMETERS -----

# The DefaultRate controls how fast the synthesizer is going to speak.
# The value must be between -100 (slowest) and +100 (fastest), default
# is 0.

# DefaultRate  0

# The DefaultPitch controls the pitch of the synthesized voice.  The
# value must be between -100 (lowest) and +100 (highest), default is
# 0.

# DefaultPitch  0

# The DefaultPitchRange controls the pitch range of the synthesized voice.  The
# value must be between -100 (lowest) and +100 (highest), default is
# 0.

# DefaultPitchRange  0

# The DefaultVolume controls the default volume of the voice.  It is
# a value between -100 (softly) and +100 (loudly).  Currently, +100
# maps to the default volume of the synthesizer.

DefaultVolume 100

# The DefaultVoiceType controls which voice type should be used by
# default.  Voice types are symbolic names which map to particular
# voices provided by the synthesizer according to the output module
# configuration.  Please see the synthesizer-specific configuration
# in etc/speech-dispatcher/modules/ to see which voices are assigned to
# different symbolic names.  The following symbolic names are
# currently supported: MALE1, MALE2, MALE3, FEMALE1, FEMALE2, FEMALE3,
# CHILD_MALE, CHILD_FEMALE

# DefaultVoiceType  "MALE1"

# The Default language with which to speak

# DefaultLanguage "en"

# ----- MESSAGE DISPATCHING CONTROL -----

# The DefaultClientName specifies the name of a client who didn't
# introduce himself at the beginning of an SSIP session.

# DefaultClientName  "unknown:unknown:unknown"

# The Default Priority. Use with caution, normally this shouldn't be
# changed globally (at this place)

# DefaultPriority  "text"

# The DefaultPauseContext specifies by how many index marks a speech
# cursor should return when resuming after a pause. This is roughly
# equivalent to the number of sentences before the place of the
# execution of pause that will be repeated.

# DefaultPauseContext 0

# -----SPELLING/PUNCTUATION/CAPITAL LETTERS  CONFIGURATION-----

# The DefaultPunctuationMode sets the way dots, comas, exclamation
# marks, question marks etc. are interpreted.  none: they are ignored
# some: some of them are sent to synthesis (see
# DefaultPunctuationSome) all: all punctuation marks are sent to
# synthesis

# DefaultPunctuationMode "none"

# Whether to use server-side symbols pre-processing by default.
# This controls whether the server should pre-process the messages to insert
# the appropriate words or if the output module is responsible for speaking
# symbols and punctuation.

# DefaultSymbolsPreprocessing 0

# The DefaultCapLetRecognition: if set to "spell", capital letters
# should be spelled (e.g. "capital b"), if set to "icon",
# capital letters are indicated by inserting a special sound
# before them but they should be read normally, it set to "none"
# capital letters are not recognized (by default)

# DefaultCapLetRecognition  "none"

# The DefaultSpelling: if set to On, all messages will be spelt
# unless set otherwise (this is usually not something you want to do.)

# DefaultSpelling  Off

# ----- AUDIO CONFIGURATION -----------

# AudioOutputMethod "pulse"

# -- Pulse Audio parameters --

# Pulse audio server name or "default" for the default pulse server

#AudioPulseServer "default"

#AudioPulseMinLength 1764

# -----OUTPUT MODULES CONFIGURATION-----

# Each AddModule line loads an output module.
#  Syntax: AddModule "name" "binary" "configuration" "logfile"
#  - name is the name under which you can access this module
#  - binary is the path to the binary executable of this module,
#    either relative (to lib/speech-dispatcher-modules/) or absolute
#  - configuration is the path to the config file of this module,
#    either relative (to etc/speech-dispatcher/modules/) or absolute

#AddModule "espeak"                   "sd_espeak"    "espeak.conf"
AddModule "espeak-ng"                "sd_espeak-ng" "espeak-ng.conf"
#AddModule "festival"                 "sd_festival"  "festival.conf"
#AddModule "flite"                    "sd_flite"     "flite.conf"
#AddModule "ivona"                    "sd_ivona"     "ivona.conf"
#AddModule "pico"                     "sd_pico"      "pico.conf"
#AddModule "espeak-generic"           "sd_generic"   "espeak-generic.conf"
#AddModule "espeak-ng-mbrola-generic" "sd_generic"   "espeak-ng-mbrola-generic.conf"
#AddModule "espeak-mbrola-generic"    "sd_generic"   "espeak-mbrola-generic.conf"
#AddModule "swift-generic"            "sd_generic"   "swift-generic.conf"
#AddModule "epos-generic"             "sd_generic"   "epos-generic.conf"
#AddModule "dtk-generic"              "sd_generic"   "dtk-generic.conf"
#AddModule "pico-generic"             "sd_generic"   "pico-generic.conf"
#AddModule "ibmtts"                   "sd_ibmtts"    "ibmtts.conf"
#AddModule "cicero"                   "sd_cicero"    "cicero.conf"
#AddModule "kali"                     "sd_kali"      "kali.conf"
#AddModule "mary-generic"             "sd_generic"   "mary-generic.conf"
#AddModule "baratinoo"                "sd_baratinoo" "baratinoo.conf"
#AddModule "rhvoice"                  "sd_rhvoice"   "rhvoice.conf"
#AddModule "voxin"                    "sd_voxin"     "voxin.conf"

# DO NOT REMOVE the following line unless you have
# a specific reason -- this is the fallback output module
# that is only used when no other modules are in use
#AddModule "dummy"         "sd_dummy"      ""

# The output module testing doesn't actually connect to anything. It
# outputs the requested commands to standard output and reads
# responses from stdandard input. This way, Speech Dispatcher's
# communication with output modules can be tested easily.

# AddModule "testing"

# The DefaultModule selects which output module is the default.  You
# must use one of the names of the modules loaded with AddModule.

DefaultModule espeak-ng

# The LanguageDefaultModule selects which output modules are prefered
# for specified languages.

#LanguageDefaultModule "en"  "espeak"
#LanguageDefaultModule "cs"  "festival"
#LanguageDefaultModule "es"  "festival"

# -----CLIENT SPECIFIC CONFIGURATION-----

# Here you can include the files with client-specific configuration
# for different types of clients. They must contain one or more sections with
# this structure:
#     BeginClient "emacs:*"
#          DefaultPunctuationMode "some"
#          ...and/or some other settings
#     EndClient
# The parameter of BeginClient tells Speech Dispatcher which clients
# it should apply the settings to (it does glob-style matching, you can use
# * to match any number of characters and ? to match one character)

# There are some sample client settings

Include "clients/*.conf"

# The DisableAutoSpawn option will disable the autospawn mechanism.
# Thus the server will not start automatically on requests from the clients
# DisableAutoSpawn
EOF





