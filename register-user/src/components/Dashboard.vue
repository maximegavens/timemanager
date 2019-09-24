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
                                            <b-button @click="graphicFormat = 'line'">Line</b-button>
                                            <b-button @click="graphicFormat = 'bar'">Bar</b-button>
                                            <b-button @click="graphicFormat = 'area'">Area</b-button>
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
                <line-chart
                        v-if="graphicFormat === 'line'"
                        id="lineTest"
                        :data="lineDataTest"
                        xkey="date"
                        ykeys='[ "sum" ]'
                        resize="true"
                        labels='[ "working hours" ]'
                        line-colors='[ "#0000FF" ]'
                        grid="true"
                        grid-text-weight="bold"
                        smooth="false">
                </line-chart>
                <bar-chart
                        v-if="graphicFormat === 'bar'"
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
                        v-if="graphicFormat === 'area'"
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
                </area-chart>
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
    import Raphael from 'raphael/raphael'
    global.Raphael = Raphael
    import { DonutChart, BarChart, LineChart, AreaChart } from 'vue-morris'
    import moment from 'moment'
    import vuejsDatepicker from 'vuejs-datepicker';
    export default {
        name: "Dashboard",
        props: ['passWorkingtimes'],
        data() {
            return {
                graphicFormat: "line",
                error: [],
                selected: null,
                options: [
                    { value: 'D', text: 'Daily' },
                    { value: 'W', text: 'Weekly' },
                    { value: 'M', text: 'Monthly' },
                ],
                start: null,
                end: null,

                workingtimes: this.passWorkingtimes,
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
                lineDataTest: []
            }
        },
        created() {
            if (this.workingtimes == null) {
                this.workingtimes = this.$store.state.myWorkingtimes
            }
            this.end = this.dateToDatePickerFormat(new Date())
            this.start = this.dateToDatePickerFormat(new Date(new Date() - 7 * 24 * 3600 * 1000))
            this.selected = "D"
            this.updateData()
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
