import type {Theme} from 'vitepress'
import DefaultTheme from 'vitepress/theme'
import ChoiceButton from './ChoiceButton.vue'

export default {
  extends: DefaultTheme,
  enhanceApp({app}) {
    app.component('ChoiceButton', ChoiceButton)
  }
} satisfies Theme
