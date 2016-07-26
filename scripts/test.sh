#!/bin/bash

./lb_haproxy_stats_processor.sh >/vagrant/scripts/logs/lb_haproxy_stats_processor.out 2>/vagrant/scripts/logs/lb_haproxy_stats_processor.err &
./lb_haproxy_file_editor.sh >/vagrant/scripts/logs/lb_haproxy_file_editor.out 2>/vagrant/scripts/logs/lb_haproxy_file_editor.err &
