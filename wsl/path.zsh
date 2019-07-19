#!/bin/zsh

# https://stackoverflow.com/questions/370047/what-is-the-most-elegant-way-to-remove-a-path-from-the-path-variable-in-bash
wsl_path_remove()  {
  export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
}

# command -v awk >/dev/null || exit 1
# command -v sed >/dev/null || exit 1

if [[ "$platform" == "wsl" ]]; then
  typeset -U wsl_mnt_paths
  wsl_mnt_paths=("${(@f)$(echo $PATH | tr ':' '\n' | grep '^/mnt' | sort -n)}")
  for mnt_path in "${wsl_mnt_paths[@]}"; do
    # Keep VSCode binaries in the path so we can edit files
    if [[ ! "$mnt_path" =~ "Microsoft VS Code" ]]; then
      wsl_path_remove "$mnt_path"
    fi
  done
fi

unfunction wsl_path_remove
