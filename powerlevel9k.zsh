# Enable elements
# https://github.com/bhilburn/powerlevel9k/wiki/Show-Off-Your-Config
# background_jobs load ram time history
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history virtualenv node_version)

# Shorten directory
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"

# Prompt on newline
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Do notd display status error code
POWERLEVEL9K_STATUS_VERBOSE=false

# Display full date and time
# POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S %d/%m/%Y}"

# Green version background colour
POWERLEVEL9K_NODE_VERSION_BACKGROUND='022'

# Show Git commit hash at prompt
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=7
