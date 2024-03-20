
public with sharing class OrderItem__c {
    public Id OrderId { get; set; }
    public Id ProductId { get; set; }
    public Decimal Quantity { get; set; }
    public Decimal Price { get; set; }
}