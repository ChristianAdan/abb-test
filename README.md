DOCUMENTATION

•           What technologies were used and what tools are needed to use your solution?

I've used Python, PostgresSQL, Docker, Terraform, Jenkins and AWS cloud

•           How to start this service from scratch using your solution?

Install Docker and Docker Compose and run docker-compose up -d 

•           How to scale number of servers to take more load?

Using Kubernetes to scale and automate escalation and orchestrate everything

•           What is application deployment architecture diagram?

A high-level overview of different components, environments, connections, infra and dependencias of the deployment flow


MONITORING

I would choose Prometheus + Grafana to monitor my application.
Prometheus to add some metrics and Grafana to create panels and dashboard to show them.

I would include metrics on: visitors number, db latency, storage or cpu usage and create some alerts to notify me if something's going wrong.
