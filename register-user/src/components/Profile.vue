<template>
    <div>
        <!-- MANAGE PROFILE -->
        <div style="margin-top: 100px" v-if="isChange">
            <h4>MANAGE PROFILE</h4>
            <form @submit.prevent="updateUser">
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
                    <b-button type="submit">Register</b-button>
                </div>
                <div style="margin-top: 10px">
                    <b-button variant="danger" @click="isChange = false">Cancel</b-button>
                </div>
            </form>
        </div>
        <!-- PROFILE -->
        <div style="margin-top: 100px" v-else>
            <h4>Welcome {{storeContent.user.username}}</h4>
            <p>identifiant : <b>{{storeContent.user.id}}</b></p>
            <p>username : <b>{{storeContent.user.username}}</b></p>
            <p>email : <b>{{storeContent.user.email}}</b></p>
            <p>password : <b>{{storeContent.user.password}}</b></p>
            <p>team : <b>{{storeContent.user.team}}</b></p>
            <p>status : <b>{{storeContent.user.status}}</b></p>
            <b-button @click="isChange = true">change profile</b-button>
        </div>
    </div>
</template>

<script>
    /* eslint-disable */
    // eslint-disable-next-line
    export default {
        name: "Profile",
        data() {
            return {
                isChange: false,
                storeContent: this.$store.state,
                id: this.$store.state.user.id,
                username: this.$store.state.user.username,
                email: this.$store.state.user.email,
                password: this.$store.state.user.password,
                team: this.$store.state.user.team,
                status: this.$store.state.user.status,
                errors: [],
            }
        },
        methods: {
            updateUser: function() {
                this.errors = [];
                this.$store.dispatch('change', {id: this.id, email: this.email, username: this.username, username: this.username, status: this.status, team: this.team})
                    .then(() => this.isChange = false)
                    .catch(err => console.log(err))
            }
        }
    }
</script>

<style scoped>

</style>
