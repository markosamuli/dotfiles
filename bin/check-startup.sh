#!/usr/bin/env bash
#
# Start each shell entry point from this checkout against a throwaway HOME,
# and fail if startup exits non-zero or writes anything to stderr.
#
# The environment is cleared with `env -i`, so nothing exported by the
# calling shell (such as ZSH_PLUGIN_MANAGER) changes which code path runs.
# Most modules guard on files under $HOME and stay inert here; this checks
# the entry points and every unguarded line, not each tool integration.

set -euo pipefail

dotfiles="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Lines an interactive shell prints when it has no terminal, and the `exit`
# bash echoes as an interactive shell ends. They come from the shell itself,
# not from any dotfile, so they say nothing about this repository.
noise='^(bash: (no job control in this shell|cannot set terminal process group .*|initialize_job_control: .*)|exit)$'

base_path='/usr/bin:/bin:/usr/sbin:/sbin'

# Check once with only the system PATH, and once more with Homebrew's bin on
# PATH where it exists, so that branches guarded on `brew` run as well.
check_paths=("${base_path}")
for brew_prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew; do
    if [ -x "${brew_prefix}/bin/brew" ]; then
        check_paths+=("${brew_prefix}/bin:${base_path}")
        break
    fi
done

failed=0

# A shell started with a missing startup file says nothing: bash ignores a
# missing --rcfile and zsh skips a dangling link. Check that each one exists
# and is not empty before trusting a clean start.
for file in .bashrc .zshrc .zshenv .zprofile .profile; do
    if [ ! -s "${dotfiles}/${file}" ]; then
        echo "FAIL  ${file} is missing or empty"
        failed=1
    fi
done

# Run after startup to prove the entry point loaded the modules, not just
# that it exited cleanly. The dotfiles/ module defines this alias for both
# shells.
# shellcheck disable=SC2016
loaded='alias dotfiles >/dev/null 2>&1 || { echo "modules not loaded: no dotfiles alias" >&2; exit 1; }'

# run_check <name> <PATH> <files to link into HOME> <command...>
#
# The third argument lists the checkout's startup files the shell reads
# from HOME, space-separated; pass "" when the command names its file
# directly.
run_check() {
    local name=$1
    local check_path=$2
    local link_files=$3
    shift 3
    local tmp_home stderr_file status errors file
    tmp_home="$(mktemp -d)"
    stderr_file="$(mktemp)"
    status=0
    for file in ${link_files}; do
        ln -s "${dotfiles}/${file}" "${tmp_home}/${file}"
    done
    env -i \
        HOME="${tmp_home}" \
        DOTFILES="${dotfiles}" \
        PATH="${check_path}" \
        TERM=dumb \
        "$@" </dev/null >/dev/null 2>"${stderr_file}" || status=$?
    errors="$(grep -v -E "${noise}" "${stderr_file}" || true)"
    rm -rf "${tmp_home}" "${stderr_file}"
    if [ "${status}" -ne 0 ] || [ -n "${errors}" ]; then
        echo "FAIL  ${name}  (exit ${status}, PATH=${check_path})"
        if [ -n "${errors}" ]; then
            printf '%s\n' "${errors}" | sed 's/^/      /'
        fi
        failed=1
    else
        echo "ok    ${name}  (PATH=${check_path})"
    fi
}

zsh_bin="$(command -v zsh || true)"
bash_bin="$(command -v bash)"

for search_path in "${check_paths[@]}"; do
    if [ -n "${zsh_bin}" ]; then
        # Login and interactive, so zsh reads .zshenv, .zprofile and .zshrc.
        # They are linked into HOME rather than read via ZDOTDIR pointing at
        # the checkout, because compinit writes .zcompdump into ZDOTDIR.
        run_check "zsh -il" "${search_path}" ".zshenv .zprofile .zshrc" \
            "${zsh_bin}" -i -l -c "${loaded}"
    else
        echo "FAIL  zsh not found"
        failed=1
    fi
    run_check "bash -i" "${search_path}" "" \
        "${bash_bin}" --rcfile "${dotfiles}/.bashrc" -i -c "${loaded}"
    # shellcheck disable=SC2016
    run_check "sh .profile" "${search_path}" "" /bin/sh -c '. "$1"' sh "${dotfiles}/.profile"
done

exit "${failed}"
