<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
    <div>
        <div style="margin-top: 50px">
            <b-row align-h="around">
                <b-col cols="10">
                    <div class="card">
                        <div style="text-align: center" class="card-header">
                            General List
                        </div>
                        <div class="card-body">
                            <b-table
                                    responsive
                                    :small="small"
                                    :bordered="bordered"
                                    :hover="hover"
                                    :no-border-collapse="noBorderCollapse"
                                    :head-variant="headVariant"

                                    :items="profiles"
                                    :fields="fields"
                                    :sticky-header="stickyHeader"

                                    selectable
                                    selected-variant="active"
                                    :select-mode="selectMode"
                                    @row-selected="onRowSelected">
                            </b-table>
                        </div>
                    </div>
                </b-col>
                <b-col cols="10">
                    <b-row>
                        <b-col v-for="item in selected" :key="item.id" style="margin-top: 20px" cols="4">
                            <div class="card">
                                <div class="card-header">
                                    {{item.username}}
                                </div>
                                <div class="card-body">
                                    <b-row>
                                        <b-col cols="3">
                                            ID:
                                        </b-col>
                                        <b-col cols="9">
                                            {{item.id}}
                                        </b-col>
                                    </b-row>
                                    <b-row>
                                        <b-col cols="3">
                                            Email:
                                        </b-col>
                                        <b-col cols="9">
                                            {{item.email}}
                                        </b-col>
                                    </b-row>
                                    <b-row>
                                        <b-col cols="3">
                                            Status:
                                        </b-col>
                                        <b-col cols="9">
                                            {{item.role}}
                                        </b-col>
                                    </b-row>
                                </div>
                                <div class="card-footer text-light">
                                    <b-row>
                                        <b-col cols="4">
                                            <b-button @click="promoteEmployee(item.id)" class="btn-block" size="sm" variant="outline-secondary">promote</b-button>
                                        </b-col>
                                        <b-col cols="4">
                                            <b-button @click="viewDashboard(item)" class="btn-block" size="sm" variant="outline-secondary">dashboard</b-button>
                                        </b-col>
                                        <b-col cols="4">
                                            <b-button @click="deleteAccount(item.id)" class="btn-block" size="sm" variant="outline-danger">delete account</b-button>
                                        </b-col>
                                    </b-row>
                                </div>
                            </div>
                        </b-col>
                    </b-row>
                </b-col>
                <b-col v-if="isDashboard" style="margin-top: 20px" cols="10">
                    <div class="card">
                        <div class="card-header">
                            {{selectedUsername}}
                        </div>
                        <div class="card-body">
                            <dashboard v-bind:passworkingtimes="selectedDashboard"></dashboard>
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
    import Dashboard from './Dashboard'
    export default {
        name: "General",
        data() {
            return {
                profiles: this.$store.state.myAllProfile,
                allDashboard: this.sortWorkingtimesByUserId(this.$store.state.myAllWorkingtimes),
                selectedDashboard: [],
                selectedUsername: '',
                fields: [
                    {key:'username', label:'Name'},
                    {key:'role', label:'Status'},
                    {key:'team', label:'Team'}
                    ],
                small: true,
                bordered: true,
                hover: true,
                noBorderCollapse: false,
                headVariant: "light",
                stickyHeader: true,

                selected: [],
                selectMode: 'multi',

                actualId: null,
                actualWorkingtimes: [],
                isDashboard: false,
            }
        },
        created() {
        },
        methods: {
            onRowSelected(items) {
                this.selected = items
                if (this.selected.length === 0) {
                    this.isDashboard = false
                    this.selectedDashboard = []
                }
            },
            deleteAccount(userId) {
                this.$store.dispatch('deleteAccount', userId)
                    .then(() => {
                        this.$store.dispatch('allProfile')
                            .then(() => this.profiles = this.$store.state.myAllProfile)
                            .catch(err => console.log(err))
                    })
                    .catch(err => console.log(err))
            },
            promoteEmployee(userId) {
                this.$store.dispatch('promote', userId)
                    .then(() => {
                        this.$store.dispatch('allProfile')
                            .then(() => this.profiles = this.$store.state.myAllProfile)
                            .catch(err => console.log(err))
                    })
                    .catch(err => console.log(err))
            },
            viewDashboard(item) {
                const userId = item.id
                this.selectedUsername = item.username
                if (this.actualId === userId) {
                    this.actualId = -1
                    this.isDashboard = false
                    this.selectedDashboard = []
                } else {
                    this.actualId = item.id
                    this.isDashboard = true
                    for(let obj in this.allDashboard) {
                        if (obj.toString() === userId.toString()) {
                            this.selectedDashboard = this.allDashboard[obj]
                            return
                        }
                    }
                }
            },
            sortWorkingtimesByUserId(workingtimes) {
                let sortWorkingtimes = this.getObjectListUserIdFromWorkingtimes(workingtimes)
                for(let i = 0; i < workingtimes.length; i++) {
                    sortWorkingtimes[workingtimes[i].user_id].push(workingtimes[i])
                }
                return sortWorkingtimes
            },
            getObjectListUserIdFromWorkingtimes(workingtimes) {
                let obj = {}
                for(let w in workingtimes) {
                    obj[workingtimes[w].user_id] = []
                }
                return obj
            },
        },
        components: {
            Dashboard,
        }
    }
</script>

<style scoped>

</style>
