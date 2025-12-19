#!/usr/bin/env bash

tar --create --gzip --file ~/m2_backup.tar.gz --preserve-permissions --same-owner --acls --xattrs --numeric-owner .

echo "all done."
