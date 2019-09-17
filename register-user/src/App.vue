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
            <b-nav-item @click="widget = 'home'">Home</b-nav-item>
            <b-nav-item @click="widget = 'dashboard'">My dashboard</b-nav-item>
            <b-nav-item @click="widget = 'team'">Manage my teams</b-nav-item>
            <b-nav-item><b-button variant="warning" size="sm" @click="timePoint">time point</b-button></b-nav-item>
          </b-navbar-nav>

          <b-navbar-nav class="ml-auto">
            <b-nav-form>
              <b-form-input size="sm" class="mr-sm-2" placeholder="Search"></b-form-input>
              <b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>
            </b-nav-form>

            <b-nav-item-dropdown v-if="logState === 'success'" right>
              <template v-slot:button-content>
                <em>{{logUsername}}</em>
              </template>
              <b-dropdown-item @click="widget = 'profile'">Profile</b-dropdown-item>
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
export default {
  name: 'app',
  data() {
    return {
      componentState: this.$store.state.status,
      widget: 'home'
    }
  },
  computed : {
    isLoggedIn : function(){ return this.$store.getters.isLoggedIn},
    logState: function(){ return this.$store.state.status},
    logUsername: function(){ return this.$store.state.user.username},

  },
  methods: {
    logout: function () {
      this.$store.dispatch('logout')
              .then(resp => {console.log(resp); this.componentState = this.$store.state.status; console.log(this.componentState)})
    },
    timePoint: function () {
      this.$store.dispatch('clock')
              .then(resp => console.log(resp))
    }
  },
  components: {
    Authentification,
    Gotham,
    Profile,
    Dashboard,
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
