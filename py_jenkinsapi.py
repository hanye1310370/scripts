import jenkins
jenkins_server_url='http://39.106.148.41:8080'
job_name='deploy_erp'
user_id='admin'
api_token='4e88588301e4298bcd8ea01e9cb315fb'
server=jenkins.Jenkins(jenkins_server_url,username=user_id,password=api_token)
param_dict={
            'host':'172.17.237.48',
            'website':'sofa',
            'redis_ip':'172.17.237.48',
            'redis_pw':'123456',
            'redis_port':'6379',
            'db1':'5',
            'db2':'6',
            'db3':'7',
            'DBCONN':'172.17.237.48',
            'DBNAME':'sofa',
            'DBUSER':'sofa',
            'DBUSERPW':'123456'
            }
server.build_job(job_name,parameters=param_dict)
#server.get_job_info(job_name)
#server.get_job_info(job_name)['lastBuild']['number']
#server.get_job_info(job_name,build_number)['result']
