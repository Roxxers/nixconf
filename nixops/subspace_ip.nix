{ subspace = 
  { ... }: 
  { deployment.targetHost = "10.0.3.1";
    network = {
      description = "staging environment";
      enableRollback = true;
    };
  }; 
}