[master]
${master_ip}

[workers]
%{ for ip in worker_ips ~}
${ip}
%{ endfor ~}
