import Vue from 'vue'
import router from './router'
import Vuex from 'vuex'
import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import vueResource from 'vue-resource'
import store from './store'

Vue.use(vueResource)
Vue.use(Vuex)
Vue.use(BootstrapVue)
Vue.config.productionTip = false

new Vue({
  el: '#app',
  store,
  router,
  render: h => h('router-view')
}).$mount('#app')
