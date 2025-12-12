import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'GDSS Simulator',
  tagline: 'Group Decision Support System Simulator',
  favicon: 'img/favicon.ico',

  // ===== IMPORTANT: GitHub Pages Config =====
  url: 'https://vahidmoeinifar.github.io',
  baseUrl: '/DSSS-2025/',  // This is correct!
  organizationName: 'vahidmoeinifar',
  projectName: 'DSSS-2025',
  
  // ===== Deployment Config =====
  // Option A: Use gh-pages branch (Recommended)
  deploymentBranch: 'gh-pages',
  trailingSlash: false,
  
  // Option B: If you want to use /docs folder instead, use this:
  // outDir: './docs',  // Uncomment this to build to /docs folder
  // deploymentBranch: 'main',  // Keep as main

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
        blog: {
          showReadingTime: true,
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
          to: '/blog',
          label: 'Blog',
          position: 'left'
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
              to: '/docs/intro',
            },
            {
              label: 'User Guide',
              to: '/docs/category/user-guide',
            },
            {
              label: 'API Reference',
              to: '/docs/category/api-reference',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub Discussions',
              href: 'https://github.com/vahidmoeinifar/DSSS-2025/discussions',
            },
            {
              label: 'Issues',
              href: 'https://github.com/vahidmoeinifar/DSSS-2025/issues',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Blog',
              to: '/blog',
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