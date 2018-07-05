TYPE_ORDER = ["Name", "Keyword", "Operator", "Literal"]

def remapType(fullType):
    if(fullType == "Token.Operator"):
        return("Operator")   
    elif(fullType == "Token.Operator.Word"):
        return("Operator")
    elif(fullType == "Token.Punctuation"):
        return("Operator")
    elif(fullType == "Token.Name"):
        return("Name")
    elif(fullType == "Token.Name.Attribute"):
        return("Name")      
    elif(fullType == "Token.Name.Class"):
        return("Name")      
    elif(fullType == "Token.Name.Decorator"): #@Test and @Override in Java. Exclusively used in Java.
        return("Name") 
    elif(fullType == "Token.Name.Builtin"): #This is () in haskell, not really a name.  I'm also mapping other non words in Keyword.Type to here. In C, these are NULL, false and true
        return("Operator")   #This might be a name in other languages, though...  
    elif(fullType == "Token.Name.Function"):
        #return("Function")  
        return("Name")    
    elif(fullType == "Token.Name.Label"):
        return("Name")      
    elif(fullType == "Token.Name.Namespace"):
        return("Name")
    elif(fullType == "Token.Keyword"):
        return("Keyword")
    elif(fullType == "Token.Keyword.Constant"): #These are true, false, and null in Java
        return("Literal") #Whether this should be a keyword or a literal is up for debate.
    elif(fullType == "Token.Keyword.Declaration"):
        return("Keyword")
    elif(fullType == "Token.Keyword.Namespace"):
        return("Keyword")
    elif(fullType == "Token.Keyword.Reserved"):
        return("Keyword")
    elif(fullType == "Token.Keyword.Type"): #These are void, int, etc in Java, but are much more expanded in Haskell
        return("Name")
    elif(fullType == "Token.Literal"):
        return("Literal")
    elif(fullType == "Token.Literal.Number.Float"):
        return("Literal")
    elif(fullType == "Token.Literal.Number.Hex"):
        return("Literal")
    elif(fullType == "Token.Literal.Number.Integer"):
        return("Literal")
    elif(fullType == "Token.Literal.Number.Oct"):
        return("Literal")
    elif(fullType == "Token.Literal.String"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Char"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Escape"):
        return("Literal")
    elif(fullType == "Token.Error"): #Pygments lexer error?
        return("Error")
    elif(fullType == "Token.Name.Exception"): #specifically the built-in function "error" in haskell
        #return("Function")
        return("Name")
    elif(fullType == "Token.Name.Constant"):
        return("Name")
    elif(fullType == "Token.Literal.String.Symbol"):
        return("Literal")
    elif(fullType == "Token.Name.Builtin.Pseudo"):
        return("Name")
    elif(fullType == "Token.Literal.String.Double"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Interpol"):
        return("Literal")
    elif(fullType == "Token.Name.Variable"):
        return("Name")
    elif(fullType == "Token.Text"): #, or ,,, in Clojure
        return("Operator")
    elif(fullType == "Token.Keyword.Pseudo"): #"attr" in Ruby 
        return("Keyword") 
    elif(fullType == "Token.Literal.Number.Bin"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Backtick"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Heredoc"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Other"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Regex"):
        return("Literal")
    elif(fullType == "Token.Literal.String.Single"):
        return("Literal")
    elif(fullType == "Token.Name.Operator"): #Small number of operators in Ruby
        return("Operator")
    elif(fullType == "Token.Name.Variable.Class"):
        return("Name")
    elif(fullType == "Token.Name.Variable.Global"):
        return("Name") #The examples I've seen have strange syntax, but these are global variables in Ruby.
    elif(fullType == "Token.Name.Variable.Instance"):
        return("Name")
    elif(fullType == "Token.Name.Other"): 
        return("Name") # But this is the result of minimized code in Java script (var -> $)...
    else:
        return(fullType)