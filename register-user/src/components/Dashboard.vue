<template>
    <div>
        <button type="button" @click="getWorkingTimes">Actualise workingtime</button>
        <div>{{workingTimes}}</div>
    </div>
</template>

<script>
    /* eslint-disable */
    // eslint-disable-next-line
    export default {
        name: "Dashboard",
        data() {
            return {
                userId: this.$store.state.user.id,
                workingTimes: this.$store.workingtimes,
            }
        },
        methods: {
            getWorkingTimes () {
                this.userId = this.$store.state.token
                this.$store.dispatch('getWorkingtimes', this.userId)
                    .then(resp => {console.log(resp); this.workingTimes = resp;})
                    .catch(err => console.log(err))
            },
        }
    }
</script>

<style scoped>

</style>
