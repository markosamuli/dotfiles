#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# https://stackoverflow.com/questions/370047/what-is-the-most-elegant-way-to-remove-a-path-from-the-path-variable-in-bash
wsl_path_remove() {
    export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`
}

if [[ "$platform_wsl" == "true" ]]; then
    typeset -U wsl_mnt_paths
    wsl_mnt_paths=("${(@f)$(echo $PATH | tr ':' '\n' | grep '^/mnt' | sort -n)}")
    for mnt_path in "${wsl_mnt_paths[@]}"; do
        # Keep \Windows\System32 folder (VSCode Remote needs access to cmd.exe)
        if [[ "$mnt_path" =~ "/Windows/[sS]ystem32$" ]]; then
            continue
        fi
        # Keep VSCode binaries in the path so we can edit files
        if [[ "$mnt_path" =~ "Microsoft VS Code" ]]; then
            continue
        fi
        wsl_path_remove "$mnt_path"
    done
fi

unfunction wsl_path_remove
