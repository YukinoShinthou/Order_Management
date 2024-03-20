
public with sharing class OrderManagementController {

    // Fetch products based on filters
    @AuraEnabled(cacheable=true)
    public static List<Product__c> getProducts(String family, String type, String searchKeyword) {
        String query = 'SELECT Id, Name, Description, Type__c, Family__c, Image__c, Price__c FROM Product__c WHERE ';
        List<String> filters = new List<String>();

        if (!String.isEmpty(family)) {
            filters.add('Family__c = :family');
        }
        if (!String.isEmpty(type)) {
            filters.add('Type__c = :type');
        }
        if (!String.isEmpty(searchKeyword)) {
            filters.add('(Name LIKE \'%' + String.escapeSingleQuotes(searchKeyword) + '%\' OR Description LIKE \'%' + String.escapeSingleQuotes(searchKeyword) + '%\')');
        }

        if (filters.isEmpty()) {
            query += '1=1';
        } else {
            query += String.join(filters, ' AND ');
        }

        return (List<Product__c>) Database.query(query);
    }

    // Create a new order and related order items
    @AuraEnabled
    public static Id createOrder(List<OrderItem__c> items, Id accountId) {
        Order__c newOrder = new Order__c();
        newOrder.AccountId = accountId;
        insert (List<SObject>) newOrder;

        for (OrderItem__c item : items) {
            item.OrderId = newOrder.Id;
        }

        insert (List<SObject>) items;

        // Update total count and price on the order
        newOrder.TotalProductCount = items.size();
        newOrder.TotalPrice = items.sumBy((item) => item.Price__c * item.Quantity__c);
        update (List<SObject>) newOrder;

        return newOrder.Id;
    }

//    @AuraEnabled(Cacheable=true)
//    public static List<Product__c> getFilteredProducts(String family, String type) {
//        // Query products based on provided family and type
//        // Implement your SOQL query here
//        return [SELECT Id, Name, Description, Price FROM Product__c WHERE Family__c = :family AND Type__c = :type];
//    }
//
//    @AuraEnabled(Cacheable=true)
//    public static List<Product__c> searchProducts(String searchTerm) {
//        // Search products by Name and Description
//        // Implement your SOQL query here
//        return [SELECT Id, Name, Description, Price FROM Product__c WHERE Name LIKE :('%' + searchTerm + '%') OR Description LIKE :('%' + searchTerm + '%')];
//    }
//
//    @AuraEnabled
//    public static void addToCart(Id productId) {
//        // Add product to cart logic
//    }
//
//    @AuraEnabled
//    public static void createOrder(List<OrderItem__c> orderItems) {
//        // Create order logic
//    }


}