#!/bin/sh

###
### $Release: 0.0.0 $
### $License: Public Domain $
###

_install_perl() {
    local version=$1
    local prefix=$2
    local lang="perl"
    local bin="perl"
    local base="perl-$version"
    local filename="$base.tar.gz"
    local configure="./Configure -des -Dprefix=$prefix"
    local url="http://www.cpan.org/src/5.0/$filename"
    . $HOME/.vs/installers/vs_install.sh
    _generic_installer "$lang" "$bin" "$version" "$base" "$filename" "$url" "$prefix" "$configure" || return 1
    ## install 'cpanm'
    local prompt='**'
    local script="cpanm"
    local script_path
    local input
    echo
    echo -n "$prompt Install '$script' command? [Y/n]: "
    read input;  [ -z "$input" ] && input="y"
    case "$input" in
    y*|Y*)
        ## inform required libraries
        _vs_inform_required_libraries "$prompt"      || return 1
        ##
        url="http://cpanmin.us/"
        local down
        down=`_downloader "-Lo" "--no-check-certificate -O"` || return 1
        _cmd "$down $prefix/bin/$script $url"        || return 1
        _cmd "chmod a+x $prefix/bin/$script"         || return 1
        _cmd "which $script"                         || return 1
        script_path=`which $script`
        if [ "$script_path" != "$prefix/bin/$script" ]; then
            echo "$prompt ERROR: $script seems not installed correctly." 1>&2
            echo "$prompt exit 1" 1>&2
            return 1
        fi
        echo "$prompt $script installed successfully."
        ;;
    *)
        echo "$prompt skip to install $script command."
        ;;
    esac
    ## finish
    echo
    echo "$prompt Installation finished successfully."
    echo "$prompt   language:  $lang"
    echo "$prompt   version:   $version"
    echo "$prompt   directory: $prefix"
}

if [ -n "$1" -a -n "$2" ]; then
    if [ "root" = `whoami` ]; then
        echo "*** not allowed to execute by root user!" 1>&2
        echo "*** exit 1" 1>&2
        exit 1
    fi
    _install_perl "$1" "$2"
fi
