#!/bin/bash

set -eufo pipefail

sudo softwareupdate -i -a && xcode-select --install || true
