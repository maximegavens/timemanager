<template xmlns:v-slot="http://www.w3.org/1999/XSL/Transform">
    <div>
        <div style="margin-top: 50px">
            <b-row align-h="around">
                <b-col cols="10">
                    <div class="card">
                        <div class="card-header">
                            General Management
                        </div>
                        <div class="card-body">
                            <b-table label-cols-lg="2" striped hover :items="profiles" :fields="fields"></b-table>
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
    export default {
        name: "General",
        data() {
            return {
                fields: ['username', 'role', 'team'],
                profiles: this.$store.state.myAllProfile,
            }
        },
        created() {
            console.log(this.profiles)
        }
    }
</script>

<style scoped>

</style>
