# Configure users

Apart from the `admin` user, a user that we will call `mediacenter` is necessary to manage access to Media Center files and manage the AAR application ecosystem. You also need one user for each Samba share you want to make. The user `admin` will be added to the groups of each created user so that it also have access to the files.

## Steps

1. Assume the `root` role by running `sudo -i`.
2. We create user `mediacenter` and add `admin` to their groups. If you want to add more users, separate them with `\n`; for example `"user1\nuser2"`: `printf "mediacenter" | ./scripts/users_setup.sh admin`.
