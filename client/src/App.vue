<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
  <div id="app">
    <div>
      <b-navbar toggleable="lg" type="light" variant="light">
        <b-navbar-brand>
          GothamCity
        </b-navbar-brand>
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

          <b-navbar-nav v-if="logState === 'success'" right class="ml-auto">
            <b-nav-item @click="viewMyProfile">Profile</b-nav-item>
            <b-nav-item @click="logout">Log out</b-nav-item>
          </b-navbar-nav>
        </b-collapse>
      </b-navbar>
    </div>

    <div style="margin-top: 50px" v-if="logState === 'success'">
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
    myLastClock: function(){ return this.$store.state.myLastClock;},
  },
  methods: {
      resetParam() {
        this.widget = "home"
      },
    logout() {
      this.$store.dispatch('logout')
              .then(resp => {console.log(resp); this.resetParam()})
              .catch(err => console.log(err))
    },
    timePoint() {
      this.$store.dispatch('clock')
              .then(resp => console.log(resp))
              .catch(err => console.log(err))
    },
    viewMyProfile() {
      this.$store.dispatch('profile')
              .then(() => this.widget = 'profile')
              .catch(err => console.log(err))
    },
    viewMyDashboard() {
      this.$store.dispatch('profile')
              .then(() =>
                      this.$store.dispatch('dashboard')
                        .then(() => this.widget = 'dashboard')
                        .catch(err => console.log(err))
              )
              .catch(err => console.log(err))
    },
    viewMyTeamProfile() {
      this.$store.dispatch('profile')
              .then(() => {
                this.$store.dispatch('teamProfile', this.$store.state.myProfile.team)
                        .then(resp => console.log(resp))
                        .catch(err => {alert("Sorry, access restricted."); console.log(err);})
                this.$store.dispatch('allProfile')
                        .then(() => this.widget = 'team')
                        .catch(err => console.log(err))
              })
              .catch(err => console.log(err))

    },
    viewMyAllProfile() {
      this.$store.dispatch('profile')
              .then(() => {
                this.$store.dispatch('allProfile')
                        .then(resp => {
                          console.log(resp);
                          this.widget = 'general';
                          this.$store.dispatch('allDashboard')
                                .then(resp => console.log(resp))
                                .catch(err => {console.log(err); alert("Sorry, access restricted.");});
                        })
                        .catch(err => {console.log(err); alert("Sorry, access restricted.");})

              })
              .catch(err => {
                  console.log(err);
                  alert("the token has expired");
              })
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
