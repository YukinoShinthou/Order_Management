
public with sharing class Order__c {

        public String Name { get; set; }
        public Id AccountId { get; set; }
        public Decimal TotalProductCount { get; set; }
        public Decimal TotalPrice { get; set; }

}