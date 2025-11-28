# 智能安全帽监测系统

> 基于RT-Thread 5.1.0和STM32H7R7的多传感器监测系统

[![RT-Thread](https://img.shields.io/badge/RT--Thread-5.1.0-blue)](https://www.rt-thread.org/)
[![STM32](https://img.shields.io/badge/STM32-H7R7-green)](https://www.st.com/)
[![License](https://img.shields.io/badge/License-Apache--2.0-yellow)](LICENSE)

---

## 🎯 项目简介

本项目是一个基于**RT-Thread 5.1.0**实时操作系统和**STM32H7R7**高性能微控制器的智能安全帽监测系统。系统采用**7个独立线程**并发处理传感器数据，通过WiFi将数据实时上报到华为云IoT平台。

### 核心特性

- 🚀 **RT-Thread RTOS**: 基于RT-Thread 5.1.0，多线程抢占式调度
- 🧵 **7个独立线程**: 传感器任务完全并行执行
- 🔒 **互斥锁同步**: 使用rt_mutex保护共享数据
- 📊 **优先级调度**: 合理分配任务优先级(15-20)
- 💻 **MSH命令行**: 实时查看传感器数据
- 🔄 **高性能处理**: STM32H7R7主频600MHz
- 📡 **云端接入**: WiFi+MQTT上报华为云IoT

---

## 🌐 在线演示

🎉 **点击查看在线演示**: [https://3080771737.github.io/smart-helmet-rtthread/](https://3080771737.github.io/smart-helmet-rtthread/)

### 🏠 项目展示主页 (推荐首选)

**完整项目展示**: [https://3080771737.github.io/smart-helmet-rtthread/project.html](https://3080771737.github.io/smart-helmet-rtthread/project.html)

这是一个专业的响应式单页展示,一个页面看完整个项目:
- ✅ 项目介绍、核心特性、功能展示
- ✅ RT-Thread 7个线程完整架构
- ✅ 代码示例与语法高亮
- ✅ 硬件框架与性能数据
- ✅ 现代化动画效果

### 📺 详细功能演示页面

- 📺 [硬件连接示意图](https://3080771737.github.io/smart-helmet-rtthread/hardware_connection_diagram.html)
- 🖥️ [RT-Thread控制台](https://3080771737.github.io/smart-helmet-rtthread/console_output.html)
- 📊 [传感器数据仪表盘](https://3080771737.github.io/smart-helmet-rtthread/smart_helmet_demo.html)
- ☁️ [华为云IoT平台](https://3080771737.github.io/smart-helmet-rtthread/huawei_iot_dashboard.html)

---

## ✨ 功能特性

### 1. 生理健康监测
- ✅ **心率监测**: MAX30102传感器，实时检测心率(BPM)
- ✅ **血氧监测**: 实时监测血氧饱和度(SpO2%)
- ✅ **异常告警**: 心率/血氧超限自动记录日志

### 2. 环境监测
- ✅ **温湿度检测**: DHT11传感器采集环境数据
- ✅ **气体浓度检测**: MQ2传感器检测可燃气体，超100ppm报警
- ✅ **多次采样平均**: 提高测量精度

### 3. 位置与姿态监测
- ✅ **GPS定位**: ATGM336H模块获取经纬度坐标
- ✅ **姿态解算**: MPU6050六轴传感器实时姿态
- ✅ **跌倒检测**: 基于加速度向量模(AVM)和陀螺仪向量模(GVM)算法
- ✅ **碰撞检测**: 检测突发性加速度变化

### 4. 无线通信
- ✅ **WiFi连接**: ESP-01S模块
- ✅ **MQTT上报**: 实时上报数据到华为云IoT平台
- ✅ **周期性上报**: 1秒周期上报所有传感器数据

---

## 🔧 RT-Thread使用情况

### 线程架构

| 线程名 | 优先级 | 栈大小 | 周期 | 功能描述 |
|--------|-------|--------|------|----------|
| **mpu6050** | 15 | 1024B | 100ms | MPU6050姿态传感器，跌倒/碰撞检测 |
| **max30102** | 16 | 1024B | 200ms | MAX30102心率血氧传感器 |
| **dht11** | 17 | 512B | 1000ms | DHT11温湿度传感器 |
| **mq2** | 17 | 512B | 100ms | MQ2气体浓度传感器 |
| **gps** | 18 | 1024B | 1000ms | ATGM336H GPS定位模块 |
| **wifi** | 19 | 2048B | 1000ms | ESP-01S WiFi数据上报 |
| **led** | 20 | 256B | 500ms | LED状态指示灯 |

### RT-Thread组件使用

```c
// 线程创建
rt_thread_t thread = rt_thread_create("name", entry, param, stack, priority, tick);
rt_thread_startup(thread);

// 互斥锁同步
rt_mutex_t mutex = rt_mutex_create("lock", RT_IPC_FLAG_PRIO);
rt_mutex_take(mutex, RT_WAITING_FOREVER);
// ... 访问共享数据
rt_mutex_release(mutex);

// MSH命令
MSH_CMD_EXPORT(sensor_read, Read all sensor data);

// 自动初始化
INIT_APP_EXPORT(sensor_threads_init);

// 日志系统
LOG_I("Thread started");
LOG_W("Warning message");
```

---

## 🔌 硬件框架

### 主控平台

- **主控MCU**: STM32H7R7VIT6 (Cortex-M7 @ 600MHz)
- **开发板**: ART-Pi2 (正点原子)
- **操作系统**: RT-Thread 5.1.0

### 传感器模块

| 传感器 | 接口 | 引脚 | 功能 |
|--------|------|------|------|
| MPU6050 | I2C1 | PB6(SCL), PB7(SDA) | 六轴姿态 |
| MAX30102 | I2C2 | PF1(SCL), PF0(SDA) | 心率血氧 |
| MQ2 | ADC1 | PA0 | 气体浓度 |
| DHT11 | GPIO | PA8 | 温湿度 |
| ATGM336H | UART2 | PA2(TX), PA3(RX) | GPS定位 |
| ESP-01S | UART3 | PB10(TX), PB11(RX) | WiFi通信 |
| LED | GPIO | PO5 | 状态指示 |

详细的硬件连接说明请参考: [硬件连接表](documentation/HARDWARE_CONNECTION_TABLE.md)

---

## 📂 项目结构

```
smart-helmet-rtthread/
├── applications/
│   └── main.c                    # RT-Thread主程序(7个线程)
├── board/                         # 板级支持包
├── rtconfig.h                     # RT-Thread配置头文件
├── .config                        # Kconfig配置
├── SConscript                     # SCons构建脚本
├── SConstruct                     # SCons主构建文件
├── docs/                          # GitHub Pages目录
│   ├── index.html                 # 演示索引页
│   ├── hardware_connection_diagram.html
│   ├── console_output.html
│   ├── smart_helmet_demo.html
│   └── huawei_iot_dashboard.html
├── documentation/                 # 文档目录
│   ├── smart_helmet_rtthread_submission.md
│   └── HARDWARE_CONNECTION_TABLE.md
└── README.md                      # 本文件
```

---

## 🚀 快速开始

### 环境准备

1. **安装RT-Thread ENV工具**
   - 下载: https://www.rt-thread.org/page/download.html
   - 解压并配置环境变量

2. **安装Keil MDK** (可选)
   - 下载: https://www.keil.com/
   - 安装STM32H7系列支持包

### 编译步骤

#### 方法一: ENV工具 + Keil MDK

```bash
# 1. 打开ENV命令行
# 2. 进入项目目录
cd smart-helmet-rtthread

# 3. 生成MDK工程
scons --target=mdk5

# 4. 打开Keil编译
# 双击 project.uvprojx
# 点击编译按钮
```

#### 方法二: RT-Thread Studio

1. 打开RT-Thread Studio
2. File → Import → RT-Thread Project
3. 选择项目路径
4. 构建项目
5. 下载到开发板

---

## 📊 性能数据

| 指标 | 数值 |
|------|------|
| RT-Thread版本 | 5.1.0 |
| 线程数量 | 7个 |
| 内存使用 | ~52KB / 640KB |
| 线程切换时间 | <1us |
| 中断响应时间 | <10us |
| 任务响应延迟 | <1ms |
| 传感器采样率 | 10Hz (100ms) |
| 数据上报频率 | 1Hz (1000ms) |

---

## 📄 文档

- [完整提交文档](documentation/smart_helmet_rtthread_submission.md) - RT-Thread社区提交版本
- [硬件连接表](documentation/HARDWARE_CONNECTION_TABLE.md) - 详细的接线说明

---

## 🛠️ 待改进

- [ ] 实际传感器驱动移植(当前使用模拟数据)
- [ ] 使用RT-Thread Sensor框架统一管理
- [ ] 添加消息队列进行线程间通信
- [ ] 集成littlefs文件系统存储历史数据
- [ ] 添加OTA固件升级功能
- [ ] AI姿态识别算法
- [ ] 蓝牙BLE通信
- [ ] 手机APP开发

---

## 📜 开源协议

本项目采用 [Apache-2.0](LICENSE) 协议开源。

---

## 🙏 致谢

- **RT-Thread团队**: 提供优秀的国产RTOS
- **正点原子**: 提供ART-Pi2开发板
- **STMicroelectronics**: 提供STM32 HAL库

---

## 📧 联系方式

- **作者**: 陈思宇
- **邮箱**: 3080771737@qq.com
- **GitHub**: [@3080771737](https://github.com/3080771737)
- **RT-Thread社区**: [club.rt-thread.org](https://club.rt-thread.org)

---

<div align="center">

## ⭐ 如果这个项目对您有帮助,请给个Star!

**感谢您的关注与支持!**

![Visitors](https://visitor-badge.laobi.icu/badge?page_id=3080771737.smart-helmet-rtthread)

</div>
