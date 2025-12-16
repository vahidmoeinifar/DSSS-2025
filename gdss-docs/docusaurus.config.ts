import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'GDSS Simulator',
  tagline: 'Group Decision Support System Simulator',
  favicon: 'img/favicon.ico',

  url: 'https://vahidmoeinifar.github.io',
  baseUrl: '/DSSS-2025/',  // This is correct!
  organizationName: 'vahidmoeinifar',
  projectName: 'DSSS-2025',
  
  deploymentBranch: 'gh-pages',
  trailingSlash: false,
  

  future: {
    v4: true,
  },

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/',  // Makes docs the homepage
          editUrl: 'https://github.com/vahidmoeinifar/DSSS-2025/tree/main/',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'GDSS Simulator',
      logo: {
        alt: 'GDSS Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Documentation',
        },
          {
          href: 'https://github.com/vahidmoeinifar/DSSS-2025',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documentation',
          items: [
            {
              label: 'Getting Started',
              to: '/Getting%20Started',
            },
            {
              label: 'Frequently Asked Questions',
              to: '/Frequently%20Asked%20Questions',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Readme',
              to: 'https://github.com/vahidmoeinifar/DSSS-2025/blob/main/README.md',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/vahidmoeinifar/DSSS-2025',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} GDSS Simulator by Vahid Moeinifar. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;