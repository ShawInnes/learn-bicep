param resourcePrefix string

resource wafPolicy 'Microsoft.Network/frontdoorwebapplicationfirewallpolicies@2020-11-01' = {
  name: resourcePrefix
  location: 'Global'
  sku: {
    name: 'Classic_AzureFrontDoor'
  }
  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: 'Prevention'
      customBlockResponseStatusCode: 403
      requestBodyCheck: 'Enabled'
    }
    customRules: {
      rules: []
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'DefaultRuleSet'
          ruleSetVersion: '1.0'
          ruleGroupOverrides: [
            {
              ruleGroupName: 'RFI'
              rules: [
                {
                  action: 'Log'
                  enabledState: 'Enabled'
                  ruleId: '931130' // Possible Remote File Inclusion
                }
              ]
            }
            {
              ruleGroupName: 'SQLI'
              rules: [
                {
                  action: 'Log'
                  enabledState: 'Enabled'
                  ruleId: '942430' // Restricted SQL Character Anomaly Detection
                }
                {
                  action: 'Log'
                  enabledState: 'Enabled'
                  ruleId: '942440' // SQL Comment Sequence Detected
                }
              ]
            }
          ]
          exclusions: []
        }
      ]
    }
  }
}
