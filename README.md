# Terraform DevOps Project

This Terraform project provisions an Azure DevOps project with an Angular app repository, a build pipeline, and a release pipeline.

## Prerequisites

Before running this Terraform project, make sure you have the following:

- An Azure DevOps organization URL
- A personal access token (PAT) with the following scopes: Code (read and write), Packaging (read), and Agent Pools (read and manage)
- An environment variable named `AZDO_PERSONAL_ACCESS_TOKEN` containing your PAT

## Usage

To use this Terraform project, follow these steps:

1. Clone this repository to your local machine.
2. Change into the project directory.
3. Run `terraform init -upgrade` to initialize the working directory and upgrade modules and plugins.
4. Run `terraform plan -var="azdo_personal_access_token=$env:AZDO_PERSONAL_ACCESS_TOKEN"` to see the changes that Terraform will make to your infrastructure.
5. If you are satisfied with the changes, run `terraform apply -auto-approve -var="azdo_personal_access_token=$env:AZDO_PERSONAL_ACCESS_TOKEN"` to apply the changes.
6. If you need to approve the plan again, run `terraform plan approve -var="azdo_personal_access_token=$env:AZDO_PERSONAL_ACCESS_TOKEN"`.
7. To destroy the infrastructure provisioned by this project, run `terraform destroy -auto-approve -var="azdo_personal_access_token=$env:AZDO_PERSONAL_ACCESS_TOKEN"`.

Note: Make sure to replace `$env:AZDO_PERSONAL_ACCESS_TOKEN` with the actual value of your Azure DevOps personal access token.

## Inputs

This Terraform project accepts the following input variables:

- `azdo_organization_url`: The URL of the Azure DevOps organization where the project will be created. Defaults to `"https://dev.azure.com/CreadorProyectosOrg/"`.
- `azdo_personal_access_token`: The Azure DevOps personal access token used to authenticate Terraform with the Azure DevOps API.
- `project_name`: The name of the Azure DevOps project to create. Defaults to `"myproject"`.
- `angular_app_repository_name`: The name of the Angular app repository to create in the Azure DevOps project. Defaults to `"myapp"`.
- `project_id`: The ID of the Azure DevOps project to use for creating other resources. This should be set to the ID of the project created by this Terraform project. Defaults to `12345678-90ab-cdef-1234-567890abcdef`.
- `build_pipeline_id`: The ID of the build pipeline to create. Defaults to `1234`.

## Outputs

This Terraform project exports the following output variables:

- `repos_output`: A map of the names and IDs of the Azure DevOps repositories created by this project.

## Authors

Ciprian Ilut (cilut@gmail.com)

## License

This Terraform project is released under the MIT License.
