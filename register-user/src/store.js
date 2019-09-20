import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

/* eslint-disable */
// eslint-disable-next-line
let store = new Vuex.Store({
    state: {
        status: '',
        token: localStorage.getItem('token') || '',
        user : {},

        clockIn: false,
        startDateTime: '',

        workingtimes: [],
    },
    mutations: {
        auth_request(state){
            state.status = 'loading'
        },
        auth_success(state, data){
            state.status = 'success'
            state.token = data[0]
            state.user = data[1]
        },
        auth_error(state){
            state.status = 'error'
        },
        logout(state){
            state.status = ''
            state.token = ''
        },
        clock_request(state){
            state.clockIn = state
        },
        clock_success(state, data){
            state.clockIn = state
            state.startDateTime = data
        },
        clock_error(state, data){
            state.status = 'error'
        },
        workingtime_request(state){
            state.status = 'loading'
        },
        workingtime_success(state, data){
            state.status = 'success'
            state.workingtimes = data
        },
        workingtime_error(state, data){
            state.status = 'error'
        },
    },
    actions: {
        login({commit}, user){
            const ApiUrl = "http://localhost:4000/api/users?email=" + user.email + "&password=" + user.password
            return new Promise((resolve, reject) => {
                commit('auth_request')
                axios.get(ApiUrl)
                    .then(resp => {
                        const token = resp.data.data.id
                        const user = resp.data.data
                        localStorage.setItem('token', token)
                        //axios.defaults.headers.common['Authorization'] = token
                        commit('auth_success', [token, user])
                        resolve(resp)
                    })
                    .catch(err => {
                        commit('auth_error')
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        register({commit}, user){
            const ApiUrl = "http://localhost:4000/api/users"
            return new Promise((resolve, reject) => {
                commit('auth_request')
                axios.post(ApiUrl, {users: user})
                    .then(resp => {
                        console.log(resp.data)
                        const token = resp.data.data.id
                        const user = resp.data.data
                        localStorage.setItem('token', token)
                        commit('auth_success', [token, user])
                        resolve(resp)
                    })
                    .catch(err => {
                        commit('auth_error', err)
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        change({commit}, user){
            const ApiUrl = "http://localhost:4000/api/users/" + user.id
            return new Promise((resolve, reject) => {
                commit('auth_request')
                axios.put(ApiUrl, {users: user})
                    .then(resp => {
                        console.log(resp.data)
                        const token = resp.data.data.id
                        const user = resp.data.data
                        localStorage.setItem('token', token)
                        commit('auth_success', [token, user])
                        resolve(resp)
                    })
                    .catch(err => {
                        commit('auth_error', err)
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        logout({commit}){
            return new Promise((resolve, reject) => {
                commit('logout')
                localStorage.removeItem('token')
                //delete axios.defaults.headers.common['Authorization']
                resolve()
            })
        },
        clock({commit}, userId){
            const ApiUrl = "http://localhost:4000/api/clocks/" + userId.toString()
            return new Promise((resolve, reject) => {
                commit('clock_request')
                axios.post(ApiUrl)
                    .then(resp => {
                        console.log(resp.data)
                        //const WT = resp.data.data
                        //commit('in', resp)
                        resolve(resp)
                    })
                    .catch(err => {
                        console.log(err)
                        //commit('clock_error')
                        reject(err)
                    })
            })
        },
        getWorkingtimes({commit}, userId){
            const ApiUrl = "http://localhost:4000/api/workingtimes/" + userId.toString()
            return new Promise((resolve, reject) => {
                commit('workingtime_request')
                axios.get(ApiUrl)
                    .then(resp => {
                        const WT = resp.data.data
                        commit('workingtime_success', WT)
                        resolve(WT)
                    })
                    .catch(err => {
                        commit('workingtime_error')
                        reject(err)
                    })
            })
        },
    },
    getters : {
        isLoggedIn: state => !!state.token,
        authStatus: state => state.status,
    }
})

export default store
