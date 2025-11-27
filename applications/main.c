/*
 * Copyright (c) 2006-2025, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2025-01-15     SmartHelmet  Smart Helmet Monitoring System
 */

#include <rtthread.h>
#include <rtdevice.h>
#include "drv_common.h"

#define DBG_TAG "main"
#define DBG_LVL DBG_LOG
#include <rtdbg.h>

/* LED引脚定义 */
#define LED_PIN GET_PIN(O, 5)

/* 线程栈大小定义 */
#define THREAD_STACK_SIZE   1024
#define THREAD_PRIORITY     15
#define THREAD_TIMESLICE    10

/* 传感器数据结构 */
struct sensor_data {
    /* MPU6050姿态数据 */
    float pitch;
    float roll;
    float yaw;
    rt_uint16_t avm;  // 加速度向量模
    rt_uint16_t gvm;  // 陀螺仪向量模
    rt_bool_t fall_flag;
    rt_bool_t collision_flag;

    /* MAX30102心率血氧 */
    rt_int32_t heart_rate;
    rt_int32_t spo2;
    rt_bool_t hr_valid;
    rt_bool_t spo2_valid;

    /* DHT11温湿度 */
    rt_uint8_t temperature;
    rt_uint8_t humidity;

    /* MQ2气体传感器 */
    float gas_ppm;
    rt_bool_t gas_alarm;

    /* GPS定位 */
    float longitude;
    float latitude;
    rt_bool_t gps_fixed;
};

/* 全局传感器数据 */
static struct sensor_data g_sensor_data = {0};

/* 线程句柄 */
static rt_thread_t mpu6050_thread = RT_NULL;
static rt_thread_t max30102_thread = RT_NULL;
static rt_thread_t dht11_thread = RT_NULL;
static rt_thread_t mq2_thread = RT_NULL;
static rt_thread_t gps_thread = RT_NULL;
static rt_thread_t wifi_thread = RT_NULL;

/* 互斥锁保护共享数据 */
static rt_mutex_t sensor_mutex = RT_NULL;

/**
 * @brief MPU6050姿态传感器线程
 */
static void mpu6050_thread_entry(void *parameter)
{
    LOG_I("MPU6050 thread started");

    /* TODO: 初始化MPU6050 */
    // MPU_Init();
    // mpu_dmp_init();

    while (1)
    {
        /* TODO: 读取MPU6050数据 */
        // mpu_dmp_get_data(&pitch, &roll, &yaw);
        // MPU_Get_Accelerometer(&ax, &ay, &az);
        // MPU_Get_Gyroscope(&gx, &gy, &gz);

        /* 模拟数据(实际应从传感器读取) */
        rt_mutex_take(sensor_mutex, RT_WAITING_FOREVER);
        g_sensor_data.pitch = 0.5f;
        g_sensor_data.roll = -1.2f;
        g_sensor_data.yaw = 45.8f;
        g_sensor_data.avm = 1024 + (rt_tick_get() % 100);
        g_sensor_data.gvm = 512 + (rt_tick_get() % 50);

        /* 跌倒检测算法 */
        if (g_sensor_data.avm > 30000 && g_sensor_data.gvm > 10000) {
            g_sensor_data.fall_flag = RT_TRUE;
            LOG_W("Fall detected! AVM=%d, GVM=%d", g_sensor_data.avm, g_sensor_data.gvm);
        } else {
            g_sensor_data.fall_flag = RT_FALSE;
        }

        /* 碰撞检测 */
        if (g_sensor_data.avm > 35000) {
            g_sensor_data.collision_flag = RT_TRUE;
            LOG_W("Collision detected!");
        }

        rt_mutex_release(sensor_mutex);

        rt_thread_mdelay(100);  // 100ms周期
    }
}

/**
 * @brief MAX30102心率血氧传感器线程
 */
static void max30102_thread_entry(void *parameter)
{
    LOG_I("MAX30102 thread started");

    /* TODO: 初始化MAX30102 */
    // MAX30102_Init();

    while (1)
    {
        /* TODO: 读取心率血氧数据 */
        // MAX30102_Read_Data();
        // Calculate_Heart_Rate_and_SpO2();

        /* 模拟数据 */
        rt_mutex_take(sensor_mutex, RT_WAITING_FOREVER);
        g_sensor_data.heart_rate = 72 + (rt_tick_get() % 10) - 5;
        g_sensor_data.spo2 = 97 + (rt_tick_get() % 3);
        g_sensor_data.hr_valid = RT_TRUE;
        g_sensor_data.spo2_valid = RT_TRUE;

        /* 异常检测 */
        if (g_sensor_data.heart_rate < 60 || g_sensor_data.heart_rate > 100) {
            LOG_W("Heart rate abnormal: %d bpm", g_sensor_data.heart_rate);
        }
        if (g_sensor_data.spo2 < 90) {
            LOG_W("SpO2 abnormal: %d%%", g_sensor_data.spo2);
        }

        rt_mutex_release(sensor_mutex);

        rt_thread_mdelay(200);  // 200ms周期
    }
}

/**
 * @brief DHT11温湿度传感器线程
 */
static void dht11_thread_entry(void *parameter)
{
    LOG_I("DHT11 thread started");

    /* TODO: 初始化DHT11 */
    // DHT11_Init();

    while (1)
    {
        /* TODO: 读取温湿度 */
        // DHT11_Read_Data(&temp, &humi);

        /* 模拟数据 */
        rt_mutex_take(sensor_mutex, RT_WAITING_FOREVER);
        g_sensor_data.temperature = 25 + (rt_tick_get() % 5);
        g_sensor_data.humidity = 55 + (rt_tick_get() % 10);
        rt_mutex_release(sensor_mutex);

        rt_thread_mdelay(1000);  // 1000ms周期
    }
}

/**
 * @brief MQ2气体传感器线程
 */
static void mq2_thread_entry(void *parameter)
{
    LOG_I("MQ2 thread started");

    /* TODO: 初始化MQ2(ADC) */

    while (1)
    {
        /* TODO: 读取气体浓度 */
        // mq2_task();

        /* 模拟数据 */
        rt_mutex_take(sensor_mutex, RT_WAITING_FOREVER);
        g_sensor_data.gas_ppm = 45.2f + (float)(rt_tick_get() % 20) - 10.0f;
        g_sensor_data.gas_alarm = (g_sensor_data.gas_ppm > 100.0f);

        if (g_sensor_data.gas_alarm) {
            LOG_W("Gas alarm! PPM=%.1f", g_sensor_data.gas_ppm);
        }

        rt_mutex_release(sensor_mutex);

        rt_thread_mdelay(100);  // 100ms周期
    }
}

/**
 * @brief GPS定位线程
 */
static void gps_thread_entry(void *parameter)
{
    LOG_I("GPS thread started");

    /* TODO: 初始化GPS */
    // atgm336h_init();

    while (1)
    {
        /* TODO: 解析GPS数据 */
        // atgm336h_task();

        /* 模拟数据 */
        rt_mutex_take(sensor_mutex, RT_WAITING_FOREVER);
        g_sensor_data.longitude = 114.3579f;
        g_sensor_data.latitude = 30.5447f;
        g_sensor_data.gps_fixed = RT_TRUE;
        rt_mutex_release(sensor_mutex);

        rt_thread_mdelay(1000);  // 1000ms周期
    }
}

/**
 * @brief WiFi数据上报线程
 */
static void wifi_thread_entry(void *parameter)
{
    LOG_I("WiFi thread started");

    /* TODO: 初始化ESP-01S和MQTT */
    // esp_init();

    rt_thread_mdelay(5000);  // 等待传感器初始化

    while (1)
    {
        /* 上报生理数据 */
        rt_mutex_take(sensor_mutex, RT_WAITING_FOREVER);
        LOG_D("Report: HR=%d, SpO2=%d, Gas=%.1f, Fall=%d",
              g_sensor_data.heart_rate,
              g_sensor_data.spo2,
              g_sensor_data.gas_ppm,
              g_sensor_data.fall_flag);

        /* TODO: MQTT发布消息 */
        // esp_report1();

        rt_mutex_release(sensor_mutex);

        rt_thread_mdelay(1000);  // 1000ms周期
    }
}

/**
 * @brief 状态LED闪烁线程
 */
static void led_thread_entry(void *parameter)
{
    rt_pin_mode(LED_PIN, PIN_MODE_OUTPUT);

    while (1)
    {
        rt_pin_write(LED_PIN, PIN_HIGH);
        rt_thread_mdelay(500);
        rt_pin_write(LED_PIN, PIN_LOW);
        rt_thread_mdelay(500);
    }
}

/**
 * @brief 创建所有传感器线程
 */
static int sensor_threads_init(void)
{
    /* 创建互斥锁 */
    sensor_mutex = rt_mutex_create("sen_lock", RT_IPC_FLAG_PRIO);
    if (sensor_mutex == RT_NULL) {
        LOG_E("Failed to create mutex!");
        return -RT_ERROR;
    }

    /* 创建MPU6050线程 */
    mpu6050_thread = rt_thread_create("mpu6050",
                                      mpu6050_thread_entry,
                                      RT_NULL,
                                      THREAD_STACK_SIZE,
                                      THREAD_PRIORITY,
                                      THREAD_TIMESLICE);
    if (mpu6050_thread != RT_NULL) {
        rt_thread_startup(mpu6050_thread);
    }

    /* 创建MAX30102线程 */
    max30102_thread = rt_thread_create("max30102",
                                       max30102_thread_entry,
                                       RT_NULL,
                                       THREAD_STACK_SIZE,
                                       THREAD_PRIORITY + 1,
                                       THREAD_TIMESLICE);
    if (max30102_thread != RT_NULL) {
        rt_thread_startup(max30102_thread);
    }

    /* 创建DHT11线程 */
    dht11_thread = rt_thread_create("dht11",
                                    dht11_thread_entry,
                                    RT_NULL,
                                    512,
                                    THREAD_PRIORITY + 2,
                                    THREAD_TIMESLICE);
    if (dht11_thread != RT_NULL) {
        rt_thread_startup(dht11_thread);
    }

    /* 创建MQ2线程 */
    mq2_thread = rt_thread_create("mq2",
                                  mq2_thread_entry,
                                  RT_NULL,
                                  512,
                                  THREAD_PRIORITY + 2,
                                  THREAD_TIMESLICE);
    if (mq2_thread != RT_NULL) {
        rt_thread_startup(mq2_thread);
    }

    /* 创建GPS线程 */
    gps_thread = rt_thread_create("gps",
                                  gps_thread_entry,
                                  RT_NULL,
                                  1024,
                                  THREAD_PRIORITY + 3,
                                  THREAD_TIMESLICE);
    if (gps_thread != RT_NULL) {
        rt_thread_startup(gps_thread);
    }

    /* 创建WiFi线程 */
    wifi_thread = rt_thread_create("wifi",
                                   wifi_thread_entry,
                                   RT_NULL,
                                   2048,
                                   THREAD_PRIORITY + 4,
                                   THREAD_TIMESLICE);
    if (wifi_thread != RT_NULL) {
        rt_thread_startup(wifi_thread);
    }

    /* 创建LED线程 */
    rt_thread_t led_thread = rt_thread_create("led",
                                              led_thread_entry,
                                              RT_NULL,
                                              256,
                                              THREAD_PRIORITY + 5,
                                              THREAD_TIMESLICE);
    if (led_thread != RT_NULL) {
        rt_thread_startup(led_thread);
    }

    LOG_I("All sensor threads created successfully");

    return RT_EOK;
}
INIT_APP_EXPORT(sensor_threads_init);

/**
 * @brief MSH命令: 查看传感器数据
 */
static int sensor_read(int argc, char **argv)
{
    rt_mutex_take(sensor_mutex, RT_WAITING_FOREVER);

    rt_kprintf("\n=== 智能安全帽传感器数据 ===\n");
    rt_kprintf("姿态: Pitch=%.1f° Roll=%.1f° Yaw=%.1f°\n",
               g_sensor_data.pitch, g_sensor_data.roll, g_sensor_data.yaw);
    rt_kprintf("心率: %d bpm (有效=%d)\n", g_sensor_data.heart_rate, g_sensor_data.hr_valid);
    rt_kprintf("血氧: %d%% (有效=%d)\n", g_sensor_data.spo2, g_sensor_data.spo2_valid);
    rt_kprintf("温度: %d°C  湿度: %d%%\n", g_sensor_data.temperature, g_sensor_data.humidity);
    rt_kprintf("气体: %.1f ppm (报警=%d)\n", g_sensor_data.gas_ppm, g_sensor_data.gas_alarm);
    rt_kprintf("GPS: Lon=%.4f° Lat=%.4f° (定位=%d)\n",
               g_sensor_data.longitude, g_sensor_data.latitude, g_sensor_data.gps_fixed);
    rt_kprintf("安全: 跌倒=%d 碰撞=%d\n", g_sensor_data.fall_flag, g_sensor_data.collision_flag);
    rt_kprintf("加速度模=%d 陀螺仪模=%d\n", g_sensor_data.avm, g_sensor_data.gvm);

    rt_mutex_release(sensor_mutex);

    return 0;
}
MSH_CMD_EXPORT(sensor_read, Read all sensor data);

int main(void)
{
    LOG_I("Smart Helmet Monitoring System Starting...");
    LOG_I("Hardware: STM32H7R7 @ 600MHz");
    LOG_I("RT-Thread Version: %s", RT_VERSION);

    return RT_EOK;
}

/* 配置中断向量表 */
#include "stm32h7rsxx.h"
static int vtor_config(void)
{
    /* Vector Table Relocation in Internal XSPI2_BASE */
    SCB->VTOR = XSPI2_BASE;
    return 0;
}
INIT_BOARD_EXPORT(vtor_config);
