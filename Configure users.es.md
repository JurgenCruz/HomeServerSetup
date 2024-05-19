# Configurar usuarios

[![en](https://img.shields.io/badge/lang-en-blue.svg)](Configure%20users.md)
[![es](https://img.shields.io/badge/lang-es-blue.svg)](Configure%20users.es.md)

Aparte del usuario `admin`, es necesario un usuario que llamaremos `mediacenter` para administrar el acceso a los archivos del Media Center y manejar el ecosistema de aplicaciones AAR. También es necesario un usuario por cada Samba share que se desee hacer. La guía usará 2 Samba shares de ejemplo y por ende, 2 usuarios: `nasj` y `nask`. El usuario `admin` será agregado a los grupos de cada usuario creado de manera que también tenga acceso a los archivos.

## Pasos

1. Asumir el rol de `root` ejecutando `sudo -i`.
2. Creamos usuarios `nasj`, `nask` y `mediacenter` y agregamos a `admin` a sus grupos: `printf "nasj\nnask\nmediacenter" | ./scripts/users_setup.sh admin`.

[<img width="33.3%" src="buttons/prev-Register ddns optional.es.svg" alt="Registrar DDNS (Opcional)">](Register%20ddns%20optional.es.md)[<img width="33.3%" src="buttons/jump-Index.es.svg" alt="Índice">](README.es.md)[<img width="33.3%" src="buttons/next-Install zfs.es.svg" alt="Instalar ZFS">](Install%20zfs.es.md)
