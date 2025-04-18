import { createApp } from 'vue'
import App from './App.vue'
import ElementPlus from 'element-plus';
import 'element-plus/dist/index.css'
import router from './router';
import store from './store'
import './assets/global.css'

const app = createApp(App)

app.use(ElementPlus)
app.use(router);
app.mount('#app')
app.use(store)