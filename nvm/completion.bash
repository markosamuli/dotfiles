
#!/usr/bin/env bash

# Load nvm bash_completion
if [ -n "${NVM_DIR}" ]; then
  if [ -s "${NVM_DIR}/bash_completion" ]; then
    . "${NVM_DIR}/bash_completion"
  fi
fi
