export _SBCL_GLIBC_POSTFIX=-glibc2.10
export _SBCL_VERSION=${LISP_VERSION:-2.1.8}

_install_sbcl() {
    SBCL_URL=$1
    SBCL_GLIBC_POSTFIX=$2

    SBCL_NAME=sbcl-$_SBCL_VERSION-x86-64-linux$SBCL_GLIBC_POSTFIX
    SBCL_ARCHIVE_NAME=$SBCL_NAME-binary.tar.bz2
    SBCL_ARCHIVE_FILE=/tmp/$SBCL_ARCHIVE_NAME
    SBCL_BIN=$LISP_INSTALL_PREFIX/bin/sbcl

    if lisp_id_exists "$SBCL_NAME"; then
        echo "$SBCL_NAME already installed. Skipping."
        return 0
    fi

    write_lisp_id "$SBCL_NAME"

    rm -rf $LISP_INSTALL_PREFIX/*

    curl -L $SBCL_URL/$_SBCL_VERSION/$SBCL_ARCHIVE_NAME \
         --output $SBCL_ARCHIVE_FILE

    cd /tmp/ && tar -xf $SBCL_ARCHIVE_FILE

    cd /tmp/$SBCL_NAME/ && ./install.sh --prefix=$LISP_INSTALL_PREFIX

    ln -s $SBCL_BIN $LISP_BIN
}

install_sbcl () {
    _install_sbcl https://sourceforge.net/projects/sbcl/files/sbcl/
}

install_sbcl_ros() {
    _install_sbcl https://github.com/roswell/sbcl_bin/releases/download/ $_SBCL_GLIBC_POSTFIX
}

print_lisp_id_sbcl() {
    echo "sbcl-$_SBCL_VERSION-x86-64-linux"
}

print_lisp_id_sbcl_ros() {
    echo "sbcl-$_SBCL_VERSION-x86-64-linux-ros$_SBCL_GLIBC_POSTFIX"
}
