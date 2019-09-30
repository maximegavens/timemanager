<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
    <div>
        <div style="margin-top: 50px">
            <b-row>
                <b-col cols="2">
                </b-col>
                <b-col cols="4">
                    <div class="card">
                        <div style="text-align: center" class="card-header">
                            Team n°{{teamId}} list
                        </div>
                        <div class="card-body">
                                <b-table
                                        responsive
                                        :small="small"
                                        :bordered="bordered"
                                        :hover="hover"
                                        :no-border-collapse="noBorderCollapse"
                                        :head-variant="headVariant"
                                        :sticky-header="stickyHeader"

                                        :items="team"
                                        :fields="fields">
                                    <template v-slot:cell(action)="row">
                                        <b-button size="sm" @click="viewSelectedTeamMateHours(row.item)" class="mr-2">
                                            Dashboard
                                        </b-button>
                                        <b-button size="sm" @click="removeFromTheTeam(row.item.id)" class="mr-2">
                                            Remove
                                        </b-button>
                                    </template>
                                </b-table>
                        </div>
                        <div class="card-footer">
                            <b-button class="btn btn-danger" size="sm" @click="teamDashboard">TEAM DASHBOARD</b-button>
                        </div>
                    </div>
                </b-col>
                <b-col cols="4">
                    <div class="card">
                        <div style="text-align: center" class="card-header">
                            All Users
                        </div>
                        <div class="card-body">
                            <b-table
                                    responsive
                                    :small="small"
                                    :bordered="bordered"
                                    :hover="hover"
                                    :no-border-collapse="noBorderCollapse"
                                    :head-variant="headVariant"
                                    :sticky-header="stickyHeader"

                                    :items="allUser"
                                    :fields="fieldsAll">
                                <template v-slot:cell(action)="row">
                                    <b-button v-if="teamId !== row.item.team" size="sm" @click="addToTheTeam(row.item.id)" class="mr-2">
                                        Add
                                    </b-button>
                                </template>
                            </b-table>
                        </div>
                        <div class="card-footer">
                        </div>
                    </div>
                </b-col>
            </b-row>
            <b-row v-if="isDashboard">
                <b-col cols="1">
                </b-col>
                <b-col style="margin-top: 20px" cols="10">
                    <div class="card">
                        <div style="text-align: center" class="card-header">
                            {{selectedTeamMate.username}} dashboard
                        </div>
                        <div class="card-body">
                            <dashboard v-bind:passworkingtimes="selectedWorkingtimes"></dashboard>
                        </div>
                        <div class="card-footer">
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
                team: this.$store.state.myTeamProfile,
                allUser: this.$store.state.myAllProfile,
                teamId: this.$store.state.myProfile.team,
                selectedTeamMate: {},
                selectedWorkingtimes: this.$store.state.myWorkingtimes,

                fields: [
                    {key:'username', label:'Name'},
                    {key:'role', label:'Status'},
                    {key:'email', label:'Email'},
                    'Action',
                ],

                fieldsAll: [
                    {key:'team', label:'Team'},
                    {key:'username', label:'Name'},
                    {key:'role', label:'Status'},
                    {key:'email', label:'Email'},
                    'Action',
                ],

                small: true,
                bordered: true,
                hover: true,
                noBorderCollapse: false,
                headVariant: "light",
                stickyHeader: true,

                isDashboard: false,

            }
        },
        methods: {
            removeFromTheTeam(id) {
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
            addToTheTeam(id) {
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
            viewSelectedTeamMateHours(teamMate) {
                if (teamMate === this.selectedTeamMate) {
                    this.selectedTeamMate = {}
                    this.isDashboard = false
                    return
                }
                this.isDashboard = true
                this.selectedTeamMate = teamMate
                const param = {userId: teamMate.id, teamId: this.teamId}
                this.$store.dispatch('selectedTeamMateHours', param)
                    .then(resp => {
                        this.selectedWorkingtimes = resp
                    })
                    .catch(err => console.log(err))
            },
            teamDashboard() {
                this.isDashboard = true
                this.$store.dispatch('teamDashboard', this.teamId)
                    .then(resp => {
                        this.selectedWorkingtimes = resp
                    })
                    .catch(err => console.log(err))
            }
        },
        components: {
            Dashboard,
        }
    }
</script>

<style scoped>

</style>
