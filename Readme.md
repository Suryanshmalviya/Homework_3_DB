Part D: Transactions and Data Integrity 

Q. Explain why transactions are important in real systems such as banking, education 
platforms, or e-commerce. 

Answer. Why transactions matter: In real life like banking, if you are transferring 
        money and the system crashes halfway, you could lose money. Transactions make 
        sure either everything saves or nothing does.

Part E: Short Concept Questions (Answer in Your Own Words)

18. Explain the difference between DELETE and TRUNCATE. 

Answer. DELETE removes rows one by one and can be undone with ROLLBACK. TRUNCATE 
        removes everything at once and resets auto-increment. DELETE is slower but 
        selective, TRUNCATE is fast but deletes everything.

19. Why are foreign keys important for data integrity? Give a real-world example. 

Answer. Without foreign keys, we could have grades for students who do not exist or 
        courses that were deleted. For example, if we delete a student but their 
        grades remain, we would have orphaned data. Foreign keys prevent this. 

20. What is the advantage of normalization in this schema?

Answer. If we did not normalize, we would repeat student info in every grade record. 
        If a student changes their email, we would have to update it everywhere. 
        Normalization keeps each piece of data in one place - much cleaner.