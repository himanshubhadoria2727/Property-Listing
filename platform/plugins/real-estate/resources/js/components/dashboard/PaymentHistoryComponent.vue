<template>
    <slot v-bind="{ isLoading, isLoadingMore, data, getData }"></slot>
</template>

<script>
export default {
    data() {
        return {
            isLoading: true,
            isLoadingMore: false,
            data: [],
        }
    },

    mounted() {
        this.getData()
    },

    methods: {
        getData(url = null) {
            if (url) {
                this.isLoadingMore = true
            } else {
                this.isLoading = true
            }
            axios.get(url ? url : '/account/ajax/transactions').then((res) => {
                let oldData = []
                if (this.data.data) {
                    oldData = this.data.data
                }
                this.data = res.data
                this.data.data = oldData.concat(this.data.data)
                this.isLoading = false
                this.isLoadingMore = false
            })
        },
    },
}
</script>
