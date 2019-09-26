<template>
    <div>
        <div class="row container-fluid" style="margin-top: 50px">
            <nav class="col-md-2 sidebar">
                <div class="sidebar-sticky">
                    <h5 class="sidebar-heading"><i>Parameters</i></h5>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <b-row>
                                <b-col sm="3">
                                    <label>frequency</label>
                                </b-col>
                                <b-col sm="9">
                                    <b-form-select v-model="selected" :options="options"></b-form-select>
                                </b-col>
                            </b-row>
                        </li>
                        <li class="nav-item">
                            <b-row>
                                <b-col sm="3">
                                    <label>start</label>
                                </b-col>
                                <b-col sm="9">
                                    <b-form-input v-model="start" type="date"></b-form-input>
                                </b-col>
                            </b-row>
                        </li>
                        <li class="nav-item">
                            <b-row>
                                <b-col sm="3">
                                    <label>end</label>
                                </b-col>
                                <b-col sm="9">
                                    <b-form-input v-model="end" type="date"></b-form-input>
                                </b-col>
                            </b-row>
                        </li>
                        <li class="nav-item">
                            <b-row>
                                <b-col sm="3">
                                </b-col>
                                <b-col sm="9">
                                    <div>
                                        <b-button-group>
                                            <b-button @click="graphicData.format = 'line'">Line</b-button>
                                            <b-button @click="graphicData.format = 'bar'">Bar</b-button>
                                            <b-button @click="graphicData.format = 'area'">Area</b-button>
                                        </b-button-group>
                                    </div>
                                </b-col>
                            </b-row>
                        </li>
                        <li class="nav-item">
                            <b-row>
                                <b-col sm="3">
                                </b-col>
                                <b-col sm="9">
                                    <b-button @click="updateData">submit</b-button>
                                </b-col>
                            </b-row>
                        </li>
                    </ul>
                </div>
            </nav>
            <div class="col-md-10" role="main">
                <bar-chart
                        id="barTest"
                        :data="data"
                        :bar-colors="xkeyss"
                        :xkey="xkeyss"
                        :ykeys="ykeyss"
                        grid="true"
                        resize="true"
                        grid-text-weight="bold">
                </bar-chart>
                <bar-chart
                        id="bar"
                        :data="barData"
                        :bar-colors="arrayColors"
                        :xkeys="xkeys"
                        :ykeys="ykeys"
                        grid="true"
                        resize="true"
                        grid-text-weight="bold">
                </bar-chart>
                <!--<bar-chart
                        v-if="graphicData.format === 'bar'"
                        id="bar"
                        :data="lineDataTest"
                        xkey="date"
                        ykeys='[ "sum" ]'
                        resize="true"
                        labels='[ "working hours" ]'
                        bar-colors='[ "#FF6384" ]'
                        grid="true"
                        grid-text-weight="bold"
                        dateFormat>
                </bar-chart>
                <area-chart
                        v-if="graphicData.format === 'area'"
                        id="area"
                        :data="lineDataTest"
                        xkey="date"
                        ykeys='[ "sum" ]'
                        resize="true"
                        labels='[ "working hours" ]'
                        line-colors='[ "#FF6384" ]'
                        grid="true"
                        grid-text-weight="bold"
                        hide-hover="always">
                </area-chart>-->
                <b-table style="margin-top: 20px" striped hover :items="workingtimes" :fields="fields"></b-table>
            </div>
        </div>
        <!--<donut-chart
                id="donut"
                :data="donutData"
                colors='[ "#FF6384", "#36A2EB", "#FFCE56" ]'
                resize="true">
        </donut-chart>-->
    </div>
</template>

<script>
    /* eslint-disable */
    // eslint-disable-next-line
    //import Raphael from 'raphael/raphael'
    //global.Raphael = Raphael
    import { DonutChart, BarChart, LineChart, AreaChart } from 'vue-morris'
    import vuejsDatepicker from 'vuejs-datepicker';
    export default {
        name: "Dashboard",
        props: {
            passworkingtimes: Array,
        },
        data() {
            return {
                arrayColorss:[ "#5859f9", "#73c000" ],
                error: [],
                myProfile: this.$store.state.myProfile,
                myTeamProfile: this.$store.state.myTeamProfile,
                workingtimes: this.$store.state.myWorkingtimes,
                start: this.dateToDatePickerFormat(new Date(new Date() - 7 * 24 * 3600 * 1000)),
                end: this.dateToDatePickerFormat(new Date()),
                selected: "D",
                options: [
                    { value: 'D', text: 'Daily' },
                    { value: 'W', text: 'Weekly' },
                    { value: 'M', text: 'Monthly' },
                ],
                fields: [
                    {
                        key: "start",
                        sortable: true
                    },
                    {
                        key: "end",
                        sortable: true
                    }
                ],
                keys: ["luc", "jack"],
                barColors:[ "#5859f9", "#73c000"],

                format: "line",
                data: [],
                xkeyss: ["date"],
                ykeyss: [],
                labels: [],
                colors: [],


                barData: [
                    { year: '2012', car: 40 , motorcycle:300, airplane:60},
                    { year: '2013', car: 150, motorcycle:280, airplane:70},
                    { year: '2014', car: 100, motorcycle:150, airplane:30},
                    { year: '2015', car: 100, motorcycle:390, airplane:90}
                ],
                xkeys:["year"],

                arrayColors:[ "#5859f9", "#73c000", "#cc45ff" ],
                ykeys:["car","motorcycle","airplane"]
            }
        },
        created() {
            this.updateData()
            console.log(this.data)
            console.log(this.ykeyss)
            console.log(this.labels)
            console.log(this.colors)
        },
        watch: {
            passworkingtimes: function(newVal) {
                this.workingtimes = newVal
                this.updateData()
                console.log(this.data)
                console.log(this.ykeyss)
                console.log(this.labels)
                console.log(this.colors)
            }
        },
        methods: {
            getCurrentDate(isoDate) {
                const a = new Date(isoDate)
                const y = a.getFullYear().toString()
                const m = a.getMonth() + 1 < 10 ? "0" + (a.getMonth() + 1).toString() : (a.getMonth() + 1).toString()
                const d = a.getDate() < 10 ? "0" + a.getDate().toString() : a.getDate().toString()
                const c = new Date(y + "-" + m + "-" + d)
                return c
            },
            dateToDatePickerFormat(a) {
                const y = a.getFullYear().toString()
                const m = a.getMonth() + 1 < 10 ? "0" + (a.getMonth() + 1).toString() : (a.getMonth() + 1).toString()
                const d = a.getDate() < 10 ? "0" + a.getDate().toString() : a.getDate().toString()
                return y + "-" + m + "-" + d
            },
            calculWorkingtimeForGivenDate(givenDate, period, start, end) {
                const GDprevious = this.addDays(givenDate, period)

                if (start >= GDprevious || givenDate >= end) {
                    return 0
                }
                if (start <= givenDate && end >= GDprevious) {
                    return 24 * 60 * 60 * 1000
                }
                if (start <= givenDate && end < GDprevious) {
                    return (end - givenDate) + 3600 * 1000
                }
                if (start > givenDate && end >= GDprevious) {
                    return (GDprevious - start) - 3600 * 1000
                }
                if (start > givenDate && end < GDprevious) {
                    return end - start
                }
                return 0
            },
            addDays(date, days) {
                let newDate = new Date(date.valueOf())
                newDate.setDate(newDate.getDate() + days)
                return newDate
            },
            updateData() {
                const sortWorkingtimes = this.sortWorkingtimesByUserId(this.workingtimes)
                const period = this.selected === "D" ? 1 : (this.selected === "W" ? 7 : 30)
                const dateStart = new Date(this.start)
                const dateEnd = new Date(this.end)

                console.log(sortWorkingtimes)

                //let period = 1
                //if (this.selected == "D") {
                //    period = 1
                //}
                //else if (this.selected == "W") {
                //    period = 7
                //}
                //else if (this.selected == "M") {
                //    period = 30
                //}
                this.initGraphicData(sortWorkingtimes)

                if (dateStart != null && dateEnd != null) {
                    if (dateStart >= dateEnd) {
                        alert("start must be before end")
                        return
                    }
                    let index = 0
                    let sum = 0
                    let newLine = null
                    let n = dateStart
                    while (n <= dateEnd) {
                        newLine = {}
                        newLine["date"] = n.getTime()
                        index = 0
                        for(let item in sortWorkingtimes) {
                            sum = 0
                            for(let i = 0; i < sortWorkingtimes[item].length; i++){
                                sum = sum + this.calculWorkingtimeForGivenDate(n, period, new Date(sortWorkingtimes[item][i].start), new Date(sortWorkingtimes[item][i].end))
                            }
                            newLine[this.labels[index]] = (sum / 1000) / 3600
                            index = index + 1
                        }
                        this.data.push(newLine)
                        n = this.addDays(n, period)
                    }
                } else {
                    alert("choose start and end")
                }
            },
            completeSums() {
                let sums = {}
                for(let i = 0; i < this.workingtimes.length; i++){
                    sums[this.workingtimes[i].user_id] = 0
                }
                for(let item in sums){

                }
                return sums
            },
            copyObject(obj) {
                let target = {}
                for(let prop in obj){
                    target[prop] = obj[prop]
                }
                return target
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
            resetGraphicData() {
                this.data = []
                this.ykeyss = []
                this.labels = []
                this.colors = []
            },
            initGraphicData(sortWorkingtimes) {
                let username = ""
                let labels = []
                let keys = []
                let colors = []
                this.resetGraphicData()
                for(let item in sortWorkingtimes) {
                    username = this.getUsername(item)
                    labels.push(username)
                    keys.push(username)
                    colors.push(this.getRandomColor())
                }
                this.labels = labels
                this.ykeyss = keys
                this.colors = colors
            },
            getUsername(userId) {
                if (this.myTeamProfile.length === 0) {
                    return this.myProfile.username
                } else {
                    for(let profile in this.myTeamProfile) {
                        if (this.myTeamProfile[profile].id.toString() === userId) {
                            return this.myTeamProfile[profile].username
                        }
                    }
                }
            },
            getRandomColor() {
                let letters = '0123456789ABCDEF';
                let color = '#';
                for (let i = 0; i < 6; i++) {
                    color += letters[Math.floor(Math.random() * 16)];
                }
                return color;
            },
        },
        components: {
            DonutChart,
            BarChart,
            LineChart,
            AreaChart,
            vuejsDatepicker,
        }
    }
</script>

<style scoped>

</style>
