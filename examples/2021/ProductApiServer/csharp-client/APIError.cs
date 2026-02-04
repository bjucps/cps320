using Newtonsoft.Json;

class APIError
{
    [JsonProperty("error")]
    public string Error { get; set; }
   
}
