#!/bin/bash
#

while true; do update-ipsets --enable-all; echo "Sleeping until next refresh..."; sleep 3600; done