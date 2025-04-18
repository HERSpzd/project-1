<template>
  <div v-if="isLoggedIn" class="page">
    <!-- Sidebar -->
    <el-aside width="220px" class="side">
      <!-- 系统名称 -->
      <div class="sTitle">Smart Home Elderly Care System</div>

      <div class="menuWrap">
        <el-menu
          default-active="/health-monitoring"
          class="el-menu-1"
          :router="true"
        >
          <el-menu-item index="/home">
            <el-icon><Platform /></el-icon>
            <span>Dashboard</span>
          </el-menu-item>
          <el-menu-item index="/health-monitoring">
            <el-icon><Monitor /></el-icon>
            <span>Health monitoring</span>
          </el-menu-item>
          <el-menu-item index="/health-knowledge">
            <el-icon><DocumentCopy /></el-icon>
            <span>Health Knowledge</span>
          </el-menu-item>
          <el-menu-item index="/user-settings">
            <el-icon><Setting /></el-icon>
            <span>User Settings</span>
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
          <h1>Health monitoring</h1>
          <span class="sub-title"
            >Take photos and upload them to quickly obtain health data</span
          >
        </div>
      </div>

      <!-- 健康数据采集 -->
      <el-card class="dCard">
        <div class="camWrap">
          <video ref="video" width="320" height="240" autoplay></video>
          <canvas
            ref="canvas"
            width="320"
            height="240"
            style="display: none"
          ></canvas>
          <div class="button-group">
            <el-button type="primary" @click="takePicture('blood_pressure')"
              >Upload blood pressure monitor</el-button
            >
            <el-button type="primary" @click="takePicture('blood_sugar')"
              >Upload blood glucose meter</el-button
            >
          </div>
        </div>

        <div v-if="uploading" class="uping">
          <el-progress :percentage="uploadProgress"></el-progress>
          <p>Uploading and identifying data, please wait</p>
        </div>

        <div v-if="bloodPressureData || bloodSugarData" class="dShow">
          <h2 v-if="bloodPressureData">Blood pressure data</h2>
          <el-descriptions v-if="bloodPressureData" :column="1" border>
            <el-descriptions-item label="Systolic pressure"
              >{{ bloodPressureData.systolic }} mmHg</el-descriptions-item
            >
            <el-descriptions-item label="Diastolic pressure"
              >{{ bloodPressureData.diastolic }} mmHg</el-descriptions-item
            >
            <el-descriptions-item label="Pulse"
              >{{ bloodPressureData.pulse }} bpm</el-descriptions-item
            >
          </el-descriptions>

          <h2 v-if="bloodSugarData">Blood glucose data</h2>
          <el-descriptions v-if="bloodSugarData" :column="1" border>
            <el-descriptions-item label="Blood sugar"
              >{{ bloodSugarData.bloodSugar }} mg/dL</el-descriptions-item
            >
            <el-descriptions-item label="Time">{{
              bloodSugarData.time
            }}</el-descriptions-item>
          </el-descriptions>
        </div>

        <div v-else-if="uploadSuccess && !uploading" class="noData">
          <p>No valid data was identified, please take a new photo.</p>
        </div>
      </el-card>

      <!-- 历史数据展示 -->
      <el-card class="hCard">
        <div class="card-header">
          <span>Blood pressure historical data</span>
        </div>
        <el-table :data="bloodPressureHistoryData" style="width: 100%">
          <el-table-column prop="formattedTime" label="Time" width="180" />
          <el-table-column prop="systolic" label="Systolic pressure" />
          <el-table-column prop="diastolic" label="Diastolic pressure" />
          <el-table-column prop="pulse" label="Pulse" />
        </el-table>
      </el-card>

      <el-card class="hCard">
        <div class="card-header">
          <span>Historical blood glucose data</span>
        </div>
        <el-table :data="bloodSugarHistoryData" style="width: 100%">
          <el-table-column prop="formattedTime" label="Time" width="180" />
          <el-table-column prop="bloodSugar" label="Blood sugar" />
        </el-table>
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
import { useRouter } from "vue-router";
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
const store = useStore(); // 使用 useStore

// 获取 isLoggedIn 的值
const isLoggedIn = computed(() => store.getters.isLoggedIn);

// 获取用户信息
const userInfo = computed(() => store.getters.userInfo);

const goToLogin = () => {
  router.push("/");
};

// 替换为你的 API 地址
const uploadBloodPressureUrl = ref(
  "http://localhost:3060/api/homecare/upload-image"
); // 上传血压仪
const uploadBloodSugarUrl = ref(
  "http://localhost:3060/api/homecare/upload-image-2"
); // 上传血糖仪
const historyDataUrl = ref("http://localhost:3060/api/homecare/history-data"); // 获取历史数据

const bloodPressureData = ref(null);
const bloodSugarData = ref(null);
const uploadSuccess = ref(false);
const uploading = ref(false);
const uploadProgress = ref(0);
const bloodPressureHistoryData = ref([]);
const bloodSugarHistoryData = ref([]);

const video = ref(null);
const canvas = ref(null);

const handleUploadSuccess = (response, type) => {
  uploading.value = false;
  uploadProgress.value = 0;

  if (response.success) {
    uploadSuccess.value = true;
    if (type === "blood_pressure") {
      bloodPressureData.value = response.data.value;
      bloodSugarData.value = null; // 清空血糖数据
    } else if (type === "blood_sugar") {
      bloodSugarData.value = response.data.value;
      bloodPressureData.value = null; // 清空血压数据
    } else {
      ElMessage.error("Unable to recognize data type");
      bloodPressureData.value = null;
      bloodSugarData.value = null;
      uploadSuccess.value = false;
    }
  } else {
    ElMessage.error(response.message || "Upload failed");
    bloodPressureData.value = null;
    bloodSugarData.value = null;
    uploadSuccess.value = false;
  }
};

const takePicture = (type) => {
  const context = canvas.value.getContext("2d");
  context.drawImage(video.value, 0, 0, 320, 240);
  const imageDataURL = canvas.value.toDataURL("image/png"); // 获取 base64 编码的图像数据

  uploadImage(imageDataURL, type);
};

const uploadImage = async (imageDataURL, type) => {
  uploading.value = true;
  uploadSuccess.value = false;
  bloodPressureData.value = null;
  bloodSugarData.value = null;
  uploadProgress.value = 0;

  let url = "";
  if (type === "blood_pressure") {
    url = uploadBloodPressureUrl.value;
  } else if (type === "blood_sugar") {
    url = uploadBloodSugarUrl.value;
  } else {
    ElMessage.error("Invalid upload type");
    uploading.value = false;
    return;
  }

  try {
    const token = localStorage.getItem("token") || store.getters.token; // 从 localStorage 或 vuex 获取 token
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`, // 添加 JWT 令牌
      },
      body: JSON.stringify({ image: imageDataURL }),
    });

    const data = await response.json();
    handleUploadSuccess(data, type);
    await fetchHistoryData(); // 上传成功后刷新数据
  } catch (error) {
    uploading.value = false;
    ElMessage.error("Upload failed, please check the network");
  }
};

const fetchHistoryData = async () => {
  try {
    const token = localStorage.getItem("token") || store.getters.token; // 从 localStorage 或 vuex 获取 token
    const response = await fetch(historyDataUrl.value, {
      headers: {
        Authorization: `Bearer ${token}`, // 添加 JWT 令牌
      },
    });
    const data = await response.json();
    if (data.success) {
      // 分离血压数据和血糖数据
      bloodPressureHistoryData.value = data.data
        .filter((item) => item.type === "blood_pressure")
        .map((item) => ({
          time: item.time,
          systolic: item.value.systolic,
          diastolic: item.value.diastolic,
          pulse: item.value.pulse,
          formattedTime:
            new Date(item.time).toLocaleDateString() +
            " " +
            new Date(item.time).toLocaleTimeString(),
        }));
      bloodSugarHistoryData.value = data.data
        .filter((item) => item.type === "blood_sugar")
        .map((item) => ({
          time: item.time,
          bloodSugar: item.value.bloodSugar,
          formattedTime:
            new Date(item.time).toLocaleDateString() +
            " " +
            new Date(item.time).toLocaleTimeString(),
        }));
    } else {
      ElMessage.error(data.message || "Failed to retrieve historical data");
    }
  } catch (error) {
    ElMessage.error(
      "Failed to retrieve historical data, please check the network"
    );
  }
};

onMounted(() => {
  navigator.mediaDevices
    .getUserMedia({ video: true })
    .then((stream) => {
      video.value.srcObject = stream;
    })
    .catch((error) => {
      console.error("Unable to access camera", error);
      ElMessage.error("Unable to access camera, please check permissions");
    });

  fetchHistoryData(); // 仅在页面加载时获取一次
});
</script>

<style scoped>
/* --- Keep previous styles for .app-container, .sidebar, .el-menu, .main-content, .page-header, .el-card, .card-header, .summary-row, .summary-kpi-card, .kpi-item, .kpi-icon, .kpi-text, .kpi-value, .kpi-label, .quick-access-card, .quick-access-buttons --- */
.page {
  display: flex;
  min-height: 100vh;
  background-color: #f0f2f5;
}

.side {
  background-color: #001529;
  border-right: none;
  transition: width 0.28s;
  overflow: hidden; /* 隐藏水平滚动条 */
  display: flex;
  flex-direction: column;
  height: 100vh; /* 占据整个视口高度 */
  position: relative; /* 确保 user-info-bottom 可以相对于它定位 */
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
  overflow-y: auto;
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
  height: calc(100vh - 48px); /* 减去 padding 的高度 */
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

/* KPI Card Styles */
.kpiRow {
  margin-bottom: 0;
  /* Remove bottom margin if cards have enough */
}

.kpiCard .el-card__body {
  padding: 15px 20px;
  /* Adjust padding */
}

.kItem {
  display: flex;
  align-items: center;
}

.kIcon {
  font-size: 36px;
  /* Larger icons */
  padding: 10px;
  margin-right: 15px;
  border-radius: 4px;
  color: #fff;
}

.icon-user {
  background-color: #409eff;
}

.icon-device {
  background-color: #67c23a;
}

.icon-alert {
  background-color: #f56c6c;
}

.icon-task {
  background-color: #e6a23c;
}

.kText {
  display: flex;
  flex-direction: column;
}

.kVal {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  line-height: 1.2;
}

.kLabel {
  font-size: 14px;
  color: #606266;
}

.kpiCard.kpi-critical .kVal {
  color: #f56c6c;
  /* Highlight critical value */
}

/* Quick Access & System Notifications */
.qaBtns .el-button {
  margin-right: 10px;
  margin-bottom: 10px;
}

.qaBtns .el-icon {
  margin-right: 4px;
}

/* Renamed class */
.system-notifications-card .el-card__body {
  padding-top: 10px;
  padding-bottom: 10px;
  max-height: 250px;
  /* Limit height and make scrollable if needed */
  overflow-y: auto;
}

/* Renamed class */
.notification-timeline {
  padding-left: 5px;
  /* Adjust timeline padding */
}

.el-timeline-item__timestamp {
  font-size: 12px;
  /* Smaller timestamp */
}

/* Style for timeline item icon if used */
.el-timeline-item__icon {
  font-size: 16px;
  /* Adjust icon size in timeline */
}

/* User Info Bottom Styles */
.uInfo {
  display: flex;
  align-items: center;
  padding: 20px;
  color: #fff;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  position: absolute; /* 绝对定位 */
  bottom: 0; /* 位于底部 */
  left: 0; /* 靠左 */
  width: 100%; /* 占据全部宽度 */
}

.uInfo span {
  margin-left: 10px;
  font-size: 16px;
}

/* Health Data Styles */
.dCard {
  margin-bottom: 24px;
  border-radius: 4px;
}

.camWrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.camWrap video {
  margin-bottom: 10px;
}

.button-group {
  display: flex;
  justify-content: center;
  gap: 10px; /* 添加按钮之间的间距 */
  margin-top: 10px; /* 增加与视频的间距 */
}

.uping {
  padding: 20px;
  text-align: center;
}

.dShow {
  padding: 20px;
}

.noData {
  padding: 20px;
  text-align: center;
  color: #999;
}

/* History Data Styles */
.hCard {
  margin-bottom: 24px;
  border-radius: 4px;
}
</style>
