import {defineConfig} from 'vitepress'

export default defineConfig({
  base: 'HomeServerSetup',
  locales: {
    root: {
      label: 'English',
      lang: 'en',
      themeConfig: {
        sidebar: [
          {text: 'Introduction', link: '/'},
          {text: 'Objective', link: '/Objective'},
          {text: 'Motivation', link: '/Motivation'},
          {text: 'Features', link: '/Features'},
          {text: 'Design and justification', link: '/Design and justification'},
          {text: 'Minimum prerequisites', link: '/Minimum prerequisites'},
          {
            text: 'Guide',
            link: '/Guide',
            collapsed: false,
            items: [
              {text: 'Install Fedora Server', link: '/Install fedora server'},
              {text: 'Configure Secure Boot', link: '/Configure secure boot'},
              {text: 'Install and configure Zsh (Optional)', link: '/Install and configure zsh optional'},
              {text: 'Install Cockpit', link: '/Install cockpit'},
              {text: 'Register DDNS (Optional)', link: '/Register ddns optional'},
              {text: 'Configure users', link: '/Configure users'},
              {text: 'Install ZFS', link: '/Install zfs'},
              {
                text: 'Configure ZFS',
                link: '/Configure zfs',
                collapsed: false,
                items: [
                  {text: 'Create ZFS pool', link: '/Create zfs pool'},
                  {text: 'Import existing ZFS pool', link: '/Import existing zfs pool'},
                  {text: 'Migrate ZFS pool drives', link: '/Migrate zfs pool drives'},
                ]
              },
              {text: 'Configure shares', link: '/Configure shares'},
              {text: 'Install Docker', link: '/Install docker'},
              {text: 'Create shared networks stack', link: '/Create shared networks stack'},
              {
                text: 'Configure DNS',
                link: '/Configure dns',
                collapsed: false,
                items: [
                  {text: 'Configure router DNS', link: '/Configure router dns'},
                  {
                    text: 'Configure Technitium DNS',
                    link: '/Configure technitium dns',
                    collapsed: false, items: [
                      {text: 'Configure router DHCP', link: '/Configure router dhcp'},
                      {text: 'Configure Technitium DHCP', link: '/Configure technitium dhcp'},
                    ]
                  },
                ]
              },
              {text: 'Create and configure public external traffic stack', link: '/Create and configure public external traffic stack'},
              {text: 'Create and configure Nextcloud stack', link: '/Create and configure nextcloud stack'},
              {text: 'Create and configure arr applications stack', link: '/Create and configure arr applications stack'},
              {text: 'Create and configure AI stack', link: '/Create and configure ai stack'},
              {text: 'Create and configure Home Assistant stack', link: '/Create and configure home assistant stack'},
              {
                text: 'Create and configure private external traffic stack (Optional)',
                link: '/Create and configure private external traffic stack optional'
              },
              {text: 'Configure scheduled tasks', link: '/Configure scheduled tasks'},
            ]
          },
          {text: 'Glossary', link: '/Glossary'},
        ],
        sidebarMenuLabel: 'Menu',
        mobileMenuLabel: 'Menu',
        extraMenuLabel: 'More options',
        returnToTopLabel: 'Return to top',
        langMenuLabel: 'Change language',
        darkModeSwitchLabel: 'Appearance',
        darkModeSwitchTitle: 'Switch to dark theme',
        lightModeSwitchTitle: 'Switch to light theme',
        navMenuLabel: 'Main Navigation',
        footer: {
          message: 'Released under GPL-3.0 License.',
          copyright: 'Copyright © 2024-present Jurgen Cruz'
        },
        docFooter: {
          prev: 'Previous page',
          next: 'Next page'
        }
      },
      title: "NAS, Media Center and Home Automation Server",
      description: "This is a guide on how to set up a home server from scratch. If you are not familiar with a concept, the guide provides a glossary at the end of the guide for your convenience."
    },
    es: {
      label: 'Spanish',
      lang: 'es',
      themeConfig: {
        sidebar: {
          '/es/': {
            base: '/es/',
            items: [
              {text: 'Introducción', link: '/'},
              {text: 'Objetivo', link: '/Objective'},
              {text: 'Motivación', link: '/Motivation'},
              {text: 'Características', link: '/Features'},
              {text: 'Diseño y justificación', link: '/Design and justification'},
              {text: 'Prerequisitos mínimos', link: '/Minimum prerequisites'},
              {
                text: 'Guía',
                link: '/Guide',
                collapsed: false,
                items: [
                  {text: 'Instalar Fedora Server', link: '/Install fedora server'},
                  {text: 'Configurar Secure Boot', link: '/Configure secure boot'},
                  {text: 'Instalar y configurar Zsh (Opcional)', link: '/Install and configure zsh optional'},
                  {text: 'Instalar Cockpit', link: '/Install cockpit'},
                  {text: 'Registrar DDNS (Optional)', link: '/Register ddns optional'},
                  {text: 'Configurar usuarios', link: '/Configure users'},
                  {text: 'Instalar ZFS', link: '/Install zfs'},
                  {
                    text: 'Configurar ZFS',
                    link: '/Configure zfs',
                    collapsed: false,
                    items: [
                      {text: 'Crear alberca ZFS', link: '/Create zfs pool'},
                      {text: 'Importar alberca ZFS existente', link: '/Import existing zfs pool'},
                      {text: 'Migrar discos de la alberca ZFS', link: '/Migrate zfs pool drives'},
                    ]
                  },
                  {text: 'Configurar shares', link: '/Configure shares'},
                  {text: 'Instalar Docker', link: '/Install docker'},
                  {text: 'Crear stack de redes compartidas', link: '/Create shared networks stack'},
                  {
                    text: 'Configurar DNS',
                    link: '/Configure dns',
                    collapsed: false,
                    items: [
                      {text: 'Configurar DNS del router', link: '/Configure router dns'},
                      {
                        text: 'Configurar DNS de Technitium',
                        link: '/Configure technitium dns',
                        collapsed: false, items: [
                          {text: 'Configurar DHCP del router', link: '/Configure router dhcp'},
                          {text: 'Configurar DHCP de Technitium', link: '/Configure technitium dhcp'},
                        ]
                      },
                    ]
                  },
                  {
                    text: 'Crear y configurar stack de tráfico externo público',
                    link: '/Create and configure public external traffic stack'
                  },
                  {text: 'Crear y configurar stack de Nextcloud', link: '/Create and configure nextcloud stack'},
                  {text: 'Crear y configurar stack de aplicaciones arr', link: '/Create and configure arr applications stack'},
                  {text: 'Crear y configurar stack de IA', link: '/Create and configure ai stack'},
                  {text: 'Crear y configurar stack de Home Assistant', link: '/Create and configure home assistant stack'},
                  {
                    text: 'Crear y configurar stack de tráfico externo privado (Optional)',
                    link: '/Create and configure private external traffic stack optional'
                  },
                  {text: 'Configurar tareas programadas', link: '/Configure scheduled tasks'},
                ]
              },
              {text: 'Glosario', link: '/Glossary'},
            ]
          }
        },
        sidebarMenuLabel: 'Menú',
        mobileMenuLabel: 'Menú',
        extraMenuLabel: 'Más opciones',
        returnToTopLabel: 'Regresar al principio',
        langMenuLabel: 'Cambiar idioma',
        darkModeSwitchLabel: 'Apariencia',
        darkModeSwitchTitle: 'Cambiar al tema oscuro',
        lightModeSwitchTitle: 'Cambiar al tema claro',
        navMenuLabel: 'Navegación Principal',
        footer: {
          message: 'Publicado bajo la Licencia GPL-3.0.',
          copyright: 'Copyright © 2024-presente Jurgen Cruz'
        },
        docFooter: {
          prev: 'Página anterior',
          next: 'Página siguiente'
        }
      },
      title: 'Servidor NAS, Media Center y Home Automation',
      description: 'Esta es una guía de como configurar un servidor casero desde cero. Si usted no está familiarizado con algún concepto, la guía provee un glosario al final de la misma para su conveniencia.'
    }
  },
  themeConfig: {
    externalLinkIcon: true,
    gradedContainers: true,
    socialLinks: [
      {icon: 'github', link: 'https://github.com/JurgenCruz/HomeServerSetup'}
    ],
    outline: false,
    search: {
      provider: 'local',
      options: {
        locales: {
          es: {
            translations: {
              button: {
                buttonText: "Búsqueda",
                buttonAriaLabel: "Búsqueda"
              },
              modal: {
                backButtonTitle: 'Regresar',
                displayDetails: 'Mostrar lista detallada',
                noResultsText: 'No hay resultados para',
                resetButtonTitle: 'Restablecer búsqueda',
                footer: {
                  closeText: 'para cerrar',
                  navigateText: 'para navegar',
                  selectText: 'para seleccionar'
                }
              }
            }
          }
        }
      }
    }
  }
})
