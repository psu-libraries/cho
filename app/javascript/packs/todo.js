import Vue from 'vue/dist/vue.esm'
import Todo from '../Todo'

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: '#app',
  template: '<Todo/>',
  components: { Todo }
})

