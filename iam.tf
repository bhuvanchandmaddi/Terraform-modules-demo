module testenv_iam {
  source = "./modules/iam"
  rolename  = "testenvrole"
  envname = "${module.test-vpc.environment}"
  instanceprofilename = "testenv-ins-profile"
}

module devenv_iam {
  source = "./modules/iam"
  rolename  = "devenvrole"
  envname = "${module.dev-vpc.environment}"
  instanceprofilename = "devenv-ins-profile"
}