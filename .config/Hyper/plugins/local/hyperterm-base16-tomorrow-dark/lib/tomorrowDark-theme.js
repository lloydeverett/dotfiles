
// Terminal emulator colors: Copied from vim gruvbox color scheme
// colors.bg0               terminal_color_0       #282828
// colors.neutral_red       terminal_color_1       #cc241d
// colors.neutral_green     terminal_color_2       #98971a
// colors.neutral_yellow    terminal_color_3       #d79921
// colors.neutral_blue      terminal_color_4       #458588
// colors.neutral_purple    terminal_color_5       #b16286
// colors.neutral_aqua      terminal_color_6       #689d6a
// colors.fg4               terminal_color_7       #a89984
// colors.gray              terminal_color_8       #928374
// colors.red               terminal_color_9       #fb4934
// colors.green             terminal_color_10      #b8bb26
// colors.yellow            terminal_color_11      #fabd2f
// colors.blue              terminal_color_12      #83a598
// colors.purple            terminal_color_13      #d3869b
// colors.aqua              terminal_color_14      #8ec07c
// colors.fg1               terminal_color_15      #ebdbb2

const foregroundColor = '#ebdbb2';
const backgroundColor = '#1d1f21';
const borderColor = '#161719';
const red = '#fb4934';
const green = '#b8bb26';
const yellow = '#fabd2f';
const blue = '#83a598';
const pink = '#d3869b';
const cyan = '#8ec07c';
const lightGrey = '#a89984';
const mediumGrey = '#928374';
const white = '#ffffff';

// const foregroundColor = '#c5c8c6';
// const backgroundColor = '#1d1f21';
// const borderColor = '#161719';
// const red = '#cc6666';
// const green = '#b5b84d';
// const yellow = '#de935f';
// const blue = '#81a2be';
// const pink = '#b294bb';
// const cyan = '#81a2be';
// const lightGrey = '#d5d9dc';
// const mediumGrey = '#909898';
// const white = '#ffffff';

module.exports = (config) => {
  const themeOptions = config.themeOptions || {};
  const css = config.css || '';
  const termCSS = config.termCSS || '';

  return {
    foregroundColor: themeOptions.foregroundColor || foregroundColor,
    backgroundColor: themeOptions.backgroundColor || backgroundColor,
    borderColor: themeOptions.borderColor || borderColor,
    cursorColor: themeOptions.cursorColor || '#c5c8c6',
    colors: [
      backgroundColor,
      red,
      green,
      yellow,
      blue,
      pink,
      cyan,
      lightGrey,
      mediumGrey,
      red,
      green,
      yellow,
      blue,
      pink,
      cyan,
      white,
      foregroundColor,
    ],
    termCSS: `
      ${termCSS}
      .cursor-node {
        mix-blend-mode: difference;
      }
    `,
    css: `
      ${css}
      .header_header {
        top: 0;
        right: 0;
        left: 0;
      }
      .tabs_list {
        background-color: ${themeOptions.borderColor || borderColor};
        border-bottom-color: rgba(0,0,0,.15) !important;
      }
      .tab_tab.tab_active {
        font-weight: 500;
        background-color: ${themeOptions.activeTabColor || backgroundColor};
        border-color: rgba(0,0,0,.27) !important;
      }
      .tab_tab.tab_active::before {
        border-bottom-color: ${themeOptions.activeTabColor || backgroundColor};
      }
    `,
  };
};
