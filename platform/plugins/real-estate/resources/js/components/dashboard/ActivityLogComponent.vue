<template>
    <slot v-bind="{ activityLogs, loading }"></slot>
</template>

<script>
export default {
    data() {
        return {
            loading: true,
            activityLogs: [],
        }
    },

    mounted() {
        this.getActivityLogs()
    },

    methods: {
        getActivityLogs(url = null) {
            this.loading = true

            axios.get(url ? url : '/account/ajax/activity-logs').then((res) => {
                let oldData = []

                if (this.activityLogs.data) {
                    oldData = this.activityLogs.data
                }

                this.activityLogs = res.data
                this.activityLogs.data = oldData.concat(this.activityLogs.data)
                this.loading = false
            })
        },
    },
}
</script>
