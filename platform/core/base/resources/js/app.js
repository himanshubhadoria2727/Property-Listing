import { axios, HttpClient } from './utilities'

window._ = require('lodash')

window.axios = axios

window.$httpClient = new HttpClient()

import Echo from 'laravel-echo'

window.Pusher = require('pusher-js');

window.Echo = new Echo({
    broadcaster: 'pusher',
    key: "70b927373bd3f040ba8d",
    cluster: "ap2",
    encrypted: true
});



$.ajaxSetup({
    headers: {
        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content'),
    },
})

window.Vue = require('vue');
Vue.use(require('vue-chat-scroll'))

Vue.component('chat-component', require('./components/ChatComponent.vue'));

const app = new Vue({
    el: '#app'
});


$(() => {
    setTimeout(() => {
        if (typeof siteAuthorizedUrl === 'undefined' || typeof isAuthenticated === 'undefined' || !isAuthenticated) {
            return
        }

        const $reminder = $('[data-bb-toggle="authorized-reminder"]')

        if ($reminder.length) {
            return
        }

        $httpClient
            .makeWithoutErrorHandler()
            .get(siteAuthorizedUrl, { verified: true })
            .then(() => null)
            .catch((error) => {
                if (!error.response || error.response.status !== 200) {
                    return
                }

                $(error.response.data.data.html).prependTo('body')
                $(document).find('.alert-license').slideDown()
            })
    }, 1000)
})
