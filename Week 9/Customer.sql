db.createCollection("Customer");

db.Customer.insertMany([
{custid: 1, acc_bal:10000, acc_type:"Saving"},
{custid: 1, acc_bal:20000, acc_type: "Checking"},
{custid: 3,acc_bal:50000, acc_type: "Checking"},
{custid: 4, acc_bal:10000,acc_type: "Saving"},
{custid: 5, acc_bal:2000, acc_type: "Checking"}]);

db.Customer.find({acc_bal: {$gt: 12000}, acc_type:"Checking"});

db.Customer.aggregate([{$group:{_id:"$custid", minBal:{$min:"$acc_bal"}, maxBal:{$max:"$acc_bal"}}}]);
