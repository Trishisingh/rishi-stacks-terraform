# EKS Cluster 
#############
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16"

  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  enable_irsa                     = true # var.enable_irsa
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_enabled_log_types = ["scheduler", "controllerManager", "authenticator", "audit", "api"]

  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = module.eks_kms_key.arn
  }

  # OIDC Identity provider
  cluster_identity_providers = {
    sts = {
      client_id = "sts.amazonaws.com"
    }
  }

  # Determines whether to manage the aws-auth configma
  # aws-auth configmap
  manage_aws_auth_configmap = var.manage_aws_auth_configmap

  aws_auth_users = var.map_users

  eks_managed_node_group_defaults = {
    disk_size = 50
  }
  eks_managed_node_groups = {
    general = {
      desired_size = var.eks_desired_nodes
      min_size     = var.eks_desired_nodes
      max_size     = 10

      labels = {
        role = "general"
      }

      instance_types = ["${var.eks_node_size}"]
      capacity_type  = "ON_DEMAND"
    }

  }

  tags = var.tags
}

# KMS 
#####
module "eks_kms_key" {
  source = "../../resource_modules/identity/kms_key"

  name                    = local.eks_kms_key_name
  description             = local.eks_kms_key_description
  deletion_window_in_days = local.eks_kms_key_deletion_window_in_days
  tags                    = local.eks_kms_key_tags
  policy                  = data.aws_iam_policy_document.eks_secret_encryption_kms_key_policy.json
  enable_key_rotation     = true

}