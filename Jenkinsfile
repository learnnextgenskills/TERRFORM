
node {
 
    // Mark the code checkout 'Checkout'....
    stage 'Checkout'
 
    // // Get some code from a GitHub repository
    //git url: 'git@github.com:myorg/infrastructure.git'
 
    // Get the Terraform tool.
    def tfHome = tool name: 'Terraform', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
    env.PATH = "${tfHome}:${env.PATH}"
    
 
            // Mark the code build 'plan'....
            stage name: 'Plan', concurrency: 1
            // Output Terraform version
            sh "terraform --version"            
            sh "terraform init"
            sh "terraform get"
			sh "terraform plan"
			input message: 'Apply Plan?', ok: 'Apply'
                    apply = true
            
 
            if (apply) {
                stage name: 'Apply', concurrency: 1
                
                sh 'terraform destroy -auto-approve'
                sh 'terraform apply -auto-approve'
                
            }
   // }
}
