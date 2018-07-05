import random

def partitionList(toSplit):
    '''
    Split the list randomly into 2 pieces
    '''
    random.seed()
    indicies = set()
    h1 = []
    h2 = []
    #Get half the indicies, choosen randomly
    while(len(indicies) < float(len(toSplit))/2.0):
        indicies.add(random.randint(0, len(toSplit)-1))


    for i in range(0, len(toSplit)):
        if(i in indicies):
            h1.append(toSplit[i])
        else:
            h2.append(toSplit[i])

    return (h1, h2)

