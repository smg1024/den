{
  workspaceRule = appId: workspace: {
    "if" = {
      app-id = appId;
      during-aerospace-startup = false;
    };
    run = ["move-node-to-workspace ${workspace}"];
  };

  floatingRule = appId: {
    "if".app-id = appId;
    run = ["layout floating"];
  };
}
