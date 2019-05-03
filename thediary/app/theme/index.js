import defaultTheme from './defaultTheme'
import darkTheme from './darkTheme'

const themes = {
  defaultTheme,
  darkTheme
}

export const myTheme = (theme) => {
  return themes[theme] === undefined ? defaultTheme : themes[theme]
}

export const getThemes = () => {
  return [{name: 'defaultTheme', theme: '#087377'},
    {name: 'darkTheme', theme: '#737'}]
}
