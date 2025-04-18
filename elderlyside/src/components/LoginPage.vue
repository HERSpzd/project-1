<template>
  <div
    style="
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background-color: #f0f2f5;
    "
  >
    <el-card class="login-card">
      <template #header>
        <div style="text-align: left">
          <h2 style="margin: 0">Welcome</h2>
          <p style="color: #999">Smart Home Elderly Care System</p>
        </div>
      </template>

      <div class="login-content">
        <!-- 图片 -->
        <div class="image-container">
          <img src="../assets/login.png" alt="Logo" class="logo-image" />
        </div>

        <!-- 登录表单 -->
        <el-form
          v-if="currentForm === 'login'"
          label-position="top"
          label-width="0"
          class="login-form"
          @submit.prevent="login"
        >
          <el-form-item label="Account Number">
            <el-input
              v-model="form.username"
              placeholder="Please enter your account"
            >
              <template #append>
                <el-icon><User /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="Password">
            <el-input
              v-model="form.password"
              type="password"
              placeholder="Please input a password"
              show-password
            >
              <template #append>
                <el-icon><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item>
            <el-button
              type="primary"
              style="width: 100%"
              @click="login"
              :loading="loading"
            >
              {{ loading ? "Logging in" : "Log on" }}
            </el-button>
          </el-form-item>

          <div
            style="
              display: flex;
              justify-content: space-between;
              font-size: 12px;
            "
          >
            <el-link
              type="primary"
              :underline="false"
              @click="currentForm = 'register'"
              >Free registration</el-link
            >
            <el-link
              type="primary"
              :underline="false"
              @click="currentForm = 'forgotPassword'"
              >Forgot password</el-link
            >
          </div>
        </el-form>

        <!-- 注册表单 -->
        <RegisterForm
          v-if="currentForm === 'register'"
          class="login-form"
          @back-to-login="currentForm = 'login'"
        />
        <!-- 监听事件 -->

        <!-- 忘记密码表单 -->
        <ForgotPasswordForm
          v-if="currentForm === 'forgotPassword'"
          class="login-form"
          @back-to-login="currentForm = 'login'"
        />
        <!-- 监听事件 -->
      </div>
    </el-card>
  </div>
</template>

<script>
import { defineComponent, reactive, ref } from "vue";
import { User, Lock } from "@element-plus/icons-vue";
import RegisterForm from "./RegisterForm.vue"; // 导入注册组件
import ForgotPasswordForm from "./ForgotPasswordForm.vue"; // 导入忘记密码组件
import { useRouter } from "vue-router"; // 导入 useRouter
import { useStore } from "vuex"; // 导入 useStore
import axios from "axios"; // 导入 axios
import { ElMessage } from "element-plus"; // 导入 ElMessage

export default defineComponent({
  components: {
    User,
    Lock,
    RegisterForm, // 注册组件
    ForgotPasswordForm, // 注册组件
  },
  setup() {
    const form = reactive({
      username: "", // 修改为 username
      password: "",
    });

    const currentForm = ref("login"); // 'login', 'register', 'forgotPassword'
    const router = useRouter(); // 获取 router 实例
    const store = useStore(); // 获取 store 实例
    const loading = ref(false); // 添加 loading 状态

    const login = async () => {
      loading.value = true; // 设置 loading 状态为 true
      try {
        // 调用后端 API 进行登录验证
        const response = await axios.post(
          "http://localhost:3060/api/homecare/login",
          {
            // 修改为你的后端 API 地址
            username: form.username,
            password: form.password,
          }
        );

        // 假设后端返回的数据如下：
        const { token, user } = response.data;

        // 检查用户角色是否为管理员
        if (user.role !== "elderly") {
          ElMessage.error("Only elderly users can log in"); // 显示错误信息
          return;
        }

        // 将用户信息和 Token 存储到 Vuex store 中
        store.dispatch("login", { userInfo: user, token: token });

        // 跳转到 Home 页面
        router.push("/home");
        ElMessage.success("Login succeeded"); // 显示登录成功消息
      } catch (error) {
        // 处理登录失败的情况
        console.error("Login failed:", error);
        let errorMessage = "Login failed, please try again later";
        if (
          error.response &&
          error.response.data &&
          error.response.data.message
        ) {
          errorMessage = error.response.data.message; // 获取后端返回的错误信息
        }
        ElMessage.error(errorMessage); // 显示错误信息
      } finally {
        loading.value = false; // 设置 loading 状态为 false
      }
    };

    return {
      form,
      currentForm,
      login, // 导出 login 方法
      loading, // 导出 loading 状态
    };
  },
});
</script>

<style scoped>
.login-card {
  border-radius: 10px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  width: 900px;
  /* 调整卡片宽度 */
}

.login-content {
  display: flex;
  align-items: center;
  /* 垂直居中 */
}

.image-container {
  width: 50%;
  /* 调整图片容器宽度 */
  padding-right: 20px;
  /* 可选：添加右侧间距 */
}

.logo-image {
  width: 100%;
  /* 让图片宽度撑满容器 */
  display: block;
}

.login-form {
  width: 50%;
  /* 调整表单容器宽度 */
}
</style>
