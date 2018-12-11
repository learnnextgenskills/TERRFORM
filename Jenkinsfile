node {
 
    // Mark the code checkout 'Checkout'....
    stage 'Checkout'
 
    // // Get some code from a GitHub repository
    //git url: 'git@github.com:myorg/infrastructure.git'
 
    // Get the Terraform tool.
    def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
    env.PATH = "${tfHome}:${env.PATH}"
    //wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
 
            // Mark the code build 'plan'....
            stage name: 'Plan', concurrency: 1
            // Output Terraform version
            sh "terraform --version"
            //Remove the terraform state file so we always start from a clean state
            if (fileExists(".terraform/terraform.tfstate")) {
                sh "rm -rf .terraform/terraform.tfstate"
            }
            if (fileExists("status")) {
                sh "rm status"
            }
            //sh "./init"
            sh "terraform init"
            sh "terraform get"
            
            def exitCode = readFile('status').trim()
            def apply = false
			echo $exitcode
            echo "Terraform Plan Exit Code: ${exitCode}"
            
            
                    input message: 'Apply Plan?', ok: 'Apply'
                    apply = true
                
 
            if (apply) {
                //stage name: 'Apply', concurrency: 1
				sh 'terraform apply plan.out; echo \$? > status.apply'
                unstash 'plan'
                if (fileExists("status.apply")) {
                    sh "rm status.apply"
                }
                sh 'terraform apply plan.out; echo > status.apply'
                def applyExitCode = readFile('status.apply').trim()
                if (applyExitCode == "0") {
                    slackSend channel: '#ci', color: 'good', message: "Changes Applied ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"    
                } else {
                    slackSend channel: '#ci', color: 'danger', message: "Apply Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER} ()"
                    currentBuild.result = 'FAILURE'
                }
            }
   // }
}
