package com.oracle.pic.ocas.generativeai.sample;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.oracle.bmc.ClientConfiguration;
import com.oracle.bmc.ConfigFileReader;
import com.oracle.bmc.auth.AuthenticationDetailsProvider;
import com.oracle.bmc.auth.SessionTokenAuthenticationDetailsProvider;
import com.oracle.bmc.generativeaiinference.GenerativeAiInferenceClient;
import com.oracle.bmc.generativeaiinference.model.ChatDetails;
import com.oracle.bmc.generativeaiinference.model.CohereChatRequest;
import com.oracle.bmc.generativeaiinference.model.CohereMessage;
import com.oracle.bmc.generativeaiinference.model.DedicatedServingMode;
import com.oracle.bmc.generativeaiinference.requests.ChatRequest;
import com.oracle.bmc.generativeaiinference.responses.ChatResponse;
import com.oracle.bmc.generativeaiinference.model.BaseChatRequest.ApiFormat;
import com.oracle.bmc.generativeaiinference.model.ChatChoice;
import com.oracle.bmc.generativeaiinference.model.ChatContent;
import com.oracle.bmc.generativeaiinference.model.ChatContent.Type;
import com.oracle.bmc.generativeaiinference.model.ChatResult;
import com.oracle.bmc.generativeaiinference.model.Message;
import com.oracle.bmc.generativeaiinference.model.OnDemandServingMode;
import com.oracle.bmc.generativeaiinference.model.ServingMode;
import com.oracle.bmc.generativeaiinference.model.TextContent;
import com.oracle.bmc.retrier.RetryConfiguration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
  /**
* This class provides an example of how to use OCI Generative AI Service to generate text.
* <p>
* The Generative AI Service queried by this example will be assigned:
* <ul>
* <li>an endpoint url defined by constant ENDPOINT</li>
* <li>
* The configuration file used by service clients will be sourced from the default
* location (~/.oci/config) and the CONFIG_PROFILE profile will be used.
* </li>
* </ul>
* </p>
*/
@Slf4j
public class ChatExample {
  private static final String ENDPOINT = "https://inference.generativeai.eu-frankfurt-1.oci.oraclecloud.com";
  private static final Region REGION = Region.US_CHICAGO_1;
  private static final String CONFIG_LOCATION = "~/.oci/config";
  // TODO: Please update config profile name and use the compartmentId that has policies grant permissions for using Generative AI Service
  private static final String CONFIG_PROFILE = "<DEFAULT>";
  private static final String COMPARTMENT_ID = "ocid1.compartment.oc1..aaaaaaaa2mlsf3233mmhcmeodalzc3lfsytr6hnhlar36bks5cp7rqwmef4a";
  /**
   * The entry point for the example.
   *
   * @param args Arguments to provide to the example. This example expects no arguments.
   */
  public static void main(String[] args) throws Exception {
      if (args.length > 0) {
          throw new IllegalArgumentException(
                  "This example expects no argument");
      }
      // Configuring the AuthenticationDetailsProvider. It's assuming there is a default OCI config file
      // "~/.oci/config", and a profile in that config with the name defined in CONFIG_PROFILE variable.
      final ConfigFileReader.ConfigFile configFile =  ConfigFileReader.parse(CONFIG_LOCATION, CONFIG_PROFILE);
      final AuthenticationDetailsProvider provider = new ConfigFileAuthenticationDetailsProvider(configFile);
 
      // Set up Generative AI client with credentials and endpoint
      ClientConfiguration clientConfiguration =
          ClientConfiguration.builder()
              .readTimeoutMillis(240000)
              .retryConfiguration(RetryConfiguration.NO_RETRY_CONFIGURATION)
              .build();
      final GenerativeAiInferenceClient generativeAiInferenceClient = new GenerativeAiInferenceClient(provider, clientConfiguration);
      generativeAiInferenceClient.setEndpoint(ENDPOINT);
      generativeAiInferenceClient.setRegion(REGION);
      // Build chat request, send, and get response  
      String message = "{input}";
      CohereChatRequest chatRequest = CohereChatRequest.builder()
        .message(message)
        .maxTokens(600)
        .temperature((double)1)
        .frequencyPenalty((double)0)
        .topP((double)0.63)
        .isStream(false)
        .build();
      ChatDetails details = ChatDetails.builder()
        .servingMode(OnDemandServingMode.builder().modelId("ocid1.generativeaimodel.oc1.eu-frankfurt-1.amaaaaaask7dceyazi3cpmptwa52f7dgwyskloughcxtjgrqre3pngwtig4q").build())
        .compartmentId(COMPARTMENT_ID)
        .chatRequest(chatRequest)
        .build();
      ChatRequest request = ChatRequest.builder()
        .chatDetails(details)
        .build();
        ChatResponse response = generativeAiInferenceClient.chat(request);
        System.out.println(response.toString());
    }
}
has context menu

