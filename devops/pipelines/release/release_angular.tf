resource "azuredevops_release_pipeline" "angular_app" {
  project_id = var.project_id
  name = "Angular App Release Pipeline"
  artifact_name = "drop"
  artifact_type = "container"
  artifact_path = "dist/angular-app"

  environment {
    name = "Production"
    rank = 1

    deploy_step {
      task_id = "e2e9d60e-d227-44f3-8e58-7436c07452b8"
      version_spec = "2.*"
      display_name = "Azure App Service Deploy"

      inputs = jsonencode({
        ConnectionType: "AzureRM",
        azureSubscriptionEndpoint: "AzureRM",
        appType: "webAppLinux",
        appName: "angular-app",
        runtimeStack: "NODE|14-lts",
        package: "$(System.DefaultWorkingDirectory)/drop/angular-app.zip",
        startUpCommand: "npm start",
        slotName: "",
        resourceGroupName: "angular-app-rg",
        overwriteAppSettings: true,
        configurationInputs: "{\"WEBSITE_NODE_DEFAULT_VERSION\":\"14.17.1\"}"
      })
    }
  }
}
