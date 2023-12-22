# Terraform GCP Infra (VPC - GKE - GAR)

## Conteúdo

1. [Introdução](#introdução)
2. [Recursos](#recursos)
3. [Requisitos](#requisitos)
4. [Como Usar](#como-usar)
5. [Personalizações](#personalizações)
6. [Projeto no GCP](#projeto-no-gcp)

## Introdução

Repositório de IaC (Infrastructure as Code) utilizando terraform no GCP.

## Recursos

Lista dos principais recursos provisionados por este projeto:

- **Google Artifact Registry (GAR):** Um artifact registry criado com o objetivo de armazenar diversos repositorios de imagens de todos os serviços contruidos para o projeto.
- **Virtual Private Cloud (VPC):** Uma VPC criada através do modulo `terraform-google-modules/network/google`.
- **Subnets:** Duas Subnets criadas dentro da VPC com o range principal utilizando a mascara de rede /28 e dois ranges secundarios utilizando a mascara de rede /24, sendo um range destinado aos containers e outro para a cada de serviço.
- **Google Kubernetes Engine (GKE):** Cluster de Kubernetes provisionado para hospedar todos os serviços que comtemplam uma plataform.

## Requisitos

Lista de pré-requisitos para usar ou implantar este projeto:
- Ferramentas:
    - [cli do google cloud](https://cloud.google.com/sdk/docs/install-sdk?hl=pt-br)
    - [plugin para autenticação no GKE](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke)
    - [terraform](https://developer.hashicorp.com/terraform/install)

## Como Usar

Instruções passo a passo sobre como implantar ou usar o projeto. Inclua comandos Terraform, variáveis a serem configuradas, etc.

```bash
# Exemplo de comando de autenticação no GCP utilizando o gcloud cli
$ gcloud auth login

# Exemplo de comandos de implantação no ambiente especificado
$ terraform init -backend-config=backend/[env].tfbackend
$ terraform get -update
$ terraform plan -var-file=variables/[env].tfenv
$ terraform apply -var-file=variables/[env].tfenv
```

## Personalizações

Dentro do diretório `variables/` pode existir um arquivo de variaveis de ambiente para cada ambiente do projeto. Nessas variaveis de ambiente incluimos as configurações que podem variar entre os ambiente como por exemplo: Ranges de redes diferentes, nome do ambiente, id do projeto, número de nodes.

Dentro do diretório `backend/` pode existir um arquivo que contem o bucket e prefixo que será armazenado o arquivo de estado do terraform de cada ambiente criado para este projeto.

Para executar o projeto de terraform em cada ambiente basta alterar o nome do arquivo de backend no comando de `terraform init` e alterar o nome do arquivo de variaveis nos comandos de `terraform plan` e `terraform apply`