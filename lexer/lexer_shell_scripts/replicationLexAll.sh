#Run the lexer for all the base types.

#Trees (not that the english trees must be joined seperately + the text only versions must also be generated)
sh lexParseTree.sh  
sh manualTreeLex.sh  

#Natural language corpora
sh engLex.sh     
sh lexOtherNL.sh    

#Code corpora
sh no_collapseLex.sh
sh name_no_collapseLex.sh  

#Specialized English corpora
sh eflLex.sh
sh lexSpecializedEng.sh
