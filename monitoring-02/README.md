1. ![1](https://github.com/user-attachments/assets/31fccd08-ecfc-47ef-bec1-6da57a02d13a)

2. ![2](https://github.com/user-attachments/assets/f5592388-e8d7-44c3-8ab4-4a55d096e3c6)

   - утилизация CPU для nodeexporter (в процентах, 100-idle): 100 - (avg by(instance) (rate(node_cpu_seconds_total{job="node_exporter_metrics", mode="idle"}[1m])) * 100)
   - CPULA 1/5/15:	 node_load1{job="node_exporter_metrics", instance="192.168.0.184:9100"}
                     node_load5{job="node_exporter_metrics", instance="192.168.0.184:9100"}
	                   node_load15{job="node_exporter_metrics", instance="192.168.0.184:9100"}
   - количество свободной оперативной памяти: node_memory_MemFree_bytes{job="node_exporter_metrics"}
   - количество места на файловой системе: node_filesystem_avail_bytes{mountpoint="/"}
  
3. ![3](https://github.com/user-attachments/assets/86eca5d6-6d05-4d00-9f24-71fb4d6c866c)
   ![3-1](https://github.com/user-attachments/assets/baf40d66-47a0-4640-9530-ca9fe553b991)

