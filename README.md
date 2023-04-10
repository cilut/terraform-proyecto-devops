# Terraform example for Azure DevOps

This Terraform project provides an example of how to create an Azure DevOps project with various resources, including a wiki, dashboards, work items, repositories with branch policies, and build and release pipelines for an Angular app.

## Requirements

To run this Terraform project, you'll need the following:

- Terraform v0.15 or later
- An Azure DevOps organization and project
- An Azure service principal with permissions to create resources in your Azure DevOps project

## Usage

1. Clone this repository to your local machine.
2. Update the `variables.tf` file with your Azure DevOps project and service principal information.
3. Update the `work_items.json` file with the desired work items for your project.
4. Run `terraform init` to initialize the Terraform workspace.
5. Run `terraform plan` to preview the changes that Terraform will make to your Azure DevOps project.
6. Run `terraform apply` to apply the changes to your Azure DevOps project.

## Project structure

This Terraform project is structured as follows:

- `main.tf`: Creates the Azure DevOps project and sets up access levels.
- `wiki.tf`: Creates the wiki and adds some initial pages.
- `dashboards.tf`: Creates some sample dashboards for the project.
- `work_items.tf`: Creates work items based on the `work_items.json` file.
- `repositories.tf`: Creates a repository for the Angular app and sets branch policies.
- `build.tf`: Creates a build pipeline for the Angular app.
- `release.tf`: Creates a release pipeline for the Angular app.
- `variables.tf`: Defines the variables used in the Terraform code.
- `work_items.json`: Defines the work items for the project.

## Conclusion

This Terraform project provides an example of how to create an Azure DevOps project with various resources, including a wiki, dashboards, work items, repositories with branch policies, and build and release pipelines for an Angular app. By following the instructions in this README file, you can easily set up your own Azure DevOps project using Terraform.
