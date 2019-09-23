<template>
    <div>
        <!-- MANAGE PROFILE -->
        <div style="margin-top: 100px" v-if="isChange">
            <h4>MANAGE PROFILE</h4>
            <form @submit.prevent="updateUser">
                <label for="email" >E-Mail Address</label>
                <div>
                    <input id="email" type="email" v-model="email" required>
                </div>
                <label for="username" >Username</label>
                <div>
                    <input id="username" type="text" v-model="username" required>
                </div>
                <label for="password">Password</label>
                <div>
                    <input id="password" type="password" v-model="password_hash" required autofocus>
                </div>
                <div>
                    <b-button type="submit">Register</b-button>
                    <b-button variant="warning" @click="isChange = false">Cancel</b-button>
                </div>
                <div style="margin-top: 10px">
                    <b-button variant="danger" @click="deleteAccount">Delete my account</b-button>
                </div>
            </form>
        </div>
        <!-- PROFILE -->
        <div style="margin-top: 100px" v-else>
            <h4>Welcome {{username}}</h4>
            <p>identifiant : <b>{{id}}</b></p>
            <p>status : <b>{{role}}</b></p>
            <p>username : <b>{{username}}</b></p>
            <p>email : <b>{{email}}</b></p>
            <p>team : <b>{{team}}</b></p>
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
                id: this.$store.state.myProfile.id,
                username: this.$store.state.myProfile.username,
                email: this.$store.state.myProfile.email,
                password_hash: this.$store.state.myProfile.password_hash,
                team: this.$store.state.myProfile.team,
                role: this.$store.state.myProfile.role,
                errors: [],
            }
        },
        methods: {
            updateUser: function() {
                this.errors = [];
                this.$store.dispatch('change', {id: this.id, email: this.email, username: this.username, password_hash: this.password_hash, role: this.role, team: this.team})
                    .then(() => this.isChange = false)
                    .catch(err => console.log(err))
            },
            deleteAccount: function() {
                this.$store.dispatch('delete')
                    .then(resp => console.log(resp))
                    .catch(err => console.log(err))
            }
        }
    }
</script>

<style scoped>

</style>
