<template>
  <div v-if="isLoggedIn" class="page">
    <!-- 左侧导航栏 (老年用户端) -->
    <el-aside width="220px" class="side">
      <!-- 系统名称 -->
      <div class="sTitle">Smart Home Elderly Care System</div>

      <div class="menuWrap">
        <el-menu
          default-active="/health-knowledge/list"
          class="el-menu-1"
          :router="true"
        >
          <el-menu-item index="/home">
            <el-icon><Platform /></el-icon>
            <span>Dashboard</span>
          </el-menu-item>
          <el-menu-item index="/health-data">
            <el-icon><Monitor /></el-icon>
            <span>Health Data</span>
          </el-menu-item>

          <el-menu-item index="/health-knowledge/list">
            <el-icon><DocumentCopy /></el-icon>
            <span>Health Knowledge</span>
          </el-menu-item>

          <el-menu-item index="/user-management">
            <el-icon><Setting /></el-icon>
            <span>Elderly Users Overview</span>
          </el-menu-item>
        </el-menu>
      </div>

      <!-- 用户信息 (底部) -->
      <div class="uInfo">
        <el-avatar :size="40" :src="userInfo.avatar"></el-avatar>
        <span>{{ userInfo.username }}</span>
      </div>
    </el-aside>

    <!-- 主内容区 (老年用户端) -->
    <div class="main">
      <!-- 页面标题 -->
      <div class="pHeader">
        <div class="hTitle">
          <h1>Health Knowledge Details</h1>
          <span class="sub-title">View complete health information</span>
        </div>
      </div>

      <!-- 健康知识详情 -->
      <el-card class="health-knowledge-card">
        <div v-if="loading">
          <el-skeleton :rows="10" animated />
        </div>
        <el-card v-else-if="error" class="error-message">
          Failed to load health knowledge details, please try again later.
        </el-card>
        <div v-else>
          <h2>{{ knowledge.title }}</h2>
          <hr class="gray-hr" />
          <div class="knowledge-info">
            <span>Label:</span
            ><el-tag size="small">{{ knowledge.category }}</el-tag>
            <span class="author">Author:{{ knowledge.author }}</span>
            <span class="publish-time"
              >Release time:{{ knowledge.formattedTime }}</span
            >
          </div>
          <div v-html="formattedContent"></div>
        </div>
      </el-card>
    </div>
  </div>
  <div v-else>
    <h1>Please log in first</h1>
    <!-- 可以添加一个跳转到登录页面的链接 -->
    <el-button type="primary" @click="goToLogin">Go login</el-button>
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import { useStore } from "vuex"; // 引入 useStore
import {
  Platform,
  DocumentCopy,
  Setting,
  Monitor, // 健康监测 Icon
  // Add other necessary icons
} from "@element-plus/icons-vue";
import { ElMessage } from "element-plus";

const router = useRouter();
const route = useRoute();
const store = useStore(); // 使用 useStore

// 获取 isLoggedIn 的值
const isLoggedIn = computed(() => store.getters.isLoggedIn);

// 获取用户信息
const userInfo = computed(() => store.getters.userInfo);

const goToLogin = () => {
  router.push("/");
};

// 替换为你的 API 地址
const knowledgeApiUrl = ref(
  "http://localhost:3060/api/homecare/health-knowledge"
);

const knowledge = ref(null);
const loading = ref(true);
const error = ref(false);
const formattedContent = ref(""); // 添加 formattedContent ref

const fetchKnowledgeDetail = async (health_knowledge_id) => {
  loading.value = true;
  error.value = false;
  try {
    const token = localStorage.getItem("token");
    const response = await fetch(
      `${knowledgeApiUrl.value}/${health_knowledge_id}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );

    // 检查响应状态码
    if (!response.ok) {
      console.error(
        "API response error: ",
        response.status,
        response.statusText
      );
      throw new Error(`API request failed, status code: ${response.status}`);
    }

    const data = await response.json();
    if (data.success) {
      knowledge.value = {
        ...data.data,
        formattedTime:
          new Date(data.data.publish_time).toLocaleDateString() +
          " " +
          new Date(data.data.publish_time).toLocaleTimeString(),
      };
      // 格式化文章内容
      formattedContent.value = knowledge.value.content.replace(/\n/g, "<br>");
    } else {
      console.error("API returned error: ", data.message);
      ElMessage.error(
        data.message || "Failed to obtain health knowledge details"
      );
      error.value = true;
    }
  } catch (err) {
    console.error("API request error: ", err);
    ElMessage.error("Network error, please try again later");
    error.value = true;
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  const healthKnowledgeId = route.params.health_knowledge_id;
  if (healthKnowledgeId) {
    fetchKnowledgeDetail(healthKnowledgeId);
  } else {
    ElMessage.error("Lack of Health Knowledge ID");
    error.value = true;
    loading.value = false;
  }
});
</script>

<style scoped>
/* --- Keep previous styles for .app-container, .sidebar, .el-menu, .main-content, .page-header, .el-card, .card-header, .summary-kpi-card, .kpi-item, .kpi-icon, .kpi-text, .kpi-value, .kpi-label, .quick-access-card, .quick-access-buttons --- */
.page {
  display: flex;
  min-height: 100vh;
  background-color: #f0f2f5;
}

.side {
  width: 220px; /* 确保设置了宽度 */
  background-color: #001529;
  border-right: none;
  transition: width 0.28s;
  overflow-x: hidden;
  display: flex;
  flex-direction: column;
  position: fixed; /* 添加此属性 */
  height: 100vh; /* 添加此属性 */
  z-index: 10; /* 确保在其他内容之上 */
}

/* 系统名称样式 */
.sTitle {
  color: #fff;
  padding: 20px;
  font-size: 18px;
  font-weight: bold;
  text-align: center;
}

/* 菜单容器，设置固定高度并隐藏溢出 */
.menuWrap {
  height: calc(100vh - 180px); /* 100vh 减去底部用户信息和系统名称的高度 */
  overflow: auto; /* 修改为 auto，允许菜单内容滚动 */
}

/* Override ElMenu default styles for dark theme */
.el-menu {
  border-right: none;
  background-color: #001529;
  /* Match sidebar */
  flex: 1; /* 占据剩余空间 */
}

.el-menu-item,
.el-sub-menu__title {
  color: rgba(255, 255, 255, 0.65);
  /* Light text color */
}

.el-menu-item:hover,
.el-sub-menu__title:hover {
  background-color: #000c17;
  /* Darker hover */
  color: #fff;
}

.el-menu-item.is-active {
  background-color: #1890ff;
  /* Active color */
  color: #fff;
}

.el-sub-menu.is-active .el-sub-menu__title {
  /* Keep parent active color */
  color: #fff;
}

/* Submenu background */
.el-menu--inline {
  background-color: #000c17 !important;
}

.el-menu--inline .el-menu-item {
  background-color: #000c17 !important;
  color: rgba(255, 255, 255, 0.65);
}

.el-menu--inline .el-menu-item:hover {
  background-color: #001529 !important;
  /* Slightly lighter hover */
  color: #fff;
}

.el-menu--inline .el-menu-item.is-active {
  background-color: #1890ff !important;
  /* Active color */
  color: #fff;
}

.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 220px;
  min-height: 100%;
}

.el-menu-item .el-icon,
.el-sub-menu__title .el-icon {
  vertical-align: middle;
  margin-right: 10px;
  /* Increased spacing */
  width: 24px;
  text-align: center;
  font-size: 18px;
}

.el-sub-menu .el-menu-item {
  min-width: 220px;
  /* Ensure submenu items fill width */
  padding-left: 48px !important;
  /* Indent submenu items */
}

.main {
  flex: 1;
  padding: 24px;
  overflow-y: auto;
  margin-left: 220px; /* 添加此属性，与侧边栏宽度相同 */
}

.pHeader {
  margin-bottom: 24px;
}

.hTitle h1 {
  margin: 0;
  font-size: 22px;
  /* Slightly smaller for admin */
  color: #303133;
  font-weight: 600;
}

.sub-title {
  color: #606266;
  font-size: 14px;
  margin-top: 4px;
}

.el-card {
  margin-bottom: 24px;
  border-radius: 4px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  /* Bold header */
  color: #303133;
  font-size: 16px;
}

.card-header .el-link {
  font-size: 14px;
  font-weight: normal;
}

/* User Info Bottom Styles */
.uInfo {
  display: flex;
  align-items: center;
  padding: 20px;
  color: #fff;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.uInfo span {
  margin-left: 10px;
  font-size: 16px;
}

/* 自定义样式 */
.card-footer {
  font-size: 12px;
  color: #606266;
  margin-top: 10px;
}

.error-message {
  color: #f56c6c;
  text-align: center;
  padding: 15px;
  border: 1px solid #f56c6c;
  border-radius: 4px;
  margin-bottom: 15px;
}

/* 新增样式 */
.knowledge-info {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.knowledge-info .el-tag {
  margin-right: 10px;
}

.knowledge-info .author {
  margin-left: 10px;
  margin-right: 10px;
  color: #606266;
  font-size: 12px;
}

.knowledge-info .publish-time {
  color: #606266;
  font-size: 12px;
}

/* 灰色横线 */
.gray-hr {
  border: 0;
  height: 1px;
  background: #ccc; /* 设置为灰色 */
  margin: 10px 0; /* 可选：调整上下边距 */
}
</style>
