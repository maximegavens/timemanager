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
                        <li>
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
                                    submit
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
                <line-chart
                        id="lineTest"
                        :data="lineDataTest"
                        xkey="date"
                        ykeys='[ "sum" ]'
                        resize="true"
                        labels='[ "Serie test" ]'
                        line-colors='[ "#FF0084" ]'
                        grid="true"
                        grid-text-weight="bold">
                </line-chart>
                <b-table striped hover :items="workingtimes" :fields="fields"></b-table>
            </div>
        </div>



        <!--<donut-chart
                id="donut"
                :data="donutData"
                colors='[ "#FF6384", "#36A2EB", "#FFCE56" ]'
                resize="true">
        </donut-chart>-->
        <!--<line-chart
                id="line"
                :data="lineData"
                xkey="year"
                ykeys='[ "a", "b" ]'
                resize="true"
                labels='[ "Serie A", "Serie B" ]'
                line-colors='[ "#FF0084", "#36A2EB" ]'
                grid="true"
                grid-text-weight="bold">
        </line-chart>-->

        <!--<bar-chart
                id="bar"
                :data="barData"
                xkey="year"
                ykeys='[ "and", "ios", "win" ]'
                resize="true"
                labels='[ "Android", "iOS", "Windows" ]'
                bar-colorssss='[ "#FF6384", "#36A2EB", "#FFCE56" ]'
                :bar-colors="osColors"
                grid="true"
                grid-text-weight="bold">
        </bar-chart>
        <area-chart
                id="area"
                :data="areaData"
                xkey="year"
                ykeys='[ "a", "b" ]'
                resize="true"
                labels='[ "Serie A", "Serie B" ]'
                line-colors='[ "#FF6384", "#36A2EB" ]'
                grid="true"
                grid-text-weight="bold"
                hide-hover="always">
        </area-chart>-->
    </div>
</template>

<script>
    /* eslint-disable */
    // eslint-disable-next-line
    import Raphael from 'raphael/raphael'
    global.Raphael = Raphael
    import { DonutChart, BarChart, LineChart, AreaChart } from 'vue-morris'
    import moment from 'moment'
    import vuejsDatepicker from 'vuejs-datepicker';
    export default {
        name: "Dashboard",
        data() {
            return {
                error: [],
                selected: null,
                options: [
                    { value: 'D', text: 'Daily' },
                    { value: 'W', text: 'Weekly' },
                    { value: 'M', text: 'Monthly' },
                ],
                start: null,
                end: null,

                workingtimes: this.$store.state.myWorkingtimes,
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

                userId: this.$store.state.myProfile.username,

                donutData: [
                    { label: 'Red', value: 300 },
                    { label: 'Blue', value: 50 },
                    { label: 'Yellow', value: 100 }
                ],
                barData: [
                    { year: '2013', and: 10, ios: 5, win: 2 },
                    { year: '2014', and: 10, ios: 15, win: 3 },
                    { year: '2015', and: 20, ios: 25, win: 2 },
                    { year: '2016', and: 30, ios: 20, win: 1 },
                ],
                lineData: [
                    { year: '2013', a: 10, b: 5 },
                    { year: '2014', a: 40, b: 15 },
                    { year: '2015', a: 20, b: 25 },
                    { year: '2016', a: 30, b: 20 },
                ],
                areaData: [
                    { year: '2013', a: 30, b: 5 },
                    { year: '2014', a: 25, b: 15 },
                    { year: '2015', a: 29, b: 25 },
                    { year: '2016', a: 50, b: 20 },
                ],
                lineDataTest: []
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
                let period = 1
                if (this.selected != null) {
                    if (this.selected == "D") {
                        period = 1
                    }
                    else if (this.selected == "W") {
                        period = 7
                    }
                    else if (this.selected == "M") {
                        period = 30
                    }
                }
                this.lineDataTest = []
                let dateStart = new Date(this.start)
                console.log(dateStart)
                let dateEnd = new Date(this.end)
                if (dateStart != null && dateEnd != null) {
                    if (dateStart >= dateEnd) {
                        alert("start must be befor end")
                        return
                    }
                    let sum = 0
                    let n = dateStart
                    while (n <= dateEnd) {
                        sum = 0
                        for(let i = 0; i < this.workingtimes.length; i++){
                            sum = sum + this.calculWorkingtimeForGivenDate(n, period, new Date(this.workingtimes[i].start), new Date(this.workingtimes[i].end))
                        }
                        this.lineDataTest.push({date: n.getTime(), sum: (sum / 1000) / 3600})
                        n = this.addDays(n, period)
                    }
                    console.log(this.lineDataTest)
                }
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
