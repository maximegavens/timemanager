import Vue from 'vue'
import VueRouter from 'vue-router'
import App from "../App";

Vue.use(VueRouter)

let router = new VueRouter({
    mode: 'history',
    routes: [
        {
            path: '/',
            name: 'app',
            component: App
        },
    ]
})

export default router

router.beforeEach((to, from, next) => {
    if(to.matched.some(record => record.meta.requiresAuth)) {
        if (this.$store.getters.isLoggedIn) {
            next()
            return
        }
        next('/login')
    } else {
        next()
    }
})


