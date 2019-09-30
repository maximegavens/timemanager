<template>
    <div style="text-align: center">
        <b-row align-h="center">
            <b-col cols="12">
                <div style="background: linear-gradient(0.25turn, #3f87a6, #ebf8e1, #f69d3c);">
                    <b-form>
                        <b-row>
                            <b-col cols="1">
                            </b-col>
                            <b-col cols="2">
                                <b-form-radio-group
                                        id="btn-radios-1"
                                        v-model="selected"
                                        :options="options"
                                        buttons
                                        button-variant="outline-light"
                                        name="radios-btn-default">
                                </b-form-radio-group>
                            </b-col>
                            <b-col cols="1">
                                <b-badge variant="ligth">FROM</b-badge>
                            </b-col>
                            <b-col cols="2">
                                <b-form-input
                                        id="start"
                                        class="mb-2 mr-sm-2 mb-sm-0"
                                        v-model="start"
                                        type="date">
                                </b-form-input>
                            </b-col>
                            <b-col cols="1">
                                <b-badge variant="ligth">TO</b-badge>
                            </b-col>
                            <b-col cols="2">
                                <b-form-input
                                        id="e,d"
                                        class="mb-2 mr-sm-2 mb-sm-0"
                                        v-model="end"
                                        type="date">
                                </b-form-input>
                            </b-col>
                            <b-col cols="1">
                                <b-button @click="updateData" variant="ligth">Update</b-button>
                            </b-col>
                        </b-row>
                    </b-form>
                </div>
            </b-col>
        </b-row>
        <b-row style="margin-top: 20px">
            <b-col cols="1">
            </b-col>
            <b-col cols="6">
                <h5><b>Working Times graphic</b></h5>
                <bar-chart
                        id="barTest"
                        :data="data"
                        :bar-colors="colors"
                        xkey="date"
                        :ykeys="ykeys"
                        :labels="labels"
                        grid="true"
                        resize="true"
                        gridTextSize="8"
                        grid-text-weight="bold">
                </bar-chart>
            </b-col>
            <b-col cols="1">
            </b-col>
            <b-col cols="3">
                <h5><b>Start/End List</b></h5>
                <b-table
                        style="margin-top: 20px"
                        responsive
                        striped hover
                        sticky-header
                        :items="originalList"
                        :fields="fields">
                </b-table>
            </b-col>
        </b-row>
        <b-row align-h="center" style="margin-top: 20px">
            <b-col style="text-align: center" cols="3">
                <h5><b>Total hours worked</b></h5>
                <donut-chart
                    id="total"
                    :data="totalWorkingHoursData"
                    :colors="totalWorkingHoursColors"
                    resize="true">
                </donut-chart>
            </b-col>
            <b-col style="text-align: center" cols="3">
                <h5 v-if="selected === 'D'"><b>Average hours worked per day</b></h5>
                <h5 v-if="selected === 'W'"><b>Average hours worked per week</b></h5>
                <h5 v-if="selected === 'M'"><b>Average hours worked per month</b></h5>
                <donut-chart
                        id="dayAverage"
                        :data="averageWorkingHoursPerDayData"
                        :colors="averageWorkingHoursPerDaysColors"
                        resize="true">
                </donut-chart>
            </b-col>
            <b-col style="text-align: center" cols="3">
                <h5 v-if="isStart" @click="isStart = !isStart; updateOriginalList()"><b>Average of arrival hours worked</b></h5>
                <h5 v-else @click="isStart = !isStart; updateOriginalList()"><b>Average of departure hours worked</b></h5>
                <donut-chart
                        id="startEndAverage"
                        :data="averageStartEndHoursData"
                        :colors="averageStartEndHoursColors"
                        resize="true">
                </donut-chart>
            </b-col>
        </b-row>
    </div>
</template>

<script>
    /* eslint-disable */
    // eslint-disable-next-line
    import { DonutChart, BarChart, LineChart, AreaChart } from 'vue-morris'
    import vuejsDatepicker from 'vuejs-datepicker';
    import Raphael from 'raphael/raphael'
    global.Raphael = Raphael
    export default {
        name: "Dashboard",
        props: {
            passworkingtimes: Array,
        },
        data() {
            return {
                myProfile: this.$store.state.myProfile,
                myTeamProfile: this.$store.state.myTeamProfile,
                workingtimes: this.$store.state.myWorkingtimes,
                start: this.dateToDatePickerFormat(new Date(new Date() - 7 * 24 * 3600 * 1000)),
                end: this.dateToDatePickerFormat(new Date()),
                originalList: [],
                selected: "D",
                options: [ { value: 'D', text: 'Daily' }, { value: 'W', text: 'Weekly' }, { value: 'M', text: 'Monthly' } ],
                fields: [ {key: "Name", sortable: true}, { key: "Start", sortable: true }, { key: "End", sortable: true } ],
                data: [],
                ykeys: [],
                labels: [],
                colors: [],


                totalWorkingHoursOnPeriod: 0,
                averageWorkingHoursPerDay: 0,
                averageWorkingHoursPerWeek: 0,

                totalHours: 0,

                totalWorkingHoursColors: ["#3f87a6"],
                totalWorkingHoursData: [],

                averageWorkingHoursPerDaysColors: ["#ebf8e1"],
                averageWorkingHoursPerDayData: [],

                isStart: true,
                averageStartEndHoursColors: ["#f69d3c"],
                averageStartEndHoursData: [],
            }
        },
        created() {
            if(this.workingtimes.length === 0) {
                this.initDefaultValue()
            } else {
                this.updateData()
            }
        },
        watch: {
            passworkingtimes: function(newVal) {
                this.workingtimes = newVal
                this.updateData()
            }
        },
        methods: {
            initDefaultValue() {
                const period = this.selected === "D" ? 1 : (this.selected === "W" ? 7 : 30)
                const dateStart = new Date(this.start)
                const dateEnd = new Date(this.end)

                this.totalWorkingHoursData.push({label: "total on period", value: "0"})
                this.averageWorkingHoursPerDayData.push({label: "average per day", value: "0"})
                this.averageStartEndHoursData.push({label: "average start/end", value: "0"})

                this.labels = ["none"]
                this.ykeys = ["none"]
                this.colors = ["#000000"]

                if (dateStart != null && dateEnd != null) {
                    if (dateStart >= dateEnd) {
                        alert("start must be before end")
                        return
                    }
                    let n = dateStart
                    while (n <= dateEnd) {
                        this.data.push({date: this.customDateFormat(n), none: 0})
                        n = this.addDays(n, period)
                    }
                }
            },
            updateDonut() {
                const e = new Date(this.end)
                const s = new Date(this.start)
                this.totalHours = (((e - s) / 1000) / 3600)
                const period = this.data.length
                let totalHours = {}
                let averageHours = {}

                for(let i = 0; i < period; i++) {
                    for(let key in this.data[i]) {
                        if(key !== "Average" && key !== "date") {
                            if(key in totalHours) {
                                totalHours[key] = totalHours[key] + this.data[i][key]
                            } else {
                                totalHours[key] = this.data[i][key]
                            }
                        }
                    }
                }
                for(let item in totalHours) {
                    averageHours[item] = totalHours[item] / period
                }
                this.totalWorkingHoursData = []
                this.totalWorkingHoursColors = ["#3f87a6"]
                for(let item in totalHours) {
                    this.totalWorkingHoursData.push({label: item , value: (Math.round(totalHours[item] * 100) / 100).toString()})
                    this.totalWorkingHoursColors.push(this.getRandomColor())
                }
                this.averageWorkingHoursPerDayData = []
                this.averageWorkingHoursPerDaysColors = ["#ebf8e1"]
                for(let item in averageHours) {
                    this.averageWorkingHoursPerDayData.push({label: item + " (" + this.hoursToStringFormat(Math.round(averageHours[item] * 100) / 100) + ")", value: (Math.round(averageHours[item] * 100) / 100).toString()})
                    this.averageWorkingHoursPerDaysColors.push(this.getRandomColor())
                }
            },
            updateOriginalList() {
                let a = null
                let b = null
                let name = null
                let sumStart = {}
                let sumEnd = {}
                let days = {}
                const start = new Date(this.start)
                let end = new Date(this.end)
                end = this.addDays(end, 1)
                let newList = []
                let newLine = {}
                for(let i = 0; i < this.workingtimes.length; i++) {
                    newLine = {}
                    a = new Date(this.workingtimes[i].start)
                    b = new Date(this.workingtimes[i].end)
                    console.log(a)
                    console.log(b)
                    name = this.getUsername(this.workingtimes[i].user_id)
                    if ((a > start && a < end) || (b > end && b < end)) {
                        newLine["Name"] = name
                        newLine["Start"] = a.toTimeString().split(' ')[0] + " " + a.toLocaleDateString()
                        newLine["End"] = b.toTimeString().split(' ')[0] + " " + b.toLocaleDateString()
                        newList.push(newLine)

                        days[name] = name in days ? days[name] + 1 : 1
                        sumStart[name] = name in sumStart ? sumStart[name] + a.getHours() * 3600 + a.getMinutes() * 60 + a.getSeconds() : a.getHours() * 3600 + a.getMinutes() * 60 + a.getSeconds()
                        sumEnd[name] = name in sumEnd ? sumEnd[name] + b.getHours() * 3600 + b.getMinutes() * 60 + b.getSeconds() : b.getHours() * 3600 + b.getMinutes() * 60 + b.getSeconds()
                    }
                }
                this.originalList = newList

                this.averageStartEndHoursData = []
                this.averageStartEndHoursColors = ["#f69d3c"]
                if (this.isStart) {
                    for(let name in sumStart) {
                        this.averageStartEndHoursData.push({label: name + " (" + this.secondToStringFormat(sumStart[name] / days[name]) + ")", value: (Math.round(((sumStart[name] / days[name]) / 3600) * 100) / 100).toString()})
                        this.averageStartEndHoursColors.push(this.getRandomColor())
                    }
                } else {
                    for(let name in sumEnd) {
                        this.averageStartEndHoursData.push({label: name + " (" + this.secondToStringFormat(sumEnd[name] / days[name]) + ")", value: (Math.round(((sumEnd[name] / days[name]) / 3600) * 100) / 100).toString()})
                        this.averageStartEndHoursColors.push(this.getRandomColor())
                    }
                }
            },
            secondToStringFormat(sec_num) {
                let hours   = Math.floor(sec_num / 3600);
                let minutes = Math.floor((sec_num - (hours * 3600)) / 60);
                let seconds = sec_num - (hours * 3600) - (minutes * 60);

                if (hours   < 10) {hours   = "0"+hours;}
                if (minutes < 10) {minutes = "0"+minutes;}
                if (seconds < 10) {seconds = "0"+seconds;}
                return hours+':'+minutes+':'+seconds;
            },
            hoursToStringFormat(hour_num) {
                let hours   = Math.floor(hour_num);
                let minutes = Math.floor((hour_num - hours) * 60);
                let seconds = Math.floor((hour_num - hours - (minutes / 60)) * 3600);

                if (hours   < 10) {hours   = "0"+hours;}
                if (minutes < 10) {minutes = "0"+minutes;}
                if (seconds < 10) {seconds = "0"+seconds;}
                return hours+':'+minutes+':'+seconds;
            },
            dateToDatePickerFormat(a) {
                const y = a.getFullYear().toString()
                const m = a.getMonth() + 1 < 10 ? "0" + (a.getMonth() + 1).toString() : (a.getMonth() + 1).toString()
                const d = a.getDate() < 10 ? "0" + a.getDate().toString() : a.getDate().toString()
                return y + "-" + m + "-" + d
            },
            customDateFormat(a) {
                const y = a.getFullYear().toString()
                const m = a.getMonth() + 1 < 10 ? "0" + (a.getMonth() + 1).toString() : (a.getMonth() + 1).toString()
                const d = a.getDate() < 10 ? "0" + a.getDate().toString() : a.getDate().toString()
                return d + "/" + m + "/" + y
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
                        newLine["date"] = this.customDateFormat(n)
                        index = 0
                        for(let item in sortWorkingtimes) {
                            sum = 0
                            for(let i = 0; i < sortWorkingtimes[item].length; i++){
                                sum = sum + this.calculWorkingtimeForGivenDate(n, period, new Date(sortWorkingtimes[item][i].start), new Date(sortWorkingtimes[item][i].end))
                            }
                            newLine[this.labels[index]] = Math.floor(sum / 36000) / 100
                            index = index + 1
                        }
                        newLine["Average"] = this.averageWorkingtimes(newLine)
                        this.data.push(newLine)
                        n = this.addDays(n, period)
                    }
                } else {
                    alert("choose start and end")
                }
                this.updateDonut()
                this.updateOriginalList()
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
                this.ykeys = []
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
                labels.push("Average")
                keys.push("Average")
                colors.push("#DEDEDE")
                this.labels = labels
                this.ykeys = keys
                this.colors = colors
            },
            getUsername(userId) {
                if (this.myTeamProfile.length === 0) {
                    return this.myProfile.username
                } else {
                    for(let profile in this.myTeamProfile) {
                        if (this.myTeamProfile[profile].id.toString() === userId.toString()) {
                            return this.myTeamProfile[profile].username
                        }
                    }
                }
            },
            averageWorkingtimes(newLine) {
                let sum = 0
                let n = 0
                for(let item in newLine) {
                    if (!(item === "date")) {
                        sum = sum + newLine[item]
                        n = n + 1
                    }
                }
                return Math.floor(sum * 100 / n) / 100
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
