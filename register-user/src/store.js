import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

/* eslint-disable */
// eslint-disable-next-line
let store = new Vuex.Store({
    state: {
        token: localStorage.getItem('token') || '',
        status: '',
        user : {},
        myProfile: {},
        myTeamProfile: [],
        myAllProfile: [],

        myLastClock: {},

        myWorkingtimes: [],
        myTeamWorkingtimes: [],
        myAllWorkingtimes: [],
    },
    mutations: {
        clear_state(state) {
            state.status = ''
            state.token = localStorage.getItem('token') || ''
            state.user = {}
            state.myProfile = {}
            state.myTeamProfile = []
            state.myAllProfile = []
            state.clockIn = false
            state.startDateTime = ''
            state.myWorkingtimes = []
            state.myTeamProfile = []
            state.myAllWorkingtimes = []
        },
        request_load(state){
            state.status = 'loading'
        },
        request_success(state){
            state.status = 'success'
        },
        request_error(state){
            state.status = ''
        },
        profile_success(state, data){
            state.status = 'success'
            state.myProfile = data
        },
        team_profile_success(state, data){
            state.status = 'success'
            state.myTeamProfile = data
        },
        all_profile_success(state, data){
            state.status = 'success'
            state.myAllProfile = data
        },
        workingtimes_success(state, data){
            state.status = 'success'
            state.myWorkingtimes = data
        },
        change_success(state, data){
            state.status = 'success'
            state.myProfile = data
        },
        clock_success(state, data) {
            state.state = 'success'
            state.myLastClock = data
        },
        last_clock_success(state, data) {
            state.status = 'success'
            state.myLastClock = data
        },
        change_team_success(state) {
            state.status = 'success'
        }
    },
    actions: {
        init() {
            axios.defaults.headers.common['Authorization'] = localStorage.getItem('token') || ''
        },
        login({commit}, user){
            const ApiUrl = "http://localhost:4000/api/users/sign_in"
            return new Promise((resolve, reject) => {
                axios.post(ApiUrl, {email: user.email, password: user.password})
                    .then(resp => {
                        const token = resp.data
                        localStorage.setItem('token', token)
                        axios.defaults.headers.common['Authorization'] = token
                        this.token = token
                        commit('request_success')
                        resolve(resp)
                    })
                    .catch(err => {
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        lastClock({commit}) {
            const ApiUrl = "http://localhost:4000/api/clocks"
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        const clock = resp.data.data
                        commit('last_clock_success', clock)
                        resolve(resp)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        profile({commit}) {
            const ApiUrl = "http://localhost:4000/api/users"
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        const data = resp.data.data
                        commit('profile_success', data)
                        resolve(data)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        teamProfile({commit}, teamId) {
            const ApiUrl = "http://localhost:4000/api/users/team/" + teamId
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        const data = resp.data.data
                        console.log(data)
                        commit('team_profile_success', data)
                        resolve(data)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        allProfile({commit}) {
            const ApiUrl = "http://localhost:4000/api/users/all"
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        const data = resp.data.data
                        commit('all_profile_success', data)
                        resolve(data)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        dashboard({commit}){
            const ApiUrl = "http://localhost:4000/api/workingtimes"
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        const data = resp.data.data
                        commit('workingtimes_success', data)
                        resolve(data)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        teamDashboard({commit}, teamId){
            const ApiUrl = "http://localhost:4000/api/workingtimes/team/" + teamId
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        const data = resp.data.data
                        console.log(data)
                        resolve(data)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        selectedTeamMateHours({commit}, param){
            const ApiUrl = "http://localhost:4000/api/workingtimes/" + param.userId + "/team/" + param.teamId
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        const data = resp.data.data
                        resolve(data)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        changeTeam({commit}, param){
            const ApiUrl = "http://localhost:4000/api/users/" + param.userId + "/team/" + param.teamId
            return new Promise((resolve, reject) => {
                axios.put(ApiUrl)
                    .then(resp => {
                        const data = resp.data.data
                        commit('change_team_success', data)
                        resolve(data)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        register({commit}, user){
            const ApiUrl = "http://localhost:4000/api/users"
            return new Promise((resolve, reject) => {
                axios.post(ApiUrl, {users: user})
                    .then(resp => {
                        const token = resp.data.data.id
                        const user = resp.data.data
                        localStorage.setItem('token', token)
                        commit('request_success', [token, user])
                        resolve(resp)
                    })
                    .catch(err => {
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        change({commit}, user){
            const ApiUrl = "http://localhost:4000/api/users"
            return new Promise((resolve, reject) => {
                axios.put(ApiUrl, {users: user})
                    .then(resp => {
                        const data = resp.data.data
                        commit('change_success', data)
                        resolve(data)
                    })
                    .catch(err => {
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        delete({commit}) {
            const ApiUrl = "http://localhost:4000/api/users"
            return new Promise((resolve, reject) => {
                axios.delete(ApiUrl)
                    .then(resp => {
                        localStorage.removeItem('token')
                        delete axios.defaults.headers.common['Authorization']
                        commit('clear_state')
                        resolve(resp)
                    })
                    .catch(err => {
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        logout({commit}) {
            const ApiUrl = "http://localhost:4000/api/users/sign_out"
            return new Promise((resolve, reject) => {
                axios.get(ApiUrl)
                    .then(resp => {
                        localStorage.removeItem('token')
                        delete axios.defaults.headers.common['Authorization']
                        commit('clear_state')
                        resolve(resp)
                    })
                    .catch(err => {
                        localStorage.removeItem('token')
                        reject(err)
                    })
            })
        },
        clock({commit}){
            const ApiUrl = "http://localhost:4000/api/clocks/"
            return new Promise((resolve, reject) => {
                axios.post(ApiUrl)
                    .then(resp => {
                        const clock = resp.data.data
                        commit('clock_success', clock)
                        resolve(resp)
                    })
                    .catch(err => {
                        reject(err)
                    })
            })
        },
        clear({commit}) {
            commit('clear_state')
        }
    },
    getters : {
        isLoggedIn: state => !!state.token,
        authStatus: state => state.status,
    }
})

export default store
