[teamcity-server]
teamcity-server ansible_host=${cicd_nat_ip}

[teamcity-agents]
teamcity-agent1 ansible_host=${cicd-agent_nat_ip}