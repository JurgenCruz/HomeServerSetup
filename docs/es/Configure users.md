# Configurar usuarios

Aparte del usuario `admin`, es necesario un usuario que llamaremos `mediacenter` para administrar el acceso a los archivos del Media Center y manejar el ecosistema de aplicaciones AAR. También es necesario un usuario por cada Samba share que se desee hacer. El usuario `admin` será agregado a los grupos de cada usuario creado de manera que también tenga acceso a los archivos.

## Pasos

1. Asumir el rol de `root` ejecutando `sudo -i`.
2. Creamos usuario `mediacenter` y agregamos a `admin` a sus grupos. Si quiere agregar más usuarios, sepárelos con `\n`; por ejemplo `"usuario1\nusuario2"`: `printf "mediacenter" | ./scripts/users_setup.sh admin`.
