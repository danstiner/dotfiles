#!/bin/bash

sudo sh -c 'umask 227 && echo "%sudo           ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/passwordless_sudo'

