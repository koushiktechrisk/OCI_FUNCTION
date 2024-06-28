/*
 * Copyright (c) 2024, Oracle and/or its affiliates. All rights reserved.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
 */
package com.oracle.idm.agcs.grc.fn.commons.provider;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.oracle.idm.agcs.grc.fn.commons.config.ConnectedSystemConfig;
import com.oracle.idm.agcs.grc.fn.commons.exception.ProcessingFailedException;
import com.oracle.idm.agcs.icfconnectors.commons.util.VaultUtil;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class FAAuthenticationProvider extends AuthenticationProvider {
  @Override
  public String getAuthorizationValue(ConnectedSystemConfig connectedSystemConfig) {
    String authHeader;
    try {
      String vaultJsonValue = VaultUtil.getDataFromVault(connectedSystemConfig.getAuthenticationDetail().get("secretId"), connectedSystemConfig.getAuthenticationDetail().get("region"));
      String clientCode =  VaultUtil.getAttributeValueFromJson(vaultJsonValue, "clientCode");
      String clientSecret = VaultUtil.getAttributeValueFromJson(vaultJsonValue, "clientSecret");
      authHeader = clientCode.concat(":").concat(clientSecret);
    } catch (UnsupportedEncodingException | JsonProcessingException e) {
      System.err.println("Exception occurred while getting secret from vault. " + e.getMessage());
      throw new ProcessingFailedException(
              "Exception occurred while getting secret from vault", e);
    }
    return TOKEN_PREFIX_BASIC
        + Base64.getEncoder().encodeToString(authHeader.getBytes(StandardCharsets.UTF_8));
  }
}
