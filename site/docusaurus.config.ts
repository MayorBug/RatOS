// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion
import type { Config } from "@docusaurus/types";
import type { Options, ThemeConfig } from "@docusaurus/preset-classic";
import { themes } from "prism-react-renderer";
import { renderToString } from "react-dom/server";
import React from "react";

const lightCodeTheme = themes.github;
const darkCodeTheme = themes.dracula;

const config: Config = {
	title: "RatOS",
	tagline: "The easy way to run Klipper on your 3D printer",
	url: "https://os.ratrig.com",
	baseUrl: "/",
	onBrokenLinks: "throw",
	onBrokenMarkdownLinks: "warn",
	favicon: "img/favicon.png",
	organizationName: "Rat-OS", // Usually your GitHub org/user name.
	projectName: "RatOS", // Usually your repo name.
	future: {
		experimental_faster: true,
	},
	presets: [
		[
			"@docusaurus/preset-classic",
			{
				docs: {
					sidebarPath: require.resolve("./sidebars.js"),
					// Please change this to your repo.
					editUrl: "https://github.com/Rat-OS/RatOS/edit/v2.x/site/",
					lastVersion: "current",
					versions: {
						current: {
							label: "2.1.x",
							path: "",
						},
						"2.1.0rc3": {
							label: "2.1.0-RC3",
							path: "2.1.0rc3",
						},
						"2.0.x": {
							label: "2.0.x",
							path: "/2.0.x",
						},
						"1.2.x": {
							label: "1.2.x",
							path: "/1.2.x",
						},
					},
				},
				blog: {
					showReadingTime: true,
					// Please change this to your repo.
					editUrl: "https://github.com/Rat-OS/RatOS/edit/v2.x/site/",
				},
				theme: {
					customCss: require.resolve("./src/css/custom.css"),
				},
				gtag: {
					trackingID: "G-NQB0MHKGLP",
					anonymizeIP: true,
				},
			} satisfies Options,
		],
	],
	plugins: [
		require.resolve("docusaurus-plugin-image-zoom"),
		async function tailwindPlugin(): Promise<any> {
			return {
				name: "docusaurus-tailwindcss",
				configurePostCss(postcssOptions: any) {
					postcssOptions.plugins.push(require("tailwindcss"));
					postcssOptions.plugins.push(require("autoprefixer"));
					return postcssOptions;
				},
			};
		},
	],
	themeConfig: {
		image: "img/site-banner.png?bust=1",
		algolia: {
			// If Algolia did not provide you any appId, use 'BH4D9OD16A'
			appId: "C4EC7MR0DP",

			// Public API key: it is safe to commit it
			apiKey: "e8599497fd4d4d7f251685c6eb1333f0",

			indexName: "ratrig",

			//... other Algolia params
		},
		zoom: {
			selector: ".markdown img",
			background: { dark: "#000" },
			config: {
				margin: 60,
			},
		},
		colorMode: {
			defaultMode: "dark",
			disableSwitch: true,
		},
		navbar: {
			title: "",
			logo: {
				alt: "RatOS",
				src: "img/logos/Logo-white.svg",
			},
			items: [
				{
					type: "doc",
					docId: "introduction",
					position: "left",
					label: "Documentation",
				},
				{ to: "/blog", label: "Blog", position: "left" },
				{ to: "/changelog", label: "Changelog", position: "left" },
				{
					href: "https://github.com/sponsors/miklschmidt",
					label: "Sponsor",
					position: "left",
				},
				{
					label: "Social",
					position: "left",
					items: [
						{
							href: "https://discord.gg/ratrig",
							label: "Discord",
						},
						{
							href: "https://github.com/Rat-OS/RatOS",
							label: "GitHub",
						},
					],
				},
				{
					type: "html",
					value: `<a 
						href="https://github.com/Rat-OS/RatOS/releases" 
						class="[.navbar-sidebar_&]:!hidden hidden [@media(min-width:1100px)]:inline-flex items-center justify-center border 
						       hover:no-underline font-semibold rounded-md focus:outline-none focus:ring-2 
							   capitalize relative active:translate-y-px active:scale-[99%] active:outline-none transition-all 
							   text-white hover:text-white bg-brand-400/50 hover:bg-brand-700 border-transparent 
							   focus:ring-offset-2 focus:ring-brand-400 dark:focus:ring-offset-zinc-900 
							   shadow-[0px_0px_0px_1px_rgba(9,9,11,0.07),0px_2px_2px_0px_rgba(9,9,11,0.05)] 
							   dark:shadow-[0px_0px_0px_1px_rgba(255,255,255,0.05)] dark:before:-inset-px dark:before:rounded-lg 
							   dark:before:pointer-events-none dark:before:absolute 
							   dark:before:shadow-[0px_2px_8px_0px_hsl(var(--brand-900)),_0px_1px_0px_0px_hsl(var(--brand-400)_/_50%)_inset] 
							   px-3 py-2 text-sm gap-2"
					>
						<span class="hidden xl:inline-flex gap-2">
						<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-cloud-download size-5"><path d="M12 13v8l-4-4"></path><path d="m12 21 4-4"></path><path d="M4.393 15.269A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.436 8.284"></path></svg>
						Download RatOS
						</span>
						<span class="xl:hidden">Download</span>
					</a>`,
					position: "right",
				},
				{
					type: "docsVersionDropdown",
					position: "right",
					dropdownItemsAfter: [
						{ to: "/changelog", label: "Changelog" },
					],
					dropdownActiveClassDisabled: true,
				},
			],
		},
		prism: {
			theme: lightCodeTheme,
			darkTheme: darkCodeTheme,
			additionalLanguages: ["bash", "python", "gcode", "properties"],
		},
	} satisfies ThemeConfig,
} satisfies Config;

module.exports = config;
