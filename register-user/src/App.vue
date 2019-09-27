<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <div id="app">
    <div>
      <b-navbar toggleable="lg" type="light" variant="light">
        <b-navbar-brand>
          GothamCity
        </b-navbar-brand>

        <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

        <b-collapse id="nav-collapse" is-nav>
          <b-navbar-nav>
            <b-nav-item variant="outline-secondary" @click="widget = 'home'">Home</b-nav-item>
            <b-nav-item @click="viewMyDashboard">My dashboard</b-nav-item>
            <b-nav-item @click="viewMyTeamProfile">Team Management</b-nav-item>
            <b-nav-item @click="viewMyAllProfile">General Management</b-nav-item>

            <b-nav-item v-if="logState === 'success'">
              <div v-if="myLastClock != null">
                <b-button v-if="myLastClock.status" variant="danger" size="sm" @click="timePoint">clock out (last clock'in {{myLastClock.time}})</b-button>
                <b-button v-else variant="success" size="sm" @click="timePoint">clock in (last clock'out {{myLastClock.time}})</b-button>
              </div>
              <div v-else>
                <b-button variant="success" size="sm" @click="timePoint">clock in</b-button>
              </div>
            </b-nav-item>
          </b-navbar-nav>

          <b-navbar-nav class="ml-auto">
            <b-nav-form>
              <b-form-input size="sm" class="mr-sm-2" placeholder="Search"></b-form-input>
              <b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>
            </b-nav-form>

            <b-nav-item-dropdown v-if="logState === 'success'" right>
              <template v-slot:button-content>
                <em>User</em>
              </template>
              <b-dropdown-item @click="viewMyProfile">Profile</b-dropdown-item>
              <b-dropdown-item v-if="logState === 'success'" @click="logout">Log out</b-dropdown-item>
            </b-nav-item-dropdown>
          </b-navbar-nav>
        </b-collapse>
      </b-navbar>
    </div>

    <div v-if="logState === 'success'">
      <div v-if="widget === 'home'">
        <gotham></gotham>
      </div>
      <div v-if="widget === 'dashboard'">
        <dashboard></dashboard>
      </div>
      <div v-if="widget === 'profile'">
        <profile></profile>
      </div>
      <div v-if="widget === 'team'">
        <team></team>
      </div>
      <div v-if="widget === 'general'">
        <general></general>
      </div>
    </div>

    <div v-if="logState === ''">
      <authentification></authentification>
    </div>

  </div>
</template>

<script>
  /* eslint-disable */
  // eslint-disable-next-line
  import Authentification from "./components/Authentification"
  import Gotham from "./components/Gotham"
  import Profile from "./components/Profile"
  import Dashboard from "./components/Dashboard"
  import Team from "./components/Team"
  import General from "./components/General"
export default {
  name: 'app',
  data() {
    return {
      componentState: this.$store.state.status,
      widget: 'home',
    }
  },
  created() {
    this.$store.dispatch('init')
    this.$store.dispatch('lastClock')
            .then(resp => console.log(resp))
            .catch(err => console.log(err))
  },
  computed : {
    logState: function(){ return this.$store.state.status},
    myProfile: function(){ return this.$store.state.myProfile},
    myLastClock: function(){
      console.log(this.$store.state.myLastClock);
      return this.$store.state.myLastClock;},
    myToken: function(){ return this.$store.state.token},

  },
  methods: {
    logout: function () {
      this.$store.dispatch('logout')
              .then(resp => {console.log(resp)})
              .catch(err => console.log(err))
    },
    timePoint: function () {
      this.$store.dispatch('clock')
              .then(resp => console.log(resp))
              .catch(err => console.log(err))
    },
    viewMyProfile: function () {
      this.$store.dispatch('profile')
              .then(() => this.widget = 'profile')
              .catch(err => console.log(err))
    },
    viewMyDashboard: function () {
      this.$store.dispatch('profile')
              .then(() =>
                      this.$store.dispatch('dashboard')
                        .then(() => this.widget = 'dashboard')
                        .catch(err => console.log(err))
              )
              .catch(err => console.log(err))
    },
    viewMyTeamProfile: function () {
      this.$store.dispatch('profile')
              .then(() => {
                this.$store.dispatch('teamProfile', this.$store.state.myProfile.team)
                        .then(resp => console.log(resp))
                        .catch(err => console.log(err))
                this.$store.dispatch('allProfile')
                        .then(() => this.widget = 'team')
                        .catch(err => console.log(err))
              })
              .catch(err => console.log(err))

    },
    viewMyAllProfile: function () {
      this.$store.dispatch('profile')
              .then(() => {
                this.$store.dispatch('allProfile')
                        .then(resp => {
                          console.log(resp)
                          this.widget = 'general'
                        })
                        .catch(err => console.log(err))
              })
              .catch(err => console.log(err))

    },
  },
  components: {
    Authentification,
    Gotham,
    Profile,
    Dashboard,
    Team,
    General,
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
</style>
