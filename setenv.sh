#!/bin/bash

export WDS_DEMO=$( cd $( dirname "${BASH_SOURCE[0]}" ) > /dev/null && pwd )
export PATH=${WDS_DEMO}/bin:$PATH
