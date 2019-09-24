<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
    <div>
        <div style="margin-top: 50px">
            <b-row align-h="around">
                <b-col cols="7">
                    <div class="card">
                        <div class="card-header">
                            Manage My Team
                        </div>
                        <div class="card-body">
                            <h6 class="card-subtitle text-muted">My Team (n°{{teamId}})</h6>
                                <b-table striped hover :items="team" :fields="fields">
                                    <template v-slot:cell(action)="row">
                                        <b-button size="sm" @click="viewSelectedTeamMateHours(row.item)" class="mr-2">
                                            Dashboard
                                        </b-button>
                                        <b-button size="sm" @click="removeFromTheTeam(row.item.id)" class="mr-2">
                                            Remove
                                        </b-button>
                                    </template>
                                </b-table>
                            <h6 class="card-subtitle text-muted">
                                <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapseExample" aria-expanded="true" aria-controls="collapseExample">
                                    All Users
                                </button>
                            </h6>
                            <div id="collapseExample" class="collapse">
                                <b-table striped hover :items="allUser" :fields="fields">
                                    <template v-slot:cell(action)="row">
                                        <b-button size="sm" @click="addToTheTeam(row.item.id)" class="mr-2">
                                            Add
                                        </b-button>
                                    </template>
                                </b-table>
                            </div>
                        </div>
                    </div>
                </b-col>
                <b-col cols="12">
                    <div class="card">
                        <div class="card-header"><h4 class="card-title">{{selectedTeamMate.username}} dashboard</h4></div>
                        <div class="card-body">
                            <dashboard :workingtimes="selectedWorkingtimes"></dashboard>
                        </div>
                    </div>

                </b-col>
            </b-row>
        </div>
    </div>
</template>

<script>
    /* eslint-disable */
    // eslint-disable-next-line
    import Dashboard from "./Dashboard"
    export default {
        name: "Team",
        data() {
            return {
                fields: ['id', 'team', 'username', 'role', 'email', 'action'],
                team: this.$store.state.myTeamProfile,
                allUser: this.$store.state.myAllProfile,
                teamId: this.$store.state.myProfile.team,
                selectedTeamMate: {},
                selectedWorkingtimes: [],
            }
        },
        methods: {
            removeFromTheTeam: function(id) {
                console.log(this.teamId)
                const param = {userId: id, teamId: '-1'}
                this.$store.dispatch('changeTeam', param)
                    .then(() => {
                        this.$store.dispatch('teamProfile', this.teamId)
                            .then(() => this.team = this.$store.state.myTeamProfile)
                            .catch(err => console.log(err))
                        this.$store.dispatch('allProfile')
                            .then(() => this.allUser = this.$store.state.myAllProfile)
                            .catch(err => console.log(err))
                    })
                    .catch(err => console.log(err))
            },
            addToTheTeam: function(id) {
                console.log(this.teamId)
                const param = {userId: id, teamId: this.teamId}
                this.$store.dispatch('changeTeam', param)
                    .then(() => {
                        this.$store.dispatch('teamProfile', this.teamId)
                            .then(() => this.team = this.$store.state.myTeamProfile)
                            .catch(err => console.log(err))
                        this.$store.dispatch('allProfile')
                            .then(() => this.allUser = this.$store.state.myAllProfile)
                            .catch(err => console.log(err))
                    })
                    .catch(err => console.log(err))
            },
            viewSelectedTeamMateHours: function(teamMate) {
                this.selectedTeamMate = teamMate
                const param = {userId: teamMate.id, teamId: this.teamId}
                this.$store.dispatch('selectedTeamMateHours', param)
                    .then(resp => {
                        console.log(resp)
                        this.selectedWorkingtimes = resp
                    })
                    .catch(err => console.log(err))
            },
        },
        components: {
            Dashboard,
        }
    }
</script>

<style scoped>

</style>
