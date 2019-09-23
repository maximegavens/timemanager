import Vue from 'vue'
import router from './router'
import Vuex from 'vuex'
import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import vueResource from 'vue-resource'
import store from './store'
import moment from 'moment'
import Raphael from 'raphael/raphael'
global.Raphael = Raphael

Vue.use(vueResource)
Vue.use(Vuex)
Vue.use(BootstrapVue)
Vue.use(moment);
Vue.config.productionTip = false

Vue.filter('formatDate', function(value) {
  if (value) {
    return moment(String(value)).format('MM/DD/YYYY hh:mm:ss')
  }
});

new Vue({
  el: '#app',
  store,
  router,
  render: h => h('router-view'),
  //created(){
  //  this.$store.dispatch('lastClock');
  //},
}).$mount('#app')
