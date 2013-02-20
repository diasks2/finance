# [Double Entry Accounting in a Relational Database](http://homepages.tcp.co.uk/~m-wigley/gc_wp_ded.html)

This app is a psuedo double entry accounting finance app.

A ‘single entry’ system is one where the numerical values being stored are only recorded once. In a ‘double entry’ system each value is stored twice, once as a credit (a positive value), once as a debit (a negative value). There are a number of rules that control these values. The main rules are as follows:

1) Every entry into the system must balance – i.e. the sum of any transaction must be zero.  

2) The sum of all the values in the system at any one time must be zero (the ‘trial balance’).  

3) No values can ever be amended or deleted. They must be negated with an opposing entry (a ‘contra’) and re-entered (‘re-booked’). This provides a completely secure audit trail.  


+------------------+-----------+-----------+
|                  |   Debit   |  Credit   |
+------------------+-----------+-----------+
| Asset            | Increase  | Decrease  |
| Liability        | Decrease  | Increase  |
| Income (revenue) | Decrease  | Increase  |
| Expense          | Increase  | Decrease  |
| Capital          | Decrease  | Increase  |
+------------------+-----------+-----------+  


*To seed category and group tables:*  
`$ rake db:seed_fu` 
