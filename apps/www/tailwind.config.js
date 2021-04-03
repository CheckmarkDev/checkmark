const { colors, flex } = require('tailwindcss/defaultTheme')

module.exports = {
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
      green: {
        500: '#84C318'
      },
      blue: {
        500: '#134074',
        600: '#13315C'
      }
    }
  },
  variants: {},
  plugins: []
}