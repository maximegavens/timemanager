<template>
    <div>
        <!-- WELCOME -->
        <div style="margin-top: 100px" v-if="logState === ''">
            <div class="row justify-content-center" style="margin-top: 100px;">
                <img style="margin-right: 15px" src="../assets/149aa4077fac60a8499361550408.jpg" width="80" height="80">
                <h2 style="align-content: center"><b>TIME MANAGER</b><br><small>Welcome to Gotham City</small></h2>
            </div>
            <div style="margin-top: 20px">
                <b-button style="margin-right: 20px" variant="outline-dark" @click="logState = 'login'">Log in</b-button>
                <b-button variant="outline-dark" @click="logState = 'register'">Register</b-button>
            </div>
        </div>

        <!-- LOGIN -->
        <div style="margin-top: 100px" v-if="logState === 'login'">
            <form class="login" @submit.prevent="getUser">
                <h4>Please select your login :</h4>
                <label>Email</label>
                <input required v-model="email" type="email" placeholder="Email"/>
                <label style="margin-left: 10px">Password</label>
                <input required v-model="password" type="password" placeholder="password"/>
                <hr/>
                <button type="submit">Login</button>
            </form>
        </div>

        <!-- REGISTER -->
        <div style="margin-top: 100px" v-if="logState ==='register'">
            <h4>REGISTER</h4>
            <form @submit.prevent="createUser">
                <label for="password">Password</label>
                <div>
                    <input id="password" type="password" v-model="password" required autofocus>
                </div>
                <label for="email" >E-Mail Address</label>
                <div>
                    <input id="email" type="email" v-model="email" required>
                </div>
                <label for="team" >Your team</label>
                <div>
                    <input id="team" type="number" v-model="team" required>
                </div>
                <label for="username" >Username</label>
                <div>
                    <input id="username" type="text" v-model="username" required>
                </div>
                <label for="status" >E-Mail Address</label>
                <div>
                    <input id="status" type="text" v-model="status" required>
                </div>
                <div>
                    <button type="submit">Register</button>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
    /* eslint-disable */
    // eslint-disable-next-line
    export default {
        name: "Authentification",
        data() {
            return {
                is_admin: null,
                username: '',
                email: '',
                password: '',
                team: -1,
                status: '',
                id: -1,
                errors: [],
                storeContent: this.$store.state,
                logState: '',
            }
        },
        computed : {
            isLoggedIn : function(){ return this.$store.getters.isLoggedIn}
        },
        methods: {
            getUser () {
                this.$store.dispatch('login', {email: this.email, password: this.password})
                    .then(() => {this.$store.dispatch('lastClock').then(resp => console.log(resp));
                        this})
                    .catch(err => console.log(err))
            },
            createUser() {
                this.errors = [];
                this.$store.dispatch('register', {email: this.email, username: this.username, username: this.username, status: this.status, team: this.team})
                    .then(resp => this.logState = 'login')
                    .catch(err => console.log(err))
            },
        }
    }
</script>

<style scoped>

</style>
