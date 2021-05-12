const { colors, flex } = require('tailwindcss/defaultTheme')

module.exports = {
  darkMode: 'class',
  theme: {
    fontFamily: {
     'baloo': ['"Baloo Chettan 2"', 'system-ui']
    },
    flex: {
      ...flex,
      '1': '1 1 0'
    },
    container: {
      padding: '1rem'
    },
    screens: {
      sm: '375px',
      '2sm': '455px',
      md: '770px',
      lg: '1024px',
      xl: '1440px'
    },
    colors: {
      black: colors.black,
      white: colors.white,
      gray: colors.gray,
      red: colors.red,
      green: {
        500: '#84C318'
      },
      blue: {
        400: '#429ED7',
        500: '#2589C7',
        600: '#1B75BB',
        700: '#14405B'
      }
    }
  },
  variants: {
    backgroundColor: [
      "dark",
      "dark-hover",
      "dark-group-hover",
      "dark-even",
      "dark-odd"
    ],
    borderColor: ["dark", "dark-focus", "dark-focus-within"],
    textColor: ["dark", "dark-hover", "dark-active"]
  },
  plugins: []
}