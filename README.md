## Docker images ##

More information can be found in the images subfolders.

Please note the hardcoded UID/GID that makes deployment easier, predictable and safer –no `chmod 777`, no running processes as root or with common UID/GID.

| Container |  User   |  UID  |  GID  |
|-----------|---------|-------|-------|
| jenkins   | jenkins | 61001 | 61001 |
| nexus     | nexus   | 61002 | 61002 |
