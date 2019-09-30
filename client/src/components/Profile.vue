<template>
    <div style="margin-top: 100px; text-align: center">
        <!-- MANAGE PASSWORD -->
        <div v-if="mode === 'password'">
            <h4>MANAGE PASSWORD</h4>
            <form @submit.prevent="checkPassword">
                <label for="lastPassword" >Submit your current password</label>
                <div>
                    <input id="lastPassword" type="password" v-model="password" required>
                </div>
                <div>
                    <b-button type="submit">Submit</b-button>
                </div>
            </form>
            <form v-if="isPasswordOk" @submit.prevent="changePassword">
                <label for="confirmPassword" >Confirm password</label>
                <div>
                    <input id="confirmPassword" type="password" v-model="confirmPassword" required>
                </div>
                <label for="newPassword">New password</label>
                <div>
                    <input id="newPassword" type="password" v-model="newPassword" required>
                </div>
                <b-button type="submit">Register</b-button>
            </form>
            <b-button variant="warning" @click="cancel">Cancel</b-button>
        </div>
        <!-- MANAGE PROFILE -->
        <div v-if="mode === 'profile'">
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
                <div>
                    <b-button type="submit">Register</b-button>
                    <b-button variant="warning" @click="cancel">Cancel</b-button>
                </div>
                <div style="margin-top: 10px">
                    <b-button variant="danger" @click="deleteAccount">Delete my account</b-button>
                </div>
            </form>
        </div>
        <!-- PROFILE -->
        <div v-if="mode === 'main'">
            <h4>Welcome {{username}}</h4>
            <p>identifiant : <b>{{id}}</b></p>
            <p>status : <b>{{role}}</b></p>
            <p>username : <b>{{username}}</b></p>
            <p>email : <b>{{email}}</b></p>
            <p>team : <b>{{team}}</b></p>
            <b-button style="margin-right: 10px" @click="mode = 'profile'">change profile</b-button>
            <b-button @click="mode = 'password'">change password</b-button>
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
                mode: "main",
                isChange: false,
                id: this.$store.state.myProfile.id,
                username: this.$store.state.myProfile.username,
                email: this.$store.state.myProfile.email,
                password_hash: this.$store.state.myProfile.password_hash,
                team: this.$store.state.myProfile.team,
                role: this.$store.state.myProfile.role,
                isPasswordOk: false,

                password: null,
                confirmPassword: null,
                newPassword: null,
            }
        },
        methods: {
            updateUser() {
                this.$store.dispatch('change', {email: this.email, username: this.username})
                    .then(() => this.mode = 'main')
            },
            changePassword() {
                if (this.newPassword === this.confirmPassword) {
                    this.$store.dispatch('change', {email: this.email, username: this.username, password: this.newPassword})
                        .then(() => this.mode = 'main')
                        .catch(err => console.log(err))
                } else {
                    alert("Password and confirm password should be equal !")
                }
            },
            checkPassword() {
                this.$store.dispatch('login', {email: this.email, password: this.password})
                        .then(() => this.isPasswordOk = true)
                        .catch(() => alert("wrong password"))
            },
            deleteAccount() {
                this.$store.dispatch('delete')
                    .then(resp => {console.log(resp); this.mode = "main";})
                    .catch(err => console.log(err))
            },
            cancel() {
                this.isChange = false
                this.mode = "main"

                this.id = this.$store.state.myProfile.id
                this.username = this.$store.state.myProfile.username
                this.email = this.$store.state.myProfile.email
                this.password_hash = this.$store.state.myProfile.password_hash
                this.team = this.$store.state.myProfile.team
                this.role = this.$store.state.myProfile.role

                this.password = null
                this.confirmPassword = null
                this.newPassword = null
                this.isPasswordOk = false
            },
        }
    }
</script>

<style scoped>

</style>
