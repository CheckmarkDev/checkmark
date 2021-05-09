import Vue from 'vue'
import { ValidationProvider, ValidationObserver, extend, setInteractionMode, localize } from 'vee-validate'
import * as rules from 'vee-validate/dist/rules'
import fr from 'vee-validate/dist/locale/fr.json'

Vue.component('ValidationProvider', ValidationProvider)
Vue.component('ValidationObserver', ValidationObserver)

Object.keys(rules).forEach(rule => {
  extend(rule, rules[rule])
})


localize('fr', fr)

setInteractionMode('lazy')
