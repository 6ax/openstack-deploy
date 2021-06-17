pipeline {
    agent any
    environment { 
        GIT_USER = '6ax'
        GIT_USER_EMAIL = credentials ('github_config_email')
        GIT_USER_TOKEN = credentials ('github_token_default')
        GITHUB_REPO_NAME = 'openstack-deploy.git'
    }
    stages {
        stage ('Get the code from SCM'){
            steps {
                cleanWs()
                sh ('git clone https://github.com/$GIT_USER/$GITHUB_REPO_NAME .')
            }
        }
        stage ('Create Proxmox cloud-init template') {
            environment { 
                SSH_USER = credentials('pve_user')
                SSH_HOST = credentials('proxmox_node_fqdn')
            }
            steps{
                dir("${env.WORKSPACE}/infrastructure_proxmox"){
                    sshagent(['proxmox_ssh_credentials']) {
                        sh ('scp -o StrictHostKeyChecking=no create_cloud_init_teml.sh $SSH_USER@$SSH_HOST:/tmp/create_cloud_init_teml.sh')
                        sh ('ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST chmod +x /tmp/create_cloud_init_teml.sh')
                        sh ('ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_HOST bash /tmp/create_cloud_init_teml.sh')
                    }
                }
            }
        }
        stage ('Terraform up virtual machines from template'){
            environment { 
                TF_VAR_pm_api_url = credentials('pm_api_url') 
                TF_VAR_pm_user = credentials('pm_user') 
                TF_VAR_pm_password = credentials('pm_password')
                TF_VAR_pve_user = credentials('pve_user')
                TF_VAR_pve_password = credentials('pve_password')
                TF_VAR_pve_host = credentials('pve_host')
                TF_VAR_pve_ssh_private_key = credentials('pve_ssh_private_key')
                TF_VAR_domain_name = credentials('domain_name')
                TF_VAR_cloud_init_ssh_public_key = credentials('cloud_init_ssh_public_key')
            }
            steps {
                dir("${env.WORKSPACE}/infrastructure_proxmox/terraform"){
                    sh ('ls -ll') 
                    sh ('terraform init')
                    sh ('terraform apply -auto-approve')
                }
            }
        }
        stage('Saving Terraform State to SCM') {           
            steps {
                sh('git config user.email $GIT_USER_EMAIL')
                sh('git config user.name $GIT_USER')
                sh('git add .')
                sh ('git diff-index --quiet HEAD || git commit -m "Jenkins automatic update commit"')
                sh('git push https://$GIT_USER:$GIT_USER_TOKEN@github.com/$GIT_USER/$GITHUB_REPO_NAME')
            }
        }
    }
}
