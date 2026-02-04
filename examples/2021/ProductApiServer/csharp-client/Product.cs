using Newtonsoft.Json;

class Product
{
    [JsonProperty("id")]
    public int Id { get; set; }

    [JsonProperty("description")]
    public string Description { get; set; }

    [JsonProperty("price")]
    public double Price { get; set; }
    
}
