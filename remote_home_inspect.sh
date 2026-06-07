#!/usr/bin/env bash

# prevents
ssh_options="-o BatchMode=yes -o ConnectTimeout=5"

# either takes your argumment into $1 or prints out the error
target="${1:?Error: missing SSH target. Usage: ./remote_home_inspect.sh remote_user@host}"

# I'm not really sure why but my editor isn't allowing me to place the
# terminator variable after the ">/dev/null" so I'm not using it here.
# This below basically tests for a connection and provides the user with
# debugging solutions if it isn't successful.
ssh $ssh_options "$target" echo connected >/dev/null 2>/dev/null || {
  echo "Error: Could not connect to '$target' using SSH."
  echo "Make sure:"
  echo " - You typed the user and host in correctly. Should look like user@host"
  echo " - You connected to the school's VPN"
  echo " - You have your SSH keys set up for the host you're connecting to"
  echo " - That you can connect using SSH outside of the script to your host using:"
  echo "    ssh $target"
  exit 2
}

remote_user="$(ssh $ssh_options "$target" whoami 2>/dev/null)"
remote_home="$(ssh $ssh_options "$target" pwd 2>/dev/null)"
home_usage="$(ssh $ssh_options "$target" "du -sh ~" 2>/dev/null)"
home_entry_count="$(ssh $ssh_options "$target" "ls | wc -l" 2>/dev/null)"
remote_time="$(ssh $ssh_options "$target" date 2>/dev/null)"

echo "Target: $target"
echo "Remote User: $remote_user"
echo "Remote Home: $remote_home"
echo "Home Usage: $home_usage"
echo "Home Entry Count: $home_entry_count"
echo "Remote Time: $remote_time"
