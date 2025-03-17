#!/usr/bin/env python3

import json
import os
import time
from datetime import datetime

# Директория для логов
LOG_DIR = "/var/log"
# Метрики, которые будем собирать
METRICS = {
    "loadavg": "/proc/loadavg",
    "meminfo": "/proc/meminfo",
    "stat": "/proc/stat",
    "uptime": "/proc/uptime"
}

def collect_metrics():
    metrics = {}
    metrics['timestamp'] = int(time.time())

    for metric, path in METRICS.items():
        try:
            with open(path, 'r') as f:
                if metric == "loadavg":
                    # Сбор информации о средней загрузке системы
                    load = f.read().strip().split()[:3]
                    metrics['load_1min'] = float(load[0])
                    metrics['load_5min'] = float(load[1])
                    metrics['load_15min'] = float(load[2])
                elif metric == "meminfo":
                    # Сбор информации о памяти
                    meminfo = {}
                    for line in f:
                        key = line.split(':')[0]
                        value = line.split(':')[1].strip().split()[0]
                        meminfo[key] = int(value)
                    metrics['mem_total'] = meminfo.get('MemTotal', 0)
                    metrics['mem_free'] = meminfo.get('MemFree', 0)
                    metrics['mem_available'] = meminfo.get('MemAvailable', 0)
                elif metric == "stat":
                    # Сбор информации о CPU
                    cpu_stats = f.readline().split()
                    metrics['cpu_user'] = int(cpu_stats[1])
                    metrics['cpu_system'] = int(cpu_stats[3])
                    metrics['cpu_idle'] = int(cpu_stats[4])
                elif metric == "uptime":
                    # Сбор информации о времени работы системы
                    uptime = float(f.read().strip().split()[0])
                    metrics['uptime'] = uptime
        except Exception as e:
            print(f"Error reading {path}: {e}")

    return metrics

def write_metrics(metrics):
    # Формируем имя файла
    today = datetime.now().strftime("%Y-%m-%d")
    log_file = os.path.join(LOG_DIR, f"{today}-awesome-monitoring.log")

    # Записываем метрики в файл
    try:
        with open(log_file, 'a') as f:
            f.write(json.dumps(metrics) + '\n')
    except Exception as e:
        print(f"Error writing to {log_file}: {e}")

if __name__ == "__main__":
    metrics = collect_metrics()
    write_metrics(metrics)